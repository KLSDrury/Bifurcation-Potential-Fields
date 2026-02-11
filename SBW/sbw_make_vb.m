function out = sbw_make_vb(focal, param1_name, param1_range, ...
                           param2_name, param2_range, grid_size, opts)
% -------------------------------------------------------------------------
% sbw_make_vb
%
% Purpose:
%   Sweep a 2-parameter grid for the spruce budworm (SBW) model and compute
%   V_B as a Euclidean distance in state space from a selected stable
%   equilibrium (focal) to its destabilizing boundary:
%     - if a bounding saddle exists on the relevant side, distance to nearest saddle
%     - otherwise distance to a designated boundary equilibrium (model-specific)
%
% SBW Model (dimensionless form):
%   dx/dτ = r*x*(1 - x/k) - x^2/(1 + x^2)
%
% Inputs:
%   focal        : "low" or "high"
%   param1_name  : e.g. 'k'
%   param1_range : [min max]
%   param2_name  : e.g. 'r'
%   param2_range : [min max]
%   grid_size    : [n1 n2] (n along param1, param2)
%   opts         : (optional) struct with fields:
%       .base_params  (struct) default params (r,k)
%       .save_outputs (true/false) default true
%       .make_plot    (true/false) default true
%       .outdir       (string/char) default: folder of this file
%
% Outputs:
%   out struct with fields:
%     .D, .param1_vals, .param2_vals, .param1_name, .param2_name, .focal, .meta
%
% Requirements (SBW-specific):
%   - find_real_eqa_sbw.m
%   - classify_equilibria_sbw.m
%   - sbw_boundary_equilibrium.m  (provided below)
% -------------------------------------------------------------------------
% Example usage:
%
% (i) Low-x equilibrium, coarse "test grid" (rapid verification)
%     This configuration is intended for debugging, validation of logic,
%     and exploratory testing.  The low-x equilibrium is tracked, and the
%     parameter grid is intentionally coarse to allow fast execution.
%
%     out = sbw_make_vb("low", ...
%                       'k', [0 25], ...
%                       'r', [0 0.8], ...
%                       [40 40]);
%
%     Typical runtime (2026 desktop / laptop):
%       ~1 minute, depending on MATLAB version and solver settings.
%
%
% (ii) High-x equilibrium, fine "publication grid"
%      This configuration reproduces the high-resolution $V_B$ field used
%      in figures.  The high-x (outbreak) equilibrium is selected, and a
%      dense parameter grid is used to resolve sharp geometric features
%      near bifurcation boundaries.
%
%     out = sbw_make_vb("high", ...
%                       'k', [0 25], ...
%                       'r', [0 0.8], ...
%                       [350 350]);
%
%     Typical runtime (2026 desktop / workstation):
%       ~30–90 minutes on a single CPU core.
%       Runtime depends strongly on grid resolution, equilibrium solver
%       convergence, and proximity to bifurcation curves.
%
% Notes:
%   - Coarse grids are strongly recommended for initial testing.
%   - High-resolution sweeps should be run only after verifying equilibrium
%     classification and boundary selection logic.
%   - The computational cost scales approximately linearly with the number
%     of grid points.
% -------------------------------------------------------------------------

% Ensure utilities folder is on path
this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));  % go up from model folder
utilities_path = fullfile(repo_root, 'utilities');
addpath(utilities_path);

% ---- Input handling (compatible with older MATLAB) -----------------------
if nargin < 6
    error('Usage: sbw_make_vb(focal, param1_name, param1_range, param2_name, param2_range, grid_size, [opts])');
end
if nargin < 7
    opts = struct();
end

% defaults
if ~isfield(opts,'base_params'),  opts.base_params = struct('r',0.36,'k',12); end
if ~isfield(opts,'save_outputs'), opts.save_outputs = true; end
if ~isfield(opts,'make_plot'),    opts.make_plot = true; end
if ~isfield(opts,'outdir'),       opts.outdir = ''; end

% normalize + validate focal
if ischar(focal), focal = string(focal); end
focal = lower(string(focal));
if ~(focal=="low" || focal=="high")
    error('focal must be "low" or "high".');
end

% validate parameter names
if ~ischar(param1_name), param1_name = char(param1_name); end
if ~ischar(param2_name), param2_name = char(param2_name); end

% validate ranges
if ~isnumeric(param1_range) || numel(param1_range)~=2
    error('param1_range must be a 2-element numeric vector [min max].');
end
if ~isnumeric(param2_range) || numel(param2_range)~=2
    error('param2_range must be a 2-element numeric vector [min max].');
end

% validate grid_size
if ~isnumeric(grid_size) || numel(grid_size)~=2 || any(grid_size<=0)
    error('grid_size must be a 2-element positive numeric vector [n1 n2].');
end
grid_size = round(grid_size(:).');  % row vector [n1 n2]
% -------------------------------------------------------------------------


    % Directories
    if isempty(opts.outdir)
        my_folder = fileparts(mfilename('fullpath'));
    else
        my_folder = opts.outdir;
    end
    mats_folder = fullfile(my_folder, 'mats');
    figs_folder = fullfile(my_folder, 'figs');
    if ~exist(mats_folder, 'dir'); mkdir(mats_folder); end
    if ~exist(figs_folder, 'dir'); mkdir(figs_folder); end

    % Grid
    param1_vals = linspace(param1_range(1), param1_range(2), grid_size(1));
    param2_vals = linspace(param2_range(1), param2_range(2), grid_size(2));
    [P1, P2] = meshgrid(param1_vals, param2_vals);

    % Output field
    D = NaN(size(P1));

    start_time = tic;
    fprintf('SBW sweep (%s focal) started at %s\n', ...
        focal, string(datetime('now','Format','HH:mm:ss')));

    progress_interval = max(1, round(0.05 * numel(P1)));

    for i = 1:numel(P1)
        % Progress report
        if mod(i, progress_interval) == 0 || i == 1
            fprintf('Progress: %d/%d (%.1f%%), %s=%.4f, %s=%.4f\n', ...
                i, numel(P1), 100*i/numel(P1), ...
                param1_name, P1(i), param2_name, P2(i));
        end

        % Set parameters (honor the provided names)
        params = opts.base_params;
        params.(param1_name) = P1(i);
        params.(param2_name) = P2(i);

        % Compute distance at this parameter pair
        D(i) = sbw_vb_distance_at_params(params, focal);
    end

    % Package output
    out = struct();
    out.model = "SBW";
    out.focal = focal;
    out.D = D;
    out.param1_vals = param1_vals;
    out.param2_vals = param2_vals;
    out.param1_name = param1_name;
    out.param2_name = param2_name;
    out.param1_range = param1_range;
    out.param2_range = param2_range;
    out.meta = struct( ...
        'timestamp', datetime('now'), ...
        'base_params', opts.base_params, ...
        'grid_size', grid_size);

    % Filenames
    base_filename = sprintf( ...
    '%s%.4f_%.4f_%s%.4f_%.4f_grid%dx%d', ...
    param1_name, param1_range(1), param1_range(2), ...
    param2_name, param2_range(1), param2_range(2), ...
    grid_size(1), grid_size(2));


    matfile_path = fullfile(mats_folder, sprintf('D_raw_sbw_%s_%s.mat', focal, base_filename));
    figfile_path = fullfile(figs_folder, sprintf('vb_sbw_%s_%s', focal, base_filename));

    % Save
    if opts.save_outputs
        save(matfile_path, 'D', 'param1_vals', 'param2_vals', ...
            'param1_name', 'param2_name', 'param1_range', 'param2_range', 'focal');
    end

    % Plot
    if opts.make_plot
        fig = figure;
        imagesc(param1_vals, param2_vals, D);
        set(gca,'YDir','normal');
        cmap = parula(256);  % optional: set cmap(1,:) = [1 1 1] if you like NaN as white
        colormap(cmap);
        colorbar;
        xlabel(param1_name);
        ylabel(param2_name);

        if exist('formatSweepPlot','file') == 2
            formatSweepPlot(param1_name, param1_vals, param2_name, param2_vals);
        end

        % Optional saves (leave commented to avoid changing your workflow)
        savefig([figfile_path '.fig']);
        saveas(fig, [figfile_path '.png']);
        % print(fig, [figfile_path '.tiff'], '-dtiff', '-r600');
        % print(fig, [figfile_path '.eps'], '-depsc');
    end

    elapsed_time = toc(start_time);
    fprintf('SBW sweep complete. Elapsed: %.2f s (%.2f min)\n', ...
        elapsed_time, elapsed_time/60);
end

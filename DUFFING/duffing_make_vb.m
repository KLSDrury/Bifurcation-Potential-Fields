function duffing_make_vb(focal, param1_name, param1_range, param2_name, param2_range, grid_size, opts)
% DUFFING_MAKE_VB  Parameter sweep for undamped Duffing equilibrium structure.
%
% Model (2D rewrite):
%   x1' = x2
%   x2' = -a*x1 - b*x1^3 + f
%
% Equilibria satisfy:
%   x2 = 0
%   b*x1^3 + a*x1 - f = 0
%
% VB-like distance:
%   distance in phase space from selected "stable" equilibrium (center; labeled stable)
%   to bounding saddle equilibrium (when present).
%   Since x2=0 at equilibria, distance reduces to |x1_stable - x1_saddle|.
%
% Inputs:
%   focal        - "low" or "high"
%   param1_name  - e.g. 'f' (often x-axis)
%   param1_range - [min, max]
%   param2_name  - e.g. 'a' (often y-axis)
%   param2_range - [min, max]
%   grid_size    - [N1, N2]
%   opts         - struct (optional), fields:
%                 .b (scalar, default 1.0)   % Duffing cubic coefficient
%                 .save_figs (true/false, default true)  % save lines commented
%                 .grid_in_filename (true/false, default true)
%                 .progress_outer_only (true/false, default true)
%
% Example:
%   duffing_make_vb("low", "f", [-4.25 4.25], "a", [-5 0.5], ...
%    [50 50]);


% Ensure utilities folder is on path
this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));  % go up from model folder
utilities_path = fullfile(repo_root, 'utilities');
addpath(utilities_path);

    if nargin < 7, opts = struct(); end
    if ~isfield(opts,'b'), opts.b = 1.0; end
    if ~isfield(opts,'save_figs'), opts.save_figs = true; end
    if ~isfield(opts,'grid_in_filename'), opts.grid_in_filename = true; end
    if ~isfield(opts,'progress_outer_only'), opts.progress_outer_only = true; end

    focal = lower(string(focal));
    if ~(focal=="low" || focal=="high")
        error('focal must be "low" or "high".');
    end

    my_folder = fileparts(mfilename('fullpath'));
    mats_folder = fullfile(my_folder, 'mats');
    figs_folder = fullfile(my_folder, 'figs');
    if ~exist(mats_folder, 'dir'); mkdir(mats_folder); end
    if ~exist(figs_folder, 'dir'); mkdir(figs_folder); end

    % Base parameters (overridden each gridpoint)
    base_params = struct('a', 1.0, 'b', opts.b, 'f', 0.2);

    % Canonical sweep convention for the repo skeleton:
    %   param1_vals = x-axis (horizontal)
    %   param2_vals = y-axis (vertical)
    param1_vals = linspace(param1_range(1), param1_range(2), grid_size(1));
    param2_vals = linspace(param2_range(1), param2_range(2), grid_size(2));

    % Store D as (rows=y, cols=x) to avoid transposes in plotting
    D = NaN(length(param2_vals), length(param1_vals));

    start_time = tic;
    fprintf('Duffing sweep started at %s\n', string(datetime('now','Format','HH:mm:ss')));

    total = numel(D);
    report_every = max(1, round(0.05 * total));
    counter = 0;

    for j = 1:length(param2_vals)   % outer: y-axis
        if opts.progress_outer_only
            fprintf('Outer loop: %s = %.4f  [%d/%d]\n', param2_name, param2_vals(j), j, length(param2_vals));
        end

        for i = 1:length(param1_vals) % inner: x-axis
            counter = counter + 1;

            if ~opts.progress_outer_only
                if mod(counter, report_every) == 0 || counter == 1
                    fprintf('Progress: %d/%d (%.1f%%), %s=%.4f, %s=%.4f\n', ...
                        counter, total, 100*counter/total, ...
                        param1_name, param1_vals(i), param2_name, param2_vals(j));
                end
            end

            params = base_params;
            params.(param1_name) = param1_vals(i);
            params.(param2_name) = param2_vals(j);

            D(j,i) = duffing_vb_distance_at_params(params, focal);
        end
    end

    % Filename
    base_filename = sprintf('%s%.4f_%s%.4f_%s%.4f_%s%.4f', ...
        param1_name, param1_range(1), param1_name, param1_range(2), ...
        param2_name, param2_range(1), param2_name, param2_range(2));

    if opts.grid_in_filename
        base_filename = sprintf('%s_N%dx%d', base_filename, grid_size(1), grid_size(2));
    end

    % include b in filename (since it matters for Duffing)
    if isfield(opts,'b')
        base_filename = sprintf('%s_b%.4f', base_filename, opts.b);
    end

    matfile_path = fullfile(mats_folder, ['D_raw_duffing_' char(focal) '_' base_filename '.mat']);
    figfile_path = fullfile(figs_folder, ['vb_duffing_' char(focal) '_' base_filename]);

    save(matfile_path, 'D', 'param1_vals', 'param2_vals', ...
        'param1_name', 'param2_name', 'param1_range', 'param2_range', 'focal', 'grid_size', 'opts');

    % Plot
    fig = figure;
    imagesc(param1_vals, param2_vals, D, 'AlphaData', ~isnan(D));
    set(gca, 'YDir', 'normal');
    colormap(parula);
    colorbar;
    xlabel(param1_name); ylabel(param2_name);

    formatSweepPlot(param1_name, param1_vals, param2_name, param2_vals);

    if opts.save_figs
        saveas(fig, [figfile_path '.png']);
        savefig([figfile_path '.fig']);
        % print(fig, [figfile_path '.tiff'], '-dtiff', '-r600');
        % print(fig, [figfile_path '.eps'], '-depsc');
    end

    elapsed_time = toc(start_time);
    fprintf('Duffing sweep complete: %.2f s (%.2f min)\n', elapsed_time, elapsed_time/60);
end

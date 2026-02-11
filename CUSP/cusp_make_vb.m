function cusp_make_vb(focal, param1_name, param1_range, param2_name, param2_range, grid_size, opts)
% CUSP_MAKE_VB  Parameter sweep for (unfolded) cusp normal form.
%
%   dx/dt = a + b*x - x^3                (cusp; g = 0)
%   dx/dt = a + b*x + g*x^2 - x^3        (unfolded cusp; g specified in opts)
%
% Produces a V_B-like distance field: distance in phase space from a selected
% stable equilibrium (low/high branch) to its bounding saddle, evaluated over (a,b).
%
% Inputs:
%   focal        - "low" or "high" (which stable equilibrium branch to use)
%   param1_name  - 'a' (expected)
%   param1_range - [amin, amax]
%   param2_name  - 'b' (expected)
%   param2_range - [bmin, bmax]
%   grid_size    - [Na, Nb]
%   opts         - struct (optional), fields:
%                 .g (scalar, default 0)  % set nonzero for unfolded cusp
%                 .save_figs (true/false, default true)
%                 .grid_in_filename (true/false, default true)
%                 .progress_outer_only (true/false, default true)
%
% Example usage:
%   cusp_make_vb("low","a",[-1.5 0.5],"b",[-0.5 1.5],[60 60]);
%   cusp_make_vb("high","a",[-1.5 0.5],"b",[-0.5 1.5],[350 350], struct('g',1,'save_figs',true));

% Ensure utilities folder is on path
this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));  % go up from model folder
utilities_path = fullfile(repo_root, 'utilities');
addpath(utilities_path);

    if nargin < 7, opts = struct(); end
    if ~isfield(opts,'g'), opts.g = 1; end
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
    base_params = struct('a', 0, 'b', 0, 'g', opts.g);

    % Parameter grids (rows = b, cols = a), matching your convention
    b_vals = linspace(param2_range(1), param2_range(2), grid_size(2));  % horizontal axis
    a_vals = linspace(param1_range(1), param1_range(2), grid_size(1));  % vertical axis

    D = NaN(length(b_vals), length(a_vals));

    start_time = tic;
    fprintf('CUSP sweep started at %s\n', string(datetime('now','Format','HH:mm:ss')));

    total = numel(D);
    report_every = max(1, round(0.05 * total));
    counter = 0;

    for a_idx = 1:length(a_vals)

        if opts.progress_outer_only
            fprintf('Outer loop: b (%s) = %.4f  [%d/%d]\n', param2_name, a_vals(a_idx), a_idx, length(a_vals));
        end

        for b_idx = 1:length(b_vals)
            counter = counter + 1;

            if ~opts.progress_outer_only
                if mod(counter, report_every) == 0 || counter == 1
                    fprintf('Progress: %d/%d (%.1f%%), a=%.4f, b=%.4f\n', ...
                        counter, total, 100*counter/total, a_vals(a_idx), b_vals(b_idx));
                end
            end

            params = base_params;
            params.a = a_vals(a_idx);
            params.b = b_vals(b_idx);

            D(a_idx, b_idx) = cusp_vb_distance_at_params(params, focal);
        end
    end

    param1_vals = a_vals;
    param2_vals = b_vals;

    % Filename
    base_filename = sprintf('%s%.4f_%s%.4f_%s%.4f_%s%.4f', ...
        param1_name, param1_range(1), param1_name, param1_range(2), ...
        param2_name, param2_range(1), param2_name, param2_range(2));

    if opts.grid_in_filename
        base_filename = sprintf('%s_N%dx%d', base_filename, grid_size(1), grid_size(2));
    end

    % include g in filename if unfolded
    if isfield(opts,'g') && opts.g ~= 0
        base_filename = sprintf('%s_g%.4f', base_filename, opts.g);
    end

    matfile_path = fullfile(mats_folder, ['D_raw_cusp_' char(focal) '_' base_filename '.mat']);
    figfile_path = fullfile(figs_folder, ['vb_cusp_' char(focal) '_' base_filename]);

    save(matfile_path, 'D', 'param1_vals', 'param2_vals', ...
        'param1_name', 'param2_name', 'param1_range', 'param2_range', 'focal', 'grid_size', 'opts');

    % Plot
    fig = figure;
    imagesc(b_vals, a_vals, D, 'AlphaData', ~isnan(D));
    set(gca, 'YDir', 'normal');
    colormap(parula);
    colorbar;
    xlabel(param2_name); ylabel(param1_name);

    formatSweepPlot(param2_name, param2_vals, param1_name, param1_vals);

    if opts.save_figs
        savefig([figfile_path '.fig']);
        saveas(fig, [figfile_path '.png']);
        % print(fig, [figfile_path '.tiff'], '-dtiff', '-r600');
        % print(fig, [figfile_path '.eps'], '-depsc');
    end

    elapsed_time = toc(start_time);
    fprintf('CUSP sweep complete: %.2f s (%.2f min)\n', elapsed_time, elapsed_time/60);
end

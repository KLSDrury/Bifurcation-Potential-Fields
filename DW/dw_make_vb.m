function dw_make_vb(focal, param1_name, param1_range, param2_name, param2_range, grid_size, opts)
% DW_MAKE_VB  Parameter sweep for double-well normal form.
%
%   dx/dt = a*x - b - x^3
%
% Produces a V_B-like distance field: distance in phase space from a selected
% stable equilibrium (low/high branch) to its bounding saddle, evaluated over (param1,param2).
%
% Canonical orientation for this model:
%   x-axis = param1 (typically beta = b)
%   y-axis = param2 (typically alpha = a)
%
% Inputs:
%   focal        - "low" or "high"
%   param1_name  - typically 'b'
%   param1_range - [bmin, bmax]
%   param2_name  - typically 'a'
%   param2_range - [amin, amax]
%   grid_size    - [N1, N2] where N1 for param1, N2 for param2
%   opts         - struct (optional), fields:
%                 .save_figs (true/false, default true)   % save lines remain commented
%                 .grid_in_filename (true/false, default true)
%                 .progress_outer_only (true/false, default true)
%
% Example:
%   dw_make_vb("low","b",[-1.1 1.1],"a",[0 2],[50 50]);

% Ensure utilities folder is on path
this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));  % go up from model folder
utilities_path = fullfile(repo_root, 'utilities');
addpath(utilities_path);

    if nargin < 7, opts = struct(); end
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
    base_params = struct('a', 1, 'b', 0);

    % Parameter grids:
    %   param1_vals = x-axis (horizontal)
    %   param2_vals = y-axis (vertical)
    param1_vals = linspace(param1_range(1), param1_range(2), grid_size(1));
    param2_vals = linspace(param2_range(1), param2_range(2), grid_size(2));

    % Store D as (rows=y, cols=x) to avoid transposes in plotting
    D = NaN(length(param2_vals), length(param1_vals));

    start_time = tic;
    fprintf('DW sweep started at %s\n', string(datetime('now','Format','HH:mm:ss')));

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

            D(j,i) = dw_vb_distance_at_params(params, focal);
        end
    end

    % Filename
    base_filename = sprintf('%s%.4f_%s%.4f_%s%.4f_%s%.4f', ...
        param1_name, param1_range(1), param1_name, param1_range(2), ...
        param2_name, param2_range(1), param2_name, param2_range(2));

    if opts.grid_in_filename
        base_filename = sprintf('%s_N%dx%d', base_filename, grid_size(1), grid_size(2));
    end

    matfile_path = fullfile(mats_folder, ['D_raw_dw_' char(focal) '_' base_filename '.mat']);
    figfile_path = fullfile(figs_folder, ['vb_dw_' char(focal) '_' base_filename]);

    save(matfile_path, 'D', 'param1_vals', 'param2_vals', ...
        'param1_name', 'param2_name', 'param1_range', 'param2_range', 'focal', 'grid_size');

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
    fprintf('DW sweep complete: %.2f s (%.2f min)\n', elapsed_time, elapsed_time/60);
end

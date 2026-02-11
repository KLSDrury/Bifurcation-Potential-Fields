function d = duffing_vb_distance_at_params(params, focal)
% DUFFING_VB_DISTANCE_AT_PARAMS  Distance from selected "stable" eq to bounding saddle.
%
% Returns NaN when the needed equilibria do not exist.

    eq_pts = find_real_eqa_duffing(params);
    if isempty(eq_pts) || size(eq_pts,1) < 2
        d = NaN;
        return;
    end

    types = classify_equilibria_duffing(eq_pts, params);
    stable_pts = eq_pts(strcmp(types,'stable'), :);
    saddle_pts = eq_pts(strcmp(types,'saddle'), :);

    if isempty(stable_pts) || isempty(saddle_pts)
        d = NaN;
        return;
    end

    % All equilibria have x2=0, so distance reduces to |x1 - x1_saddle|
    stable_x = stable_pts(:,1);
    saddle_x = saddle_pts(:,1);

    switch lower(string(focal))
        case "low"
            x0 = min(stable_x);
            cand = saddle_x(saddle_x > x0);      % saddle to the right
        case "high"
            x0 = max(stable_x);
            cand = saddle_x(saddle_x < x0);      % saddle to the left
        otherwise
            error('focal must be "low" or "high".');
    end

    if isempty(cand)
        d = NaN;
    else
        [~, j] = min(abs(cand - x0));
        d = abs(x0 - cand(j));
    end
end

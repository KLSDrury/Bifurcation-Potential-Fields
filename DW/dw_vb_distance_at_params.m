function d = dw_vb_distance_at_params(params, focal)
% DW_VB_DISTANCE_AT_PARAMS  Distance from selected stable equilibrium to bounding saddle.
%
% Returns NaN when the needed equilibria do not exist.

    eq_pts = find_real_eqa_dw(params);
    if isempty(eq_pts) || numel(eq_pts) < 2
        d = NaN;
        return;
    end

    types = classify_equilibria_dw(eq_pts, params);
    stable_pts = eq_pts(strcmp(types,'stable'));
    saddle_pts = eq_pts(strcmp(types,'saddle'));

    if isempty(stable_pts) || isempty(saddle_pts)
        d = NaN;
        return;
    end

    switch lower(string(focal))
        case "low"
            x0 = min(stable_pts);
            % bounding saddle should be to the right of the low stable point
            cand = saddle_pts(saddle_pts > x0);

        case "high"
            x0 = max(stable_pts);
            % bounding saddle should be to the left of the high stable point
            cand = saddle_pts(saddle_pts < x0);

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

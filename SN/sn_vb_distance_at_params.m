function d = sn_vb_distance_at_params(params, focal)
% SN_VB_DISTANCE_AT_PARAMS  Distance from selected stable equilibrium to saddle.
%
% Returns NaN when equilibria do not exist (outside alpha<0 region).

    eq_pts = find_real_eqa_sn(params);
    if isempty(eq_pts) || numel(eq_pts) < 2
        d = NaN;  % outside real-equilibria region
        return;
    end

    types = classify_equilibria_sn(eq_pts, params);
    stable_pts = eq_pts(strcmp(types,'stable'));
    saddle_pts = eq_pts(strcmp(types,'saddle'));

    if isempty(stable_pts) || isempty(saddle_pts)
        d = NaN;
        return;
    end

    switch lower(string(focal))
        case "low"
            [~, i0] = min(stable_pts);
            x0 = stable_pts(i0);
            cand = saddle_pts(saddle_pts > x0);   % to the right

            fallback = abs(x0 - 2);               % matches old style (lo_x - 2)

        case "high"
            [~, i0] = max(stable_pts);
            x0 = stable_pts(i0);
            cand = saddle_pts(saddle_pts < x0);   % to the left

            fallback = abs(x0 + 2);               % EXACTLY your paper code

        otherwise
            error('focal must be "low" or "high".');
    end

    if isempty(cand)
        d = fallback;
    else
        [~, j] = min(abs(cand - x0));
        d = abs(x0 - cand(j));
    end
end

function d = sbw_vb_distance_at_params(params, focal)
% Compute V_B distance for SBW at a single parameter pair, for chosen focal eq.

    eq_pts = find_real_eqa_sbw(params);
    if isempty(eq_pts)
        d = NaN; return;
    end

    types = classify_equilibria_sbw(eq_pts, params);
    stable_pts = eq_pts(strcmp(types,'stable'));
    saddle_pts = eq_pts(strcmp(types,'saddle'));

    if isempty(stable_pts)
        d = NaN; return;
    end

    % Select focal equilibrium and relevant side for saddle search
    switch lower(string(focal))
        case "low"
            focal_x = min(stable_pts);
            candidate_saddles = saddle_pts(saddle_pts > focal_x);
        case "high"
            focal_x = max(stable_pts);
            candidate_saddles = saddle_pts(saddle_pts < focal_x);
        otherwise
            error('focal must be "low" or "high".');
    end

    if isempty(candidate_saddles)
        xb = sbw_boundary_equilibrium(params, focal);
        d = abs(focal_x - xb);
    else
        [~, idx] = min(abs(candidate_saddles - focal_x));
        saddle = candidate_saddles(idx);
        d = abs(focal_x - saddle);
    end
end

function types = classify_equilibria_sn(eq_pts, params)
% CLASSIFY_EQUILIBRIA_SN  'stable' or 'saddle' via f'(x)=b+2x

    b = params.b;

    types = cell(size(eq_pts));
    for i = 1:length(eq_pts)
        x = eq_pts(i);
        fprime = b + 2*x;

        if fprime < -eps
            types{i} = 'stable';
        elseif fprime > eps
            types{i} = 'saddle';
        else
            types{i} = 'other';
        end
    end
end

function types = classify_equilibria_dw(eq_pts, params)
% CLASSIFY_EQUILIBRIA_DW  'stable' or 'saddle' via f'(x)=a-3x^2

    a = params.a;

    types = cell(size(eq_pts));
    for i = 1:length(eq_pts)
        x = eq_pts(i);
        fprime = a - 3*x^2;

        if fprime < -eps
            types{i} = 'stable';
        elseif fprime > eps
            types{i} = 'saddle';
        else
            types{i} = 'other';
        end
    end
end

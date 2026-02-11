function types = classify_equilibria_cusp(eq_pts, params)
% CLASSIFY_EQUILIBRIA_CUSP  'stable' or 'saddle' via f'(x)=b+2g x - 3x^2

    b = params.b;
    g = params.g;

    types = cell(size(eq_pts));
    for i = 1:length(eq_pts)
        x = eq_pts(i);
        fprime = b + 2*g*x - 3*x^2;

        if fprime < -eps
            types{i} = 'stable';
        elseif fprime > eps
            types{i} = 'saddle';
        else
            types{i} = 'other';
        end
    end
end

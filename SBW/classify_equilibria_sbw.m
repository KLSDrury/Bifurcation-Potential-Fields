function types = classify_equilibria_sbw(eq_pts, params)
% -------------------------------------------------------------------------
% Purpose:
%   Classify each equilibrium point of the 1D SBW model as 'stable' or 'saddle'
%   based on the sign of the derivative of the RHS at that point.
% -------------------------------------------------------------------------

    r = params.r;
    k = params.k;

    types = cell(size(eq_pts));
    for i = 1:length(eq_pts)
        x = eq_pts(i);

        % Derivative of RHS: f'(x)
        fprime = r * (1 - 2*x/k) - (2*x*(1 + x^2) - 2*x^3) / (1 + x^2)^2;

        % Classification with a tolerance for near-zero derivatives
        if abs(x) < 1e-6
            types{i} = 'extinct' ;
        elseif fprime < -eps
            types{i} = 'stable';
        elseif fprime > eps
            types{i} = 'saddle';
        else
            types{i} = 'other';  % degenerate or bifurcation
        end
    end
end

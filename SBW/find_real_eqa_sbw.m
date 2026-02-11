function eq_pts = find_real_eqa_sbw(params)
% -------------------------------------------------------------------------
% Purpose:
%   Find all real equilibria of the 1D SBW model:
%       dx/dt = r*x*(1 - x/k) - x^2 / (1 + x^2)
% -------------------------------------------------------------------------

    % Unpack parameters
    r = params.r;
    k = params.k;

    % Define RHS of the ODE
    f = @(x) r * x .* (1 - x / k) - x.^2 ./ (1 + x.^2);

    % Initial guesses (avoid x = 0 to prevent trivial zero derivative confusion)
    guesses = linspace(0.001, 3 * k, 200);  

    eq_list = [];
    tol = 1e-8;

    for i = 1:length(guesses)
        try
            [sol, fval, exitflag] = fsolve(f, guesses(i), optimset('Display','off', ...
                                                                  'TolX', tol, ...
                                                                  'TolFun', tol));
            if exitflag > 0 && isreal(sol)
                if abs(f(sol)) < tol
                    % Use a relaxed uniqueness tolerance to avoid filtering out
                    % valid but close stable/saddle roots
                    if isempty(eq_list) || all(abs(eq_list - sol) > 1e-6)
                        eq_list(end+1, 1) = sol;
                    end
                end
            end
        catch
            % Skip bad guesses
        end
    end

    % Check if x = 0 is a root (important near bifurcation points)
    if abs(f(0)) < tol && all(abs(eq_list - 0) > 1e-6)
        eq_list(end+1, 1) = 0;
    end

    % Sort for good measure
    eq_pts = sort(eq_list);
end

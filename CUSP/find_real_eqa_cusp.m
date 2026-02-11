function eq_pts = find_real_eqa_cusp(params)
% FIND_REAL_EQA_CUSP  Real equilibria of (unfolded) cusp normal form:
%   dx/dt = a + b*x + g*x^2 - x^3
%
% Equilibria solve:
%   0 = a + b*x + g*x^2 - x^3
%   x^3 - g*x^2 - b*x - a = 0

    a = params.a;
    b = params.b;
    g = params.g;

    coeffs = [1, -g, -b, -a];
    roots_x = roots(coeffs);

    eq_pts = roots_x(abs(imag(roots_x)) < 1e-12);
    eq_pts = sort(real(eq_pts));
end

function eq_pts = find_real_eqa_dw(params)
% FIND_REAL_EQA_DW  Real equilibria of double-well:
%   dx/dt = a*x - b - x^3
% Equilibria solve:
%   -x^3 + a*x - b = 0

    a = params.a;
    b = params.b;

    coeffs = [-1, 0, a, -b];
    roots_x = roots(coeffs);

    eq_pts = roots_x(abs(imag(roots_x)) < 1e-12);
    eq_pts = sort(real(eq_pts));
end

function eq_pts = find_real_eqa_sn(params)
% FIND_REAL_EQA_SN  Real equilibria of unfolded saddle-node normal form:
%   dx/dt = a + (b^2)/4 + b*x + x^2

    a = params.a;
    b = params.b;

    coeffs = [1, b, a + (b^2)/4];
    roots_x = roots(coeffs);

    eq_pts = roots_x(abs(imag(roots_x)) < 1e-12);
    eq_pts = sort(real(eq_pts));
end


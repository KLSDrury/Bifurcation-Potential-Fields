function eq_pts = find_real_eqa_duffing(params)
% FIND_REAL_EQA_DUFFING  Real equilibria of undamped Duffing (2D rewrite).
%
% Equilibria satisfy x2=0 and:
%   b*x1^3 + a*x1 - f = 0
%
% Returns eq_pts as an N x 2 array: [x1, x2].

    a = params.a;
    b = params.b;
    f = params.f;

    % Solve cubic in x1: b x1^3 + a x1 - f = 0
    coeffs = [b, 0, a, -f];
    r = roots(coeffs);

    x1 = r(abs(imag(r)) < 1e-12);
    x1 = sort(real(x1));

    eq_pts = [x1(:), zeros(length(x1),1)];
end

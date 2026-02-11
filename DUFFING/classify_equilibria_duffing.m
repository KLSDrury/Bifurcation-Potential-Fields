function types = classify_equilibria_duffing(eq_pts, params)
% CLASSIFY_EQUILIBRIA_DUFFING  Classify equilibria as 'stable' (center) or 'saddle'.
%
% Jacobian at (x1,0):
%   J = [0, 1;
%        -(a + 3 b x1^2), 0]
%
% Eigenvalues satisfy:
%   lambda^2 = -(a + 3 b x1^2)
%
% So:
%   - if a + 3 b x1^2 > 0  => purely imaginary eigenvalues => center (label as 'stable')
%   - if a + 3 b x1^2 < 0  => real eigenvalues of opposite sign => 'saddle'
%   - near zero => 'other'

    a = params.a;
    b = params.b;

    types = cell(size(eq_pts,1), 1);
    for i = 1:size(eq_pts,1)
        x1 = eq_pts(i,1);

        s = a + 3*b*x1^2;

        if s > eps
            types{i} = 'stable';   % center, by your repo convention
        elseif s < -eps
            types{i} = 'saddle';
        else
            types{i} = 'other';
        end
    end
end

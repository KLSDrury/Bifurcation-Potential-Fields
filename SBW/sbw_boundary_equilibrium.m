function xb = sbw_boundary_equilibrium(params, focal)
% Define which boundary equilibrium acts as the destabilizing boundary
% in monostable regimes for each focal choice.
%
% NOTE: This encodes your current logic:
%   - for high-x focal, fallback is extinction x=0
%   - for low-x focal, fallback is x=k (your "outbreak state" proxy)
%
% If you later decide low-x should fallback to 0 instead, change it here once.

    switch lower(string(focal))
        case "high"
            xb = 0;
        case "low"
            xb = params.k;
        otherwise
            error('focal must be "low" or "high".');
    end
end

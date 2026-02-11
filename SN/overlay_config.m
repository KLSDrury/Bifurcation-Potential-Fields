function C = overlay_config()
% SN overlay configuration (unfolded saddle-node)
%
% SN uses the opposite axis convention:
%   x-axis = alpha
%   y-axis = beta
%
% Therefore:
%   overlay-script 'a' → x-axis
%   overlay-script 'b' → y-axis

C.output_base = "snVBfield";

C.default_curve_files = ["LP_LP(1).mat","LP_LP(2).mat"];

% MatCont row mapping:
%   x(2,:) and x(3,:) are the active parameters
%
% Set these AFTER checking which row matches alpha vs beta
C.matcont_a_row = 2;   % alpha
C.matcont_b_row = 3;   % beta

% IMPORTANT: reverse the axis role mapping
C.x_param = "a";   % x-axis is alpha
C.y_param = "b";   % y-axis is beta
end

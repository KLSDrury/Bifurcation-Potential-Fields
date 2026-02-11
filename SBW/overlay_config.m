function C = overlay_config()
% SBW overlay configuration
%
% Convention for the existing overlay script:
%   - "b" means the parameter plotted on the x-axis
%   - "a" means the parameter plotted on the y-axis
%
% Therefore set:
%   C.matcont_b_row = row in MatCont S.x holding the x-axis parameter
%   C.matcont_a_row = row in MatCont S.x holding the y-axis parameter

C.output_base = "sbwVBfield";

% Put your actual MatCont output filenames here (must be located in SBW/mats/)
% Common MatCont names include LP_*.mat, HB_*.mat, BP_*.mat, etc.
C.default_curve_files = ["LP_LP(1).mat","LP_LP(2).mat"];

% MatCont row mapping:
% For 1D phase (nphase=1), typical layout is:
%   S.x(1,:) = state variable
%   S.x(2,:) = active parameter #1
%   S.x(3,:) = active parameter #2
%
% You MUST set these so that:
%   b_row corresponds to the SBW parameter on the x-axis of your VB plot,
%   a_row corresponds to the SBW parameter on the y-axis of your VB plot.
%
% Start with the typical assumption, then swap if needed after a quick range check.
C.matcont_a_row = 2;   % y-axis parameter
C.matcont_b_row = 3;   % x-axis parameter

% Optional defaults if you want to call overlayBifurcationBoundary with no args
C.x_param = "b";
C.y_param = "a";
end

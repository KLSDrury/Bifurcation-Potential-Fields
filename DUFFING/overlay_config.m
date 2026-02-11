function C = overlay_config()
% Forced Duffing overlay configuration
%
% We use the existing overlay script convention:
%   - "a" means the parameter plotted on the y-axis (Duffing a)
%   - "b" means the parameter plotted on the x-axis (Duffing forcing f)
%
% Therefore: matcont_a_row should point to the row containing Duffing a,
%            matcont_b_row should point to the row containing Duffing f.

C.output_base = "duffingVBfield";

% Put your actual MatCont output filenames here (in DUFF/mats/)
% Examples: ["LP_LP(1).mat","LP_LP(2).mat"] or whatever MatCont saved.
C.default_curve_files = ["LP_LP(1).mat","LP_LP(2).mat"];

% Row mapping in the MatCont 'x' array:
% x(1,:) = state (nphase=1)
% x(2,:), x(3,:) = the two active parameters (order depends on ActiveParams)
%
% SET THESE AFTER A QUICK RANGE CHECK (see note below).
C.matcont_a_row = 3;   % <-- row holding Duffing a (y-axis)
C.matcont_b_row = 4;   % <-- row holding Duffing f (x-axis)

% Optional: lets you call overlayBifurcationBoundary with no args.
% Keep these as 'b'/'a' to match the overlay script’s expected switch.
C.x_param = "b";       % x-axis uses the thing we map as "b" (Duffing f)
C.y_param = "a";       % y-axis uses the thing we map as "a" (Duffing a)
end

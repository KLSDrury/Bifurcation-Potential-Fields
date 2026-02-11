function C = overlay_config()
C.output_base = "cuspVBfield";

% Put the actual filename(s) you placed in CUSP/mats/
C.default_curve_files = ["LP_LP(1).mat","LP_LP(2).mat"];

% MatCont row mapping for your file:
% Usually x(2,:) and x(3,:) are the two active parameters.
% Choose which row is alpha=a and which is beta=b.
C.matcont_a_row = 2;
C.matcont_b_row = 3;

% Optional: only needed if you want to call overlayBifurcationBoundary with no args
C.x_param = "b";
C.y_param = "a";
end

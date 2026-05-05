// dimensions and part for fit testing a U-Green UM106X 5 port 2.5gbe switch.

ug_tray_fit_wall_thickness = 4.0;

ug_width = 160.0;
ug_height = 27.78;
ug_depth = 105.2;

ug_tray_fit_width = ug_width + (2 * ug_tray_fit_wall_thickness);
ug_tray_fit_depth = ug_depth + (2 * ug_tray_fit_wall_thickness);
ug_tray_fit_height = ug_height / 3;


module ug_um106x() {
    cube([ug_width, ug_depth, ug_height]);
}

module ug_um106x_tray_fit() {
    cube([ug_tray_fit_width, ug_tray_fit_depth, ug_tray_fit_height]);
}


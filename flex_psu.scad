//back panel cutout for a flex-atx psu.
//this is just a simple panel with screw hole cutouts and power/fan cutout.
//not the full model, only for power and screw connections.

/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/24r00";
*/

$fn = 64;

panel_thickness = 3.0;
panel_width = 40.3;
panel_height = 81.5;
panel_rim_width = 5;
panel_rim_thickness = 5;

screw_hole_diameter = 3.5; //#6-32 unc
screw_tab_width = 6.5;
screw_tab_height = 6.5;


module basic_panel() {
    difference() {
        cube([panel_width+(2 * panel_rim_width), panel_thickness, panel_height+panel_rim_width], center = false);
        translate([panel_rim_width, -0.1, 0]) {
            cube([panel_width, panel_thickness+0.2, panel_height], center = false);
        }
    }
}

module screw_hole() {
    difference() {
        cube([screw_tab_width, panel_thickness, screw_tab_height], center = false);
        translate([screw_tab_width/2, -0.1, screw_tab_height/2]) {
            rotate([90, 0, 0]) {
                translate([0, 0, -(panel_thickness/2)-0.1]) {
                    %cylinder(h = panel_thickness + 0.2, d = screw_hole_diameter, center = true);
                }
            }
        }
    }
}

basic_panel();
translate([40.3-3.9, 0, 81.5-5.7]) {
    screw_hole();
}
translate([4.6, 0, 4.4]) {
    screw_hole();
}
translate([4.6, 0, 4.4]) {
    screw_hole();
}
translate([4.6, 0, 4.4]) {
    screw_hole();
}
translate([4.6, 0, 4.4]) {
    screw_hole();
}
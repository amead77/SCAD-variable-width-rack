/*
back panel cutout for a flex-atx psu.
this is just a simple panel with screw hole cutouts and power/fan cutout.
not the full model, only for power and screw connections.

I would like to thank Intel for the mechanical drawing, that was almost unprintable.
Both the web version (even after editing the layout) and the pdf version were pixilated
and shit to print.
I do not have  the luxury of a hueg screen or multi-monitor setup, so reading this spec was
not fun. I wasted a whole day of working on this, just going round in circles trying to find
a readable spec.
*/

/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/24r101";
*/

$fn = 64;
flex_debugmode = false; //["true", "false"]
flex_panel_thickness = 3.1;
flex_panel_width = 40.8; //spec is 40.5, but tolerances are +/- 0.3
flex_panel_height = 81.5; //spec is 81.5
flex_panel_rim_width = 5;
flex_panel_rim_thickness = 5;

flex_left_side_panel_y = 100;
flex_left_side_panel_z = 30;
flex_right_side_panel_y = 100;
flex_right_side_panel_z = 81.5;

flex_screw_hole_diameter = 4.2; //#6-32 unc / 3.5mm. oversizing to allow for tolerances
flex_screw_tab_width = 6.5;
flex_screw_tab_height = 6.5;

flex_screw_holes_offset_z = 0.5; //i need to lower the z position of the screw holes for my psu

module flex_basic_panel() {
    cube([flex_panel_width, flex_panel_thickness, 8.0]);
    translate([flex_panel_width-7.8,0 ,0]) {
        cube([7.8, flex_panel_thickness, flex_panel_height]);
    }
}

module flex_screw_hole() {
    cylinder(h = flex_panel_thickness + 0.2, d = flex_screw_hole_diameter, center = true);
}

module flex_gusset(width_x, depth_y, height_z) {
    linear_extrude(height = height_z) {
        polygon(points=[
            [0,0], 
            [width_x,0], 
            [0,depth_y], 
            [0,0]]
        );
    }
}

module flex_side_panel() {
    translate([0, 0, 0]) {
        rotate([0, 270, 0]) {
            flex_gusset(flex_left_side_panel_z, flex_left_side_panel_y, flex_panel_thickness);
        }
    }

/*
    translate([-flex_panel_thickness, 0, 0]) {
        cube([flex_panel_thickness, flex_left_side_panel_y, flex_left_side_panel_z]);
    }

    translate([flex_panel_width, 0, 0]) {
        cube([flex_panel_thickness, flex_right_side_panel_y, flex_right_side_panel_z]);
    }
*/
    
    translate([flex_panel_width+flex_panel_thickness, 0, 0]) {
        rotate([0, 270, 0]) {
            flex_gusset(flex_right_side_panel_z, flex_right_side_panel_y, flex_panel_thickness);
        }
    }


}

module flex_under_panel() {
    if (flex_debugmode) {
        color("red") {
            translate([-flex_panel_thickness, 0, -flex_panel_thickness]) {
                cube([
                    flex_panel_width + (flex_panel_thickness*2), 
                    15, 
                    flex_panel_thickness]);
            }
        }
    }
}

module flex_back_panel() {
    difference() {
        flex_basic_panel();
        translate([4.1, flex_panel_thickness/2, (flex_panel_height-76) - flex_screw_holes_offset_z]) {
            rotate([90, 0, 0]) {
                flex_screw_hole();
            }
        }
        translate([35.9, flex_panel_thickness/2, (flex_panel_height-76) - flex_screw_holes_offset_z]) {
            rotate([90, 0, 0]) {
                flex_screw_hole();
            }
        }
        translate([37, flex_panel_thickness/2, (flex_panel_height-15.2)-flex_screw_holes_offset_z]) {
            rotate([90, 0, 0]) {
                flex_screw_hole();
            }
        }
        translate([35.9, flex_panel_thickness/2, (flex_panel_height-4.4)-flex_screw_holes_offset_z]) {
            rotate([90, 0, 0]) {
                flex_screw_hole();
            }
        }
    }
}

module flex_back_panel_screws() {
    translate([4.1, flex_panel_thickness/2, (flex_panel_height-76) - flex_screw_holes_offset_z]) {
        rotate([90, 0, 0]) {
            flex_screw_hole();
        }
    }
    translate([35.9, flex_panel_thickness/2, (flex_panel_height-76) - flex_screw_holes_offset_z]) {
        rotate([90, 0, 0]) {
            flex_screw_hole();
        }
    }
    translate([37, flex_panel_thickness/2, (flex_panel_height-15.2)-flex_screw_holes_offset_z]) {
        rotate([90, 0, 0]) {
            flex_screw_hole();
        }
    }
    translate([35.9, flex_panel_thickness/2, (flex_panel_height-4.4)-flex_screw_holes_offset_z]) {
        rotate([90, 0, 0]) {
            flex_screw_hole();
        }
    }
}


module flex_itx_mount() {
    flex_back_panel();
    flex_side_panel();
    flex_under_panel();
}

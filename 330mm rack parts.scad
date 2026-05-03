//
// 330mm / 13 inch rack parts. This is for larger format printers, such as Creality K2 plus, Prusa XL etc
// 
// I designed this specifically to allow the rear of the tray to slide into the post.
// This is for added support on the rear, and because other designs with front and rear attachment
// required dismantling the rack to take out a tray with front and rear attachments.
//
// (c) 2026 Adam Mead.
// 

hole_clearance = 0.3; //mm clearance around the 'oles
rack_width = 330;
post_width = 15.875; // standard post width for rack.
u_height = 44.5; // 1U in mm for post
v_post_height = 2; //this is in standard 1U units, not mm.
post_height = u_height * v_post_height; // total height of posts, in mm.
hole_d = 6.0 + hole_clearance; //screw holes dia
hole_offset_x = post_width/2 + hole_d/2; //should be central
hole_offset_z = 12.7; // standard spacing. half this for between 1U sections.
hole_spacing = 15.875; //rail hole spacing

nut_diameter = 10.0 + hole_clearance; //10mm for m6
nut_diameter_point = nut_diameter / cos(30); // diameter of the hexagon nut point to point
nut_thickness = 5.0 + hole_clearance; //5mm for m6

post_slide_width = 3.0; //this is the width of the cutout for the trays to slide into.
post_slide_cutout = 3.2; //this is the height of the cutout for the trays to slide into

post_sliders = 1; //1= add sliders, 0 = no sliders.

VERSION = "2026-05-03r0";

module post(slide_side) {
    cube([post_width, post_width, u_height]);
    if (post_sliders == 1) {
        if (slide_side == 0) {
            post_slider_left();
        } else {
            post_slider_right();
        }
    }
}

module post_slides() {
    difference() {
        cube([post_slide_width, post_width, u_height]);    
        translate([0, 0, (hole_offset_z/2)-(post_slide_cutout/2)]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
        translate([0, 0, (hole_offset_z/2)-(post_slide_cutout/2)+ hole_spacing]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }
        translate([0, 0, (hole_offset_z/2)-(post_slide_cutout/2)+ hole_spacing * 2]) {
            cube([post_slide_cutout, post_width, post_slide_cutout]);
        }

    }
}

module post_slider_left() {
    translate([post_width, 0, 0]) {
        post_slides();
    }
}


module post_slider_right() {
    translate([-post_slide_width, 0, 0]) {
        post_slides();
    }
}


module rail_1u_holes_segment(slide_side) {
// i've bashed this together rather than math it.

    difference() {
        post(slide_side);
        translate([post_width/2, ((post_width)-nut_thickness/2 ), hole_offset_z/2]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }
        translate([post_width/2, ((post_width)-post_width/2 ), hole_offset_z/2]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }

        translate([post_width/2, ((post_width)-nut_thickness/2 ), (hole_offset_z/2) + hole_spacing]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }
        translate([post_width/2, ((post_width)-post_width/2 ), (hole_offset_z/2) + hole_spacing]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }

        translate([post_width/2, ((post_width)-nut_thickness/2 ), (hole_offset_z/2)+ (hole_spacing*2)]) {
            rotate([90,0,0]) {
                cylinder(d=nut_diameter_point, h=nut_thickness, center=true, $fn=6);
            }
        }
        translate([post_width/2, ((post_width)-post_width/2 ), (hole_offset_z/2)+ (hole_spacing*2)]) {
            rotate([90,0,0]) {
                cylinder(d=hole_d, h=post_width, center=true, $fn=32);
            }
        }
    }
}

module rail_1u_holes(slide_side) {
    for (z = [0:v_post_height-1]) {
        translate([0,0,z*u_height]) {
            rail_1u_holes_segment(slide_side);

        }
    }
}

module assembly() {
    render() {
        rail_1u_holes(0);
        
        translate([rack_width - post_width, 0, 0]) {
            rail_1u_holes(1);
        }
        
        translate([post_width, rack_width, 0]) {        
            rotate([0,0,180]) {
                rail_1u_holes(1);
            }
        translate([rack_width - post_width, 0, 0]) {
            rotate([0,0,180]) {
                rail_1u_holes(0);
            }
        }
        }
    }
}



assembly();
//
// ***************************************************************************************
// ***    This is the main file for creating parts, use the customiser in OpenSCAD.    ***
// ***        To create custom trays, look at the other scads for an example           ***
// ***************************************************************************************
//
// 350mm / 14 inch rack parts (by default) This is for larger format printers, such as Creality K2 plus, Prusa XL etc
// This is 350mm from the left edge of the left post, to the right edge of the right post, assuming single posts.
//
// THERE IS NO REQUIREMENT FOR IT TO BE 350mm x 330mm. You can override all of the defaults.
//
// I designed this specifically to allow the rear of the tray to slide into the post.
// This is for added support on the rear, and because other designs with front and rear attachment
// required dismantling the rack to take out a tray with front and rear attachments.
// Before printing, make some small test pieces to check tolerances etc.
//
// (c) 2026 Adam Mead. Licence is in readme.md at the bottom.
// 
//
// The parts...
// Posts. These are in 1U segments. They can be single or double wide. They can also have a slide on one or both sides, for guiding and supporting trays.
// Trays. These are available in 1U, 2U and a variable size. The 1U and 2U ones I created initially to test, the variable one can also have a rear back panel, making it a drawer.
// Panels. These are blanking panels, but the design is also used by the trays. The 0.5U panel isn't actually 0.5U, it is designed to join the top of the posts to the headers/footers.
// Footer/Header. These are added to the post to allow joining the front/rear posts together using the joiner. (optional)
// Joiners. The attach to the footer/header and span the gap between front and rear posts. (optional)
//
// The front panels/trays can have a logo embossed/etched. This is built into the function. See the custom tray for example. "parts-optional/rack custom tray 01.scad".
//
// AI use notes: The variable size tray/panel is part AI created. The rest was 99% me, with some help from AI when getting stuck. I should probably go through and comment my code better :S
// AI is not good at 3d design (yet), so if you want to create custom parts using AI, at least get the basic design done by hand, then get AI to assist with bits you're stuck on.
// I was going to up to github, then realised I had only commented a small part, so AI did ~70% of the comments.



/**
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/06/06r04";
**/

include <parts/rack posts.scad>;
include <parts/rack panels.scad>;
//include <parts/rack defines.scad>; //some of these are overrode below.
//include <parts-optional/rack custom tray 01.scad>;
include <parts-optional/ugreen um106x.scad>; // switch dimensions
include <parts-optional/rpi5.scad>;
include <parts/rack side panel.scad>;
//use <parts/rack side panel.scad>;
include <parts-optional/dell optiplex 3080.scad>;

// Chose the part to make, or assembly to see all
part = "assembly"; // [assembly, post, base joiner, top joiner, variable tray, halfUpanel, 1U panel, 2U panel, variable panel, dell optiplex 3080, post joins, um106x, rpi5, side panel]


/* [Posts and common spacing] */

//how many U high
post_u_height = 6; 

// 1 for double wide, 0 for single wide.
post_doublewide = 1; // [0, 1]

//0 = none, 1 = left, 2 = right, 3 = both.
slide_side = 0; 


//this is for joining rails or header/footer joins. creates a cone on the top of the post, and a matching cone on the bottom of the joiner, to allow them to slot together for easier assembly
cones = 1; // [0, 1]

// set to 0 to not include the footer, 1 to include it. The footer is a small piece at the bottom of the rack
footer_include = 1; // [0, 1]

// if you include the header and or footer, this adds a single extra piece to top and bottom of the posts, which is for the joiner to attach to
header_include = 1; // [0, 1]

// default post and joiner dimensions that used to come transitively from rack defines.
post_width = 15.875; //0.001
u_height = 44.5; //0.1
hole_offset_z = 12.7; //0.1
hole_spacing = 15.875; //0.001
post_slide_width = 3.0; //0.1
post_slide_cutout = 3.2; //0.1
footer_height = 12.7; //0.1
header_height = 12.7; //0.1
post_cone_base_diameter = 10.0; //0.1
post_cone_top_diameter = 4.0; //0.1
post_cone_height = 2.0; //0.1
post_top_cone_clearance = 0.1; //0.1

//mm clearance around the 'oles
hole_clearance = 0.3; //0.01

//screw holes dia
hole_d = 6.0 + hole_clearance; 

//10mm for m6
//nut_diameter = 10.0 + hole_clearance; 

//5mm for m6 ** I increased this from 5 to 6 because my screws are a bit stumpy. extra 1mm embeds it deeper. (that's what she said)
nut_thickness = 6.0 + hole_clearance; 


//rack depth
rack_depth = 330.0; //0.1

//rack width, bear in mind this is outer edge of left post to outer edge of right post, so if you are using double wide posts, or your posts are wider than 15.875mm, you will need to increase this to ensure the trays fit properly. also, if you are using a lot of clearance in the trays, you might need to increase this to ensure the trays fit properly.
rack_width = 350; //0.1

/* [bases, tops, headers, footers.] */

//this is how many supports the base and top joins have. you can have more than just the 4 corners.
base_support_count = 3;

// the top beam for connecting 2 posts/rails together, front to rear.
header_top_beam_thickness = 10.0; // 0.1
// the base beam for connecting 2 posts/rails together, front to rear.
footer_base_beam_thickness = 5.0; // 0.1


//a joining piece for front and rear posts/rails. Recommended you use cones on the posts and these.
base_join = 1; // [0, 1]
top_join = 1; // [0, 1]


/* [Front panel.] */
// ** these are the basic setup for the front panel.

// [[the 2.01 and 2.99 values are because of OpenSCAD customiser, if i put 2.0, it will not allow you to use decimal values, so 2, 3, 4
// is accepted, but 2.5 will not be enterable]

// rounding of the front panel edges. set to 0 for square edges.
front_panel_edge_radius = 2.0; // 0.01

// how thick the front panel is, go too thick and your screws might not reach.
front_panel_thickness = 3.0; // 0.01

//this is per side. 2 or 3 or 4 or 6. for certain panels and hole spacing just play with this.
front_panel_hole_count = 2; 

// this is how many U high the front panel is. 1 = 1U high, 2 = 2U high etc.
front_panel_height = 1.5; //0.1

//adds a reinforcing lip to the top of the front panel, which is where the most stress is when pulling on the tray. this is in mm, and adds to the height of the front panel, so a 1U panel with a 10mm reinforce will be 1U + 10mm high. adjust as needed, but I found that for a 1U panel, 10mm was good for my prints and materials.
front_panel_top_reinforce_mm = 5; // 0.1

//a blanking panel and reinforcement. 0.5U high
base_panel = 1; // [0, 1] 
//a blanking panel and reinforcement. 0.5U high
top_panel = 1; // [0, 1] 


// ** these are the basic setup for the trays, the trays also use the defines from the front panel.
/* [Trays.] */

// how thick the tray base is.
//tray_thickness = 5.0; 

//clearance between trays and posts. added to BOTH sides.
//tray_post_clearance = 0.5; 

// thickness of the side of the tray, the wall.
tray_side_thickness = 2.5; //0.1
tray_slide_thickness = post_slide_cutout - hole_clearance;
tray_side_slides = (slide_side == 1 || slide_side == 3) ? 1 : 0; //this is for whether to add the slide on the left side of the tray, same for right side below.

//this is in hole spacing, 1 = 1 hole up, 2 = 2 holes up etc. 0.25 for a low profile tray. Experiment with the sizes.
tray_side_height = 1.25; //0.01

// set to 0 for no rear panel, 1 for a rear panel. this creates a drawer
tray_back_panel = 0; // [0, 1]

// how far back the tray projects
tray_y = 0.99; //0.01

//this is just for the assembly demo. has no other function other than to show a tray partially slid out.
tray_slide_out = 150; 

/* [Side Panel] */
// set to 1 to add the side panel, 0 for no side panel. the side panel is designed to work with the double wide posts, but can be used with single wide and longer screws if you want.
add_side_panel = 1; // [0, 1]


module side_panel_ass() {
/* 
the side panel, with rpi logo. I set the depth of the logo to 0.01mm so it is basically flat, but enables me to see it
in my slicer software. Because I can see it, I can paint it. Because it is flat, it doesn't require support or complicate printing.
*/
    side_panel(p_c_pattern_hole_dia = 50, p_c_side_panel_logo = true, p_c_side_panel_logo_import_file = "../images-logo/raspberry-pi.svg", p_c_side_panel_logo_depth = 0.01);
}


module assembly() {
/*
this is used to render/see all the bits together, as an example build.
As you scroll down you'll see all the parts being created and positioned.
*/
    render() {

        //POST CREATION
        support_count = (base_support_count < 2) ? 2 : base_support_count;
        for (i = [0:support_count-1]) {
            y_pos = i * (rack_depth - post_width) / (support_count - 1);
            is_rear_post = (i == (support_count - 1));
            post_span_x = (post_doublewide == 1) ? (post_width * 2) : post_width;

            // Left-side post at this support position
            if (post_doublewide == 0) {
                translate([0, y_pos, 0]) {
                    if (is_rear_post) {
                        // Rear posts face the opposite way so nut traps are on the rack-inside face.
                        translate([post_span_x, post_width, 0]) {
                            rotate([0, 0, 180]) {
                                rail_1u_holes(
                                    slide_side = 2, 
                                    doublewide = post_doublewide, 
                                    post_u_height, 
                                    cones,
                                    post_slide_width = post_slide_width,
                                    post_slide_cutout = post_slide_cutout,
                                    hole_d = hole_d,
                                    nut_thickness = nut_thickness
                                );
                            }
                        }
                    } else {
                        rail_1u_holes(
                            slide_side = 1, 
                            doublewide = post_doublewide, 
                            post_u_height, 
                            cones,
                            post_slide_width = post_slide_width,
                            post_slide_cutout = post_slide_cutout,
                            hole_d = hole_d,
                            nut_thickness = nut_thickness
                        );
                    }
                }
            } else {
                translate([-post_width, y_pos, 0]) {
                    if (is_rear_post) {
                        translate([post_span_x, post_width, 0]) {
                            rotate([0, 0, 180]) {
                                rail_1u_holes(
                                    slide_side = 2, 
                                    doublewide = post_doublewide, 
                                    post_u_height, 
                                    cones,
                                    post_slide_width = post_slide_width,
                                    post_slide_cutout = post_slide_cutout,
                                    hole_d = hole_d,
                                    nut_thickness = nut_thickness
                                );
                            }
                        }
                    } else {
                        rail_1u_holes(
                            slide_side = 1, 
                            doublewide = post_doublewide, 
                            post_u_height, 
                            cones,
                            post_slide_width = post_slide_width,
                            post_slide_cutout = post_slide_cutout,
                            hole_d = hole_d,
                            nut_thickness = nut_thickness
                        );
                    }
                }
            }

            // Right-side post at this support position
            translate([rack_width - post_width, y_pos, 0]) {
                if (is_rear_post) {
                    translate([post_span_x, post_width, 0]) {
                        rotate([0, 0, 180]) {
                            rail_1u_holes(
                                slide_side = 1, 
                                doublewide = post_doublewide, 
                                post_u_height, 
                                cones,
                                post_slide_width = post_slide_width,
                                post_slide_cutout = post_slide_cutout,
                                hole_d = hole_d,
                                nut_thickness = nut_thickness
                            );
                        }
                    }
                } else {
                    rail_1u_holes(
                        slide_side = 2, 
                        doublewide = post_doublewide, 
                        post_u_height, 
                        cones,
                        post_slide_width = post_slide_width,
                        post_slide_cutout = post_slide_cutout,
                        hole_d = hole_d,
                        nut_thickness = nut_thickness
                    );
                }
            }
        }
        //END POST CREATION

        // the base joins

        if (base_join == 1) {
            color("blue") {
                if (post_doublewide == 0) {
                    base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    translate([rack_width - post_width, 0, 0]) {
                        base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    }
                } else {
                    translate([-post_width, 0, 0]) {
                        base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    }
                    translate([rack_width - post_width, 0, 0]) {
                        base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
                    }
                }
            }
        }

        //add 0.5U blanking panels to join the lower parts together (not actually 0.5U)
        if (base_panel == 1) {
            translate([0, -front_panel_thickness, -hole_offset_z*2]) {
                color("orange") {
                    blank_05U_front_panel(rack_width = rack_width);
                }
            }
            //also put on on the rear, for added support
             translate([rack_width, rack_depth+front_panel_thickness, -hole_offset_z*2]) {
                rotate([0,0,180]) {
                    color("orange") {
                        blank_05U_front_panel(rack_width = rack_width);
                    }
                }
            }

        }

        // the top joins

        if (top_join == 1) {
            color("blue") {
                if (post_doublewide == 0) {
                    translate([0, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                    translate([rack_width - post_width, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                } else {
                    translate([-post_width, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                    translate([rack_width - post_width, 0, u_height*post_u_height]) {
                        base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness);
                    }
                }
            }
        }

        //add 0.5U blanking panels to join the upper parts together (not actually 0.5U)
        if (top_panel == 1) {
            translate([0, -front_panel_thickness, (u_height*post_u_height)]) {
                color("orange") {
                    blank_05U_front_panel(rack_width = rack_width);
                }
            }
        }
        
        //also put on on the rear, for added support
        
         translate([rack_width, rack_depth+front_panel_thickness, (u_height*post_u_height)]) {
            rotate([0,0,180]) {
                color("orange") {
                    blank_05U_front_panel(rack_width = rack_width);
                }
            }
        }


        //the side panel, use with a doublewide post OR a single wide post and longer screws.
        if (add_side_panel == 1) {
            if (post_doublewide == 0) {
                translate([-c_panel_thickness, 0, 0]) {
                    side_panel_ass();
                }
            } else {
                 translate([-(post_width+ c_panel_thickness), -c_panel_thickness, 0]) {
                    side_panel_ass();
                }
            }
            
        }




        // the trays. These are just for demo purposes. there is a 0.5U one, a 1U one, a 2U one and a variable one.
        // use what you want, the variable one is the better, but the hole spacing for larger sizes can be more annoying
        
        translate([0, -front_panel_thickness, 0]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            color("cyan") {
                blank_variable_tray(1, 0.6, 1, back_panel = tray_back_panel, rack_width = rack_width);

                //blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            }
        }
        translate([0, -(front_panel_thickness+tray_slide_out), u_height]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            //color("red") {
            rpi5_tray(rack_width = rack_width);
            //}
        }
        translate([0, -front_panel_thickness, u_height * 2]) {
        //    blank_1U_front_panel(holes = 3);
        //}
            //color("cyan") {
            //    blank_1U_tray(tray_side_height, front_panel_edge_radius, front_panel_hole_count);
            //}
            ug_um106x_tray(showmodel = true, rack_width = rack_width, front_panel_top_reinforce_mm = front_panel_top_reinforce_mm);
        }
        translate([0, -front_panel_thickness, u_height * 3]) {
/*
            color("orange") {
                blank_variable_tray(panel_u_size = 2, tray_u_size = 1.5, holes = 4, back_panel = 1, rack_width = rack_width, rack_depth = rack_depth);
                //blank_2U_tray(rack_width = rack_width, tray_side_height, front_panel_edge_radius, front_panel_hole_count, rack_depth = rack_depth);
            }
*/
            dell_tray(show_dell = false);

        }
//        translate([0, -front_panel_thickness, u_height * 5]) {
//            color("green") {
//                custom_tray_01();
//            }
//        }
    }
}

module assembly_info_panel() {
/*
Just notes about the assembly, shows when you look at the assembly view.
*/
    panel_w = 420;
    panel_h = 40;
    panel_t = 2;
    text_t = 1;
    text_size = 5.5;
    text_line = 9;

    color("black") {
        translate([0, 0, 0]) {
            rotate([0, 0, 0]) {
                linear_extrude(height = text_t) {
                    text("Assembly view is demo-only. Use Customizer for individual parts.", size = text_size);
                }
            }
        }

        translate([0, -20, 0]) {
            rotate([0, 0, 0]) {
                linear_extrude(height = text_t) {
                    text("Set base_join/top_join for joiners, base_panel/top_panel for blanking panels, add_side_panel for side panel.", size = text_size);
                }
            }
        }

        translate([0, -40, 0]) {
            rotate([0, 0, 0]) {
                linear_extrude(height = text_t) {
                    text("If using post joiners, enable header_include/footer_include so joiners can attach.", size = text_size);
                }
            }
        }
    }
}

// This is the overview assembly, showing a selection of parts together.
if (part == "assembly") {
    assembly();
    translate([-300, -150, 0]) {
        assembly_info_panel();
    }

    echo("The assembly view is for demonstration purposes. use the customiser to create individual parts.");
    echo("If you want top/bottom (front to rear post joiners), set base_join and top_join to 1. If you want the front panel to be a blanking panel, set base_panel and top_panel to 1. If you want the side panel, set add_side_panel to 1.");
    echo("Notes that if you use post joiners, you'll need to use the header_include and footer_include options to add the extra pieces to the top and bottom of the posts for the joiners to attach to.");

}

// the post, with holes and slides if selected.
if (part == "post") {
    render() {
        rail_1u_holes(slide_side = slide_side, doublewide = post_doublewide, post_u_height, cones);
    }
}

// the base joiner for the front/rear posts. by default 2 post supports, but can set supports= to add more (i have 3)
if (part == "base joiner") {
    render() {
        if (post_doublewide == 0) {
            base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
        } else {
            translate([-post_width, 0, 0]) {
                base_joiner(doublewide = post_doublewide, supports = base_support_count, bottom = 1, beam_thickness = footer_base_beam_thickness);
            }
        }
    }
}

// same as base joiner, but goes on top. I use a thicker beam for the top, because i might lift the rack by the top.
if (part == "top joiner") {
    render() {
        if (post_doublewide == 0) {
            base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness, rack_depth = rack_depth);
        } else {
            translate([-post_width, 0, 0]) {
                base_joiner(doublewide = post_doublewide, bottom = 0, supports = base_support_count, beam_thickness = header_top_beam_thickness, rack_depth = rack_depth);
            }
        }
    }
}

// create a basic tray, takes the dimensions from the customiser.
if (part == "variable tray") {
    render() {
        blank_variable_tray(panel_u_size = front_panel_height, tray_u_size = tray_side_height, holes = front_panel_hole_count, back_panel = tray_back_panel, tray_depth_scale = tray_y);
    }
}


// create the 0.5U front panel, which is actually not 0.5U, but is designed to join the top of the posts to the headers/footers.
if (part == "halfUpanel") {
    color("orange") {
        blank_05U_front_panel(rack_width = rack_width);
    }
}

// create the 1U front panel, with holes based on the customiser.
if (part == "1U panel") {
    color("orange") {
        blank_1U_front_panel(holes = front_panel_hole_count, rack_width = rack_width);
    }
}

// create the 2U front panel, with holes based on the customiser.
if (part == "2U panel") {
    color("orange") {
        blank_2U_front_panel(holes = front_panel_hole_count, rack_width = rack_width);
    }
}

// a blank front panel, with height and holes based on the customiser. Note that this is calling the tray function, but in panel mode.
if (part == "variable panel") {
    color("orange") {
        blank_variable_tray(mode = "panel", panel_u_size = front_panel_height, holes = front_panel_hole_count, rack_width = rack_width);
    }
}

/*
the post joins are actually important if you use more than 4 posts. These are screwed to the header/footer pieces on the posts and
screwed to the base/top joiners. Without these, the inner posts have no solid attachment.
// post_base_join_panel(doublewide, thickness)
// Public — compact panel to join one post footprint (or two for doublewide) to a base joiner using 2 holes per post.
// doublewide: 0=single post width, 1=double post width. thickness: panel thickness in mm.
// e.g. post_base_join_panel();
// e.g. post_base_join_panel(doublewide=1, thickness=4);
module post_base_join_panel(doublewide = 0, thickness = front_panel_thickness) {
*/
if (part == "post joins") {
    post_base_join_panel(doublewide = post_doublewide, thickness = front_panel_thickness);
}

// my 2.5gbe switch tray and keystones
if (part == "um106x") {
    render() {
        ug_um106x_tray(showmodel = false, rack_width = rack_width, front_panel_top_reinforce_mm = front_panel_top_reinforce_mm);
    }
}

//my raspberry pi tray, wip
if (part == "rpi5") {
    render() {
        rpi5_tray();
    }
}

// the side panel with rpi logo
if (part == "side panel") {
    render() {
        side_panel(p_c_pattern_hole_dia = 50, p_c_side_panel_logo = true, p_c_side_panel_logo_import_file = "../images-logo/raspberry-pi.svg", p_c_side_panel_logo_depth = 0.01);
        //side_panel();
    }
}

//my dell optiplex 3080 tray. it is just a tray with cutout for the front of the pc. thicker base and reinforcing beams.
if (part == "dell optiplex 3080") {
    render() {
        dell_tray(show_dell = false, 
            rack_width = rack_width, 
            rack_depth = rack_depth
        );
    }
}


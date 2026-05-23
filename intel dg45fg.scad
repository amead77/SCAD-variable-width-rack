/*
 mini-itx intel dg45fg retro board in rack mount tray.

*/


/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/23r49";
*/


include <blank variable tray.scad>;

$fn = 32;

//spec out the holes for mini-itx board

itx_holes = [   
    [0, 0],
    [157.58, 0],
    [0, 154.94],
    [157.48, 132.08]
];

front_panel_thickness = 3.001; //add .001 so the customiser knows to use float instead of int.
tray_thickness = 4.0; //+6.5mm the board base sits at
//this is the diameter for the heat insert, not the screw itself.
itx_heat_insert_diameter = 4.7; //6-32 UNC screw normally. But using metric here. M3.5x0.6 is equiv, but i have M3
itx_heat_insert_outer_diameter = itx_heat_insert_diameter + 4.0;
itx_screw_diameter = 3.0;
itx_screw_length = 6.5; //how far the heat insert and screws go down

//don't adjust. set for mini-itx, use 'actual_board_position_x/y' to position the board within the tray.
itx_board_origin_position_x = 170 - 163.83;
itx_board_origin_position_y = 170 - 165.1;
itx_board_origin_position_z = tray_thickness; 

itx_board_dimensions = [170, 170]; //square board, but this is the max dimensions. holes are within this.
itx_board_clearance = 6.5;
itx_board_thickness = 1.6;

actual_board_position_x = 40;
actual_board_position_y = 10;

board_front_panel_cutout_offset_x = actual_board_position_x + 25;
board_front_panel_cutout_offset_z = 12;
board_front_panel_cutout_x = 133;
board_front_panel_cutout_z = 35;
board_front_panel_cutout_y = front_panel_thickness + 0.2;

module board_front_panel_cutout() {
    translate([board_front_panel_cutout_offset_x, -0.1, board_front_panel_cutout_offset_z]) {
        cube([board_front_panel_cutout_x, board_front_panel_cutout_y, board_front_panel_cutout_z], center = false);
    }
}

module itx_screw_standoff() {
    difference() {
        cylinder(h = itx_board_clearance, d = itx_heat_insert_outer_diameter, center = true);
        cylinder(h = itx_board_clearance, d = itx_heat_insert_diameter, center = true);
    }
}


module itx_holes() {
    for (i = [0 : len(itx_holes) - 1]) {
        translate([itx_holes[i][0], itx_holes[i][1], itx_board_clearance/2]) {
            itx_screw_standoff();
            //cylinder(h = 10, d = itx_screw_diameter + itx_board_clearance, center = true);
        }
    }
}

module itx_screws() {
//    translate([itx_board_origin_position_x, itx_board_origin_position_y, 0]) {

        for (i = [0 : len(itx_holes) - 1]) {
            translate([itx_holes[i][0], itx_holes[i][1], 0])
                cylinder(h = itx_screw_length, d = itx_screw_diameter, center = true);
        }
//    }

}

module itx_board() {
    difference() {
        cube([itx_board_dimensions[0], itx_board_dimensions[1], itx_board_thickness], center = false);
        translate([itx_board_origin_position_x, itx_board_origin_position_y, itx_board_origin_position_z]) {
            //itx_holes();
            itx_screws();
        }
    }
}

module itx_standoff(incl_board = true) {
    if (incl_board) {
        translate([0, 0, itx_board_origin_position_z+itx_board_clearance]) {
            itx_board();
        }
    }

    translate([itx_board_origin_position_x, itx_board_origin_position_y, itx_board_origin_position_z]) {
        itx_holes();
    }
}

render() {
    union() {
        color("lightgray") {
            translate([actual_board_position_x, actual_board_position_y, 0]) {
                itx_standoff(incl_board = true);
            }
        }

        difference() {
            blank_variable_tray(
                mode                    = "tray", //"tray" or "panel"
                panel_u_size            = 2, // front panel height in U
                front_panel_top_reinforce_mm     = 5, //a reinforcing lip at the top of the panel
                front_panel_bottom_reinforce_mm  = 0, //same but bottom. these are on the back of the panel
                tray_u_size             = 1, // side/base height in U. if undef, defaults to panel_u_size. if 0.6 is used, you can get 2 slides per side, 0.5 would only make the sides high enough for 1 slide
                tray_depth_scale        = 1, // 0 to 1, fraction of rack_width. 1 = full rack_width depth (330mm), 0.5 = rack_width/2 depth (165mm), etc.
                holes                   = 2, // mounting holes PER SIDE (2, 3, 4, or 6). I need to revisit this, as '2' would put 4 holes in each side of a 2U panel, but you might only want 2 each side (top/bottom)
                import_file             = "", //used for importing an SVG or STL/3MF onto the front panel face, see variable_front_panel_face_import() parameters below.
                import_type             = "none", //"svg", "stl", or "none"
                import_width            = 0, //if 0, defaults to 50% of the front panel inner width. used for imported SVGs and STLs/3MFs.
                import_height           = 0, //if 0, defaults to 50% of the front panel inner height. used for imported SVGs and STLs/3MFs.
                import_depth            = 0.8, //how far the imported design is embossed (positive) or engraved (negative). if 0, defaults to 0.8mm for SVGs, and 50% of the target width for STLs/3MFs.
                import_offset_x         = 0, //X offset for imported design from exact center of front panel. positive values move right, negative values move left.
                import_offset_z         = 0, //Z offset for imported design from exact center of front panel. positive values move up, negative values move down.
                import_mode             = "emboss", // "emboss" (raised from front face) or "engrave" (cut into front face)
                side_support            = 1, //0 or 1 to add gussets between front panel and sides when panel is taller than sides
                side_support_back       = 140, //how far back the gussets extend (mm)
                side_support_thickness  = 2.0, //normally the same as tray_side_thickness, but can be different if you want thinner gussets
                tray_side_thickness     = 2.0, //thickness of the tray side walls in mm.
                front_panel_thickness   = front_panel_thickness, //consider your screw lengths. 3mm is usually fine for m6x16 screws.
                back_panel              = 0, //0 or 1 to add a rear wall to make a drawer. rear wall height controlled by back_panel_height (in U).
                back_panel_thickness    = 2.0, //the rear wall thickness, if you have back_panel=1.
                back_panel_height       = 1.0, //in U units, converted to mm internally
                back_panel_chamfer      = 0.0, //mm front edge chamfer on the rear wall. primary purpose is for printing overhang angle reduction.
                back_panel_chamfer_ang  = 45.0, //degrees for the rear wall chamfer angle. 45 degrees is a good starting point, but you can adjust as needed. this is only used if back_panel_chamfer > 0.
                tray_thickness          = tray_thickness, //thickness of the tray base in mm.
                rack_width              = 350, //this is the external width of the rack, if single-width, using this and post_width is what determines the panel and tray widths and depths.
                rack_depth              = 330, //this can be different than the width
                post_width              = 15.875, //a normal single-width rack. If using double-width and/or sliders, this will be wider, but calculated automatically based on this.
                hole_d                  = 6.4, //holes sized for m6 screws, but slightly oversized for clearance.
                u_height                = 44.5, //standard U height in mm.
                hole_offset_z           = 12.7, //initial hole offset from the bottom panel/rack post in mm.
                hole_spacing            = 15.875, //spacing between holes in mm, standard U spacing.
                front_panel_undersizing = 0.1, //mm the front panel is undersized by on each edge to ensure it doesn't interfere with other panels
                front_panel_edge_radius = 2.0, //mm radius for front panel edges. set to 0 for sharp edges.
                tray_post_clearance     = 0.5, //0.5mm clearance, this makes 1mm total tray clearance. adjust as needed. modifying this might require tweaking the post_slide_cutout and hole_clearance to ensure the holes still clear properly.
                tray_side_slides        = 1,   //0 or 1 to add side slides that go into the posts. these are designed to fit into the post 
                                                //cutouts defined by post_slide_cutout/width, so adjust those dimensions if you change the slide design.

                post_slide_width        = 3.0, //*these next 2 are for the slides that go into the posts on the rack.
                post_slide_cutout       = 3.2, //*ideally you should create a 1U post for testing the fit of these before printing everything.
                                            //*you would be better off adjusting the post dimensions, rather than changing the tray dimensions, 
                                            //and create posts to fit the trays. making the side slides smaller to fit would make them weaker. 
                                            //So make the post cutouts bigger instead.
                hole_clearance          = 0.3 //clearance around the panel holes, for screwing into the posts.
            );
            color("green") {
                board_front_panel_cutout();
            }
        }
    }
}
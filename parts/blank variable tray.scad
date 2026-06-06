// blank variable tray.scad
// Variable-height front panel and tray modules.
// All rack dimensions are explicit parameters — no external defines file required.
// Default values match the 330mm rack standard (front_panel_thickness=3, rack_width=330, etc.).
//
// Public modules:
//   blank_variable_front_panel(...)  — variable-height blanking front panel
//   blank_variable_tray(...)         — variable-height tray with front panel and side slides
//
// All parameters have sensible defaults so the modules work out of the box for a standard
// 330mm rack, but every dimension can be overridden on the call.


// =============================================================================

//to do
// Panel holes = 2, 
// ** mounting holes PER SIDE (2, 3, 4, or 6).
//
// ** this is defined in the tray and panel function call, but can create undesired hole spacing on >1U panels:
// ** '2' would put 4 holes in each side of a 2U panel, but you might only want 2 each side (top/bottom). This creates holes for EACH U segment.



/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/06/06r01";
*/

function variable_holes_per_u(holes) = (holes >= 6) ? 3 : ((holes >= 4) ? 2 : holes);


// variable_front_panel_hole_at(x_pos, z_pos, post_width, hole_d)
// Subtracts a single screw hole through the front panel at the given X and Z position.
module variable_front_panel_hole_at(
    x_pos,
    z_pos,
    post_width = 15.875,
    hole_d     = 6.3
) {
    translate([x_pos, post_width / 2, z_pos]) {
        rotate([90, 0, 0]) {
            cylinder(d = hole_d, h = post_width, center = true, $fn = 32);
        }
    }
}


// variable_front_panel_holes(panel_height, holes, u_height, hole_offset_z, hole_spacing, post_width, rack_width, hole_d)
// Subtracts the correct pattern of screw holes across a variable-height front panel.
// holes: mounting holes per side (2, 3, 4, or 6).
module variable_front_panel_holes(
    panel_height,
    holes        = 2,
    u_height     = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    post_width   = 15.875,
    rack_width   = 350,
    hole_d       = 6.3
) {
    holes_per_u    = variable_holes_per_u(holes);
    max_u_segments = ceil(panel_height / u_height);

    for (u_seg = [0 : max_u_segments - 1]) {
        if (holes_per_u >= 1) {
            z1 = (u_seg * u_height) + (hole_offset_z / 2);
            if (z1 <= panel_height - (hole_offset_z / 2) + 0.001) {
                variable_front_panel_hole_at(post_width / 2,             z1, post_width, hole_d);
                variable_front_panel_hole_at(rack_width - post_width / 2, z1, post_width, hole_d);
            }
        }
        if (holes_per_u >= 2) {
            z2 = (u_seg * u_height) + (hole_offset_z / 2) + (hole_spacing * 2);
            if (z2 <= panel_height - (hole_offset_z / 2) + 0.001) {
                variable_front_panel_hole_at(post_width / 2,             z2, post_width, hole_d);
                variable_front_panel_hole_at(rack_width - post_width / 2, z2, post_width, hole_d);
            }
        }
        if (holes_per_u >= 3) {
            z3 = (u_seg * u_height) + (hole_offset_z / 2) + hole_spacing;
            if (z3 <= panel_height - (hole_offset_z / 2) + 0.001) {
                variable_front_panel_hole_at(post_width / 2,             z3, post_width, hole_d);
                variable_front_panel_hole_at(rack_width - post_width / 2, z3, post_width, hole_d);
            }
        }
    }
}


// variable_front_panel_body(panel_height, front_panel_thickness, rack_width, front_panel_undersizing, front_panel_edge_radius)
// Generates the solid panel body at the given height in mm, with optional edge rounding.
module variable_front_panel_body(
    panel_height,
    front_panel_thickness            = 3.0,
    rack_width                       = 350,
    post_width                       = 15.875,
    front_panel_undersizing          = 0.1,
    front_panel_edge_radius          = 2.0,
    front_panel_top_reinforce_mm     = 0,
    front_panel_bottom_reinforce_mm  = 0,
    tray_post_clearance              = 0.5,
    reinforce_x_override             = undef,
    reinforce_w_override             = undef
) {
    reinforce_x_default = post_width + tray_post_clearance;
    reinforce_w_default = rack_width - (2 * reinforce_x_default);
    reinforce_x = is_undef(reinforce_x_override) ? reinforce_x_default : reinforce_x_override;
    reinforce_w = is_undef(reinforce_w_override) ? reinforce_w_default : reinforce_w_override;

    if (front_panel_edge_radius > 0) {
        translate([
            front_panel_undersizing + front_panel_edge_radius,
            0,
            front_panel_undersizing + front_panel_edge_radius
        ]) {
            minkowski() {
                cube([
                    rack_width   - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2),
                    front_panel_thickness,
                    panel_height - (front_panel_undersizing * 2) - (front_panel_edge_radius * 2)
                ]);
                rotate([90, 0, 0]) {
                    cylinder(r = front_panel_edge_radius, h = 0.01, center = true, $fn = 32);
                }
            }
        }
    } else {
        translate([front_panel_undersizing, 0, front_panel_undersizing]) {
            cube([
                rack_width   - (front_panel_undersizing * 2),
                front_panel_thickness,
                panel_height - (front_panel_undersizing * 2)
            ]);
        }
    }

    //top reinforcement lip
    if ((front_panel_top_reinforce_mm > 0) && (reinforce_w > 0)) {
        translate([reinforce_x, front_panel_thickness, panel_height - front_panel_top_reinforce_mm]) {
            cube([reinforce_w, front_panel_top_reinforce_mm, front_panel_top_reinforce_mm]);
        }
    }

    //bottom reinforcement lip
    if ((front_panel_bottom_reinforce_mm > 0) && (reinforce_w > 0)) {
        translate([reinforce_x, front_panel_thickness, 0]) {
            cube([reinforce_w, front_panel_bottom_reinforce_mm, front_panel_bottom_reinforce_mm]);
        }
    }
}


// variable_front_panel_face_import(panel_height, import_file, import_type, import_width, import_height, import_depth, import_offset_x, import_offset_z, import_mode, rack_width, front_panel_undersizing)
// Embosses or engraves an SVG or STL/3MF onto the front panel face.
// import_type: "svg", "stl", or "none". import_mode: "emboss" (raised) or "engrave" (cut in).
// Called by blank_variable_front_panel(); not normally used directly.
module variable_front_panel_face_import(
    panel_height,
    import_file             = "",
    import_type             = "none",
    import_width            = 0,
    import_height           = 0,
    import_depth            = 0.8,
    import_offset_x         = 0,
    import_offset_z         = 0,
    import_mode             = "emboss",
    rack_width              = 350,
    front_panel_undersizing = 0.1
) {
    if ((import_type != "none") && (import_file != "")) {
        panel_inner_width  = rack_width   - (front_panel_undersizing * 2);
        panel_inner_height = panel_height - (front_panel_undersizing * 2);

        target_width  = (import_width  > 0) ? import_width  : panel_inner_width  * 0.5;
        target_height = (import_height > 0) ? import_height : panel_inner_height * 0.5;
        target_depth  = (import_depth  > 0) ? import_depth  : 0.8;

        x_pos = front_panel_undersizing + (panel_inner_width  / 2) + import_offset_x;
        z_pos = front_panel_undersizing + (panel_inner_height / 2) + import_offset_z;

        if (import_type == "svg") {
            if (import_mode == "engrave") {
                // Use a tiny overlap so CSG subtraction reliably intersects the panel volume.
                translate([x_pos, target_depth + 0.01, z_pos]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(height = target_depth + 0.02) {
                            resize([target_width, target_height], auto = true) {
                                import(file = import_file, center = true);
                            }
                        }
                    }
                }
            } else {
                // Emboss out from the front face (y = -depth to 0).
                translate([x_pos, 0, z_pos]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(height = target_depth) {
                            resize([target_width, target_height], auto = true) {
                                import(file = import_file, center = true);
                            }
                        }
                    }
                }
            }
        } else {
            // STL/3MF: assumes mesh uses X=width, Z=height, Y=depth.
            y_pos = (import_mode == "engrave") ? (target_depth / 2) : -(target_depth / 2);
            translate([x_pos, y_pos, z_pos]) {
                resize([target_width, target_depth, target_height], auto = false) {
                    import(file = import_file, center = true);
                }
            }
        }
    }
}


// variable_front_panel_face_text(panel_height, panel_text, panel_text_font, panel_text_size, panel_text_depth, panel_text_offset_x, panel_text_offset_z, panel_text_mode, rack_width, front_panel_undersizing)
// Embosses or engraves centered text onto the front panel face.
// panel_text_mode: "emboss" (raised) or "engrave" (cut in).
// Called by blank_variable_front_panel(); not normally used directly.
module variable_front_panel_face_text(
    panel_height,
    panel_text              = "",
    panel_text_font         = "Liberation Mono:style=Bold",
    panel_text_size         = 10,
    panel_text_depth        = 0.8,
    panel_text_offset_x     = 0,
    panel_text_offset_z     = 0,
    panel_text_mode         = "engrave",
    rack_width              = 350,
    front_panel_undersizing = 0.1
) {
    if ((panel_text != "") && (panel_text_size > 0) && (panel_text_depth > 0)) {
        panel_inner_width  = rack_width   - (front_panel_undersizing * 2);
        panel_inner_height = panel_height - (front_panel_undersizing * 2);

        x_pos = front_panel_undersizing + (panel_inner_width  / 2) + panel_text_offset_x;
        z_pos = front_panel_undersizing + (panel_inner_height / 2) + panel_text_offset_z;

        if (panel_text_mode == "engrave") {
            // Use a tiny overlap so CSG subtraction reliably intersects the panel volume.
            translate([x_pos, panel_text_depth + 0.01, z_pos]) {
                rotate([90, 0, 0]) {
                    linear_extrude(height = panel_text_depth + 0.02) {
                        text(
                            panel_text,
                            size = panel_text_size,
                            font = panel_text_font,
                            halign = "center",
                            valign = "center"
                        );
                    }
                }
            }
        } else {
            // Emboss out from the front face (y = -depth to 0).
            translate([x_pos, 0, z_pos]) {
                rotate([90, 0, 0]) {
                    linear_extrude(height = panel_text_depth) {
                        text(
                            panel_text,
                            size = panel_text_size,
                            font = panel_text_font,
                            halign = "center",
                            valign = "center"
                        );
                    }
                }
            }
        }
    }
}


// variable_side_slide(tray_u_size, side, tray_depth, front_panel_thickness, u_height, post_slide_cutout, hole_clearance, hole_offset_z, tray_side_thickness, post_slide_width, post_width, tray_post_clearance, hole_spacing, rack_width)
// Builds the side wall and slide tabs for a variable-height tray.
// tray_u_size: side wall height in U units (can be fractional). side: 0=left, 1=right.
// tray_depth: tray projection depth in mm along Y axis.
module variable_side_slide(
    tray_u_size           = 1,
    side                  = 0,
    add_slides            = 1,
    tray_depth            = 330,
    tray_x0               = undef,
    tray_w                = undef,
    front_panel_thickness = 3.0,
    u_height              = 44.5,
    post_slide_cutout     = 3.2,
    hole_clearance        = 0.3,
    hole_offset_z         = 12.7,
    tray_side_thickness   = 2.0,
    post_slide_width      = 3.0,
    post_width            = 15.875,
    tray_post_clearance   = 0.5,
    hole_spacing          = 15.875,
    rack_width            = 350
) {
    tray_height    = max((u_height * tray_u_size) - 1, post_slide_cutout - hole_clearance);
    tab_height     = post_slide_cutout - hole_clearance;
    z_base         = (hole_offset_z / 2) - (post_slide_cutout / 2.1);
    max_u_segments = ceil(tray_u_size) + 1;

    left_side_x  = is_undef(tray_x0) ? (post_width + post_slide_width + tray_post_clearance) : tray_x0;
    right_side_x = is_undef(tray_w)
        ? (rack_width - post_width - post_slide_width - tray_post_clearance - tray_side_thickness)
        : (left_side_x + tray_w - tray_side_thickness);
    left_slide_x  = left_side_x - post_slide_width;
    right_slide_x = right_side_x + tray_side_thickness;

    if (side == 0) {
        translate([left_side_x, front_panel_thickness, 0]) {
            cube([tray_side_thickness, tray_depth, tray_height]);
        }
        if (add_slides == 1) {
            for (u_seg = [0 : max_u_segments - 1]) {
                for (slot = [0 : 2]) {
                    z_pos = (u_seg * u_height) + z_base + (slot * hole_spacing);
                    if (z_pos + tab_height <= tray_height + 0.001) {
                        translate([left_slide_x, front_panel_thickness, z_pos]) {
                            cube([post_slide_width, tray_depth, tab_height]);
                        }
                    }
                }
            }
        }
    } else {
        translate([right_side_x, front_panel_thickness, 0]) {
            cube([tray_side_thickness, tray_depth, tray_height]);
        }
        if (add_slides == 1) {
            for (u_seg = [0 : max_u_segments - 1]) {
                for (slot = [0 : 2]) {
                    z_pos = (u_seg * u_height) + z_base + (slot * hole_spacing);
                    if (z_pos + tab_height <= tray_height + 0.001) {
                        translate([right_slide_x, front_panel_thickness, z_pos]) {
                            cube([post_slide_width, tray_depth, tab_height]);
                        }
                    }
                }
            }
        }
    }
}


// variable_tray_front_gusset(panel_u_size, tray_u_size, side, support_back, support_thickness, front_panel_thickness, u_height, post_slide_cutout, hole_clearance, post_width, post_slide_width, tray_post_clearance, rack_width)
// Adds a triangular gusset between the front panel and the tray side wall when the panel is taller than the side.
// panel_u_size: front panel height in U. tray_u_size: side wall height in U. side: 0=left, 1=right.
// support_back: how far back the gusset extends (mm). support_thickness: gusset thickness (mm).
module variable_tray_front_gusset(
    panel_u_size          = 1,
    tray_u_size           = 1,
    side                  = 0,
    tray_x0               = undef,
    tray_w                = undef,
    support_back          = 20,
    support_thickness     = 2.0,
    front_panel_thickness = 3.0,
    u_height              = 44.5,
    post_slide_cutout     = 3.2,
    hole_clearance        = 0.3,
    post_width            = 15.875,
    post_slide_width      = 3.0,
    tray_post_clearance   = 0.5,
    rack_width            = 350
) {
    panel_top = (u_height * panel_u_size) - 1;
    tray_top  = max((u_height * tray_u_size) - 1, post_slide_cutout - hole_clearance);
    left_x = is_undef(tray_x0)
        ? (post_width + post_slide_width + tray_post_clearance)
        : tray_x0;
    right_x = is_undef(tray_w)
        ? (rack_width - post_width - post_slide_width - tray_post_clearance - support_thickness)
        : (left_x + tray_w - support_thickness);
    x0 = (side == 0) ? left_x : right_x;
    x1  = x0 + support_thickness;
    y0  = front_panel_thickness;
    y1  = front_panel_thickness + support_back;
    eps = 0.01;

    if ((panel_top > tray_top + 0.01) && (support_back > 0) && (support_thickness > 0)) {
        hull() {
            translate([x0, y0, panel_top - eps]) { cube([support_thickness, eps, eps]); }
            translate([x0, y0, tray_top])        { cube([support_thickness, eps, eps]); }
            translate([x0, y1, tray_top])        { cube([support_thickness, eps, eps]); }
        }
    }
}



//Use blank_variable_tray() instead of calling this directly. See options in the tray.
// blank_variable_front_panel(u_size, holes, import_file, import_type, import_width, import_height, import_depth, import_offset_x, import_offset_z, import_mode, front_panel_thickness, rack_width, post_width, hole_d, u_height, hole_offset_z, hole_spacing, front_panel_undersizing, front_panel_edge_radius)
// generates a variable-height blanking front panel, optionally with an embossed or engraved logo/image.
// u_size: panel height in U units (can be fractional, e.g. 1.5). holes: mounting holes per side (2, 3, 4, or 6).
// import_file: path to SVG or STL file. import_type: "svg", "stl", or "none". import_mode: "emboss" or "engrave".
// All rack dimension parameters have defaults matching the 330mm rack standard.
// e.g. blank_variable_front_panel(u_size=1.5, holes=2);
// e.g. blank_variable_front_panel(u_size=1, front_panel_thickness=20, rack_width=330, u_height=44.5);
// e.g. blank_variable_front_panel(u_size=2, holes=4, import_file="../images-logo/raspberry-pi.svg", import_type="svg", import_mode="emboss");
module blank_variable_front_panel(
    u_size                  = 1,
    front_panel_top_reinforce_mm     = 1,
    front_panel_bottom_reinforce_mm  = 1,
    holes                   = 2,
    import_file             = "",
    import_type             = "none",
    import_width            = 0,
    import_height           = 0,
    import_depth            = 0.8,
    import_offset_x         = 0,
    import_offset_z         = 0,
    import_mode             = "emboss",
    panel_text              = "",
    panel_text_font         = "Liberation Mono:style=Bold",
    panel_text_size         = 10,
    panel_text_depth        = 0.8,
    panel_text_offset_x     = 0,
    panel_text_offset_z     = 0,
    panel_text_mode         = "engrave",
    front_panel_thickness   = 3.0,
    rack_width              = 350,
    post_width              = 15.875,
    hole_d                  = 6.3,
    u_height                = 44.5,
    hole_offset_z           = 12.7,
    hole_spacing            = 15.875,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    tray_post_clearance     = 0.5,
    reinforce_x_override    = undef,
    reinforce_w_override    = undef
) {
    panel_height = u_height * u_size;

    difference() {
        union() {
            variable_front_panel_body(
                panel_height                 = panel_height,
                front_panel_thickness        = front_panel_thickness,
                rack_width                   = rack_width,
                post_width                   = post_width,
                front_panel_undersizing      = front_panel_undersizing,
                front_panel_edge_radius      = front_panel_edge_radius,
                front_panel_top_reinforce_mm = front_panel_top_reinforce_mm,
                front_panel_bottom_reinforce_mm = front_panel_bottom_reinforce_mm,
                tray_post_clearance          = tray_post_clearance,
                reinforce_x_override         = reinforce_x_override,
                reinforce_w_override         = reinforce_w_override
            );
            if (import_mode != "engrave") {
                variable_front_panel_face_import(
                    panel_height,
                    import_file,
                    import_type,
                    import_width,
                    import_height,
                    import_depth,
                    import_offset_x,
                    import_offset_z,
                    import_mode,
                    rack_width,
                    front_panel_undersizing
                );
            }
            if (panel_text_mode != "engrave") {
                variable_front_panel_face_text(
                    panel_height,
                    panel_text,
                    panel_text_font,
                    panel_text_size,
                    panel_text_depth,
                    panel_text_offset_x,
                    panel_text_offset_z,
                    panel_text_mode,
                    rack_width,
                    front_panel_undersizing
                );
            }
        }

        translate([0, -1, 0]) {
            variable_front_panel_holes(
                panel_height,
                holes,
                u_height,
                hole_offset_z,
                hole_spacing,
                post_width,
                rack_width,
                hole_d
            );
        }

        if (import_mode == "engrave") {
            variable_front_panel_face_import(
                panel_height,
                import_file,
                import_type,
                import_width,
                import_height,
                import_depth,
                import_offset_x,
                import_offset_z,
                import_mode,
                rack_width,
                front_panel_undersizing
            );
        }

        if (panel_text_mode == "engrave") {
            variable_front_panel_face_text(
                panel_height,
                panel_text,
                panel_text_font,
                panel_text_size,
                panel_text_depth,
                panel_text_offset_x,
                panel_text_offset_z,
                panel_text_mode,
                rack_width,
                front_panel_undersizing
            );
        }
    }
}


/*
Create a configurable tray or blanking panel using the same variable front-panel
geometry. This can build a plain panel, an open tray, or a tray with rear wall,
side slides, text, imported artwork, front reinforcement lips, and front gussets
depending on the options enabled.
Calling with just blank_variable_tray(); will produce a default 1U tray for the
standard rack dimensions. (default = 350mm wide, 330mm deep, 44.5mm U height, 
15.875mm posts, etc.)
-----
module blank_variable_tray(
    mode = "tray",                          // "tray" builds a tray, "panel" builds only the front panel.
    panel_u_size = 1,                        // Front panel height in U, can be fractional.
    front_panel_top_reinforce_mm = 0,        // Height of the top reinforcement lip behind the panel.
    front_panel_bottom_reinforce_mm = 0,     // Height of the bottom reinforcement lip behind the panel.
    tray_u_size = undef,                     // Tray side height in U; undef makes it match panel_u_size.
    tray_depth_scale = 1,                    // Tray depth as a fraction of rack_depth.
    holes = 2,                               // Mounting holes per side: typically 2, 3, 4, or 6.
    import_file = "",                       // Optional SVG/STL/3MF artwork file for the front panel.
    import_type = "none",                   // Artwork type: "svg", "stl", or "none".
    import_width = 0,                        // Target width for imported artwork; 0 uses auto sizing.
    import_height = 0,                       // Target height for imported artwork; 0 uses auto sizing.
    import_depth = 0.8,                      // Emboss or engrave depth for imported artwork.
    import_offset_x = 0,                     // X offset for imported artwork from panel centre.
    import_offset_z = 0,                     // Z offset for imported artwork from panel centre.
    import_mode = "emboss",                 // "emboss" raises the artwork, "engrave" cuts it in.
    panel_text = "",                        // Optional text placed on the front panel.
    panel_text_font = "Liberation Mono:style=Bold", // Font used for the front-panel text.
    panel_text_size = 10,                    // Font size for the front-panel text.
    panel_text_depth = 0.8,                  // Emboss or engrave depth for the front-panel text.
    panel_text_offset_x = 0,                 // X offset for the text from panel centre.
    panel_text_offset_z = 0,                 // Z offset for the text from panel centre.
    panel_text_mode = "engrave",            // "emboss" or "engrave" for the panel text.
    side_support = 1,                        // 1 adds front gussets when the panel is taller than the tray sides.
    side_support_back = 40,                  // How far back the front gussets extend.
    side_support_thickness = 2.0,            // Thickness of the front gussets.
    tray_side_thickness = 2.0,               // Thickness of the tray side walls.
    front_panel_thickness = 3.0,             // Thickness of the front panel face.
    back_panel = 0,                          // 1 adds a rear wall, turning the tray into more of a drawer.
    back_panel_thickness = 2.0,              // Thickness of the rear wall.
    back_panel_height = 1.0,                 // Rear wall height in U.
    back_panel_chamfer = 0.0,                // Chamfer amount on the front-top edge of the rear wall.
    back_panel_chamfer_ang = 45.0,           // Chamfer angle for the rear wall.
    tray_thickness = 5.0,                    // Thickness of the tray base.
    rack_width = 350,                        // External rack width used to derive tray and panel width.
    rack_depth = 330,                        // External rack depth used to derive tray depth.
    post_width = 15.875,                     // Width of one rack post.
    hole_d = 6.4,                            // Diameter of the panel mounting holes.
    u_height = 44.5,                         // Height of one rack unit in mm.
    hole_offset_z = 12.7,                    // Height from the bottom to the first hole centre.
    hole_spacing = 15.875,                   // Vertical spacing between hole centres.
    front_panel_undersizing = 0.1,           // Amount trimmed from panel edges for fit clearance.
    front_panel_edge_radius = 2.0,           // Corner radius on the front panel.
    tray_post_clearance = 0.5,               // Clearance gap between tray sides and posts.
    tray_side_slides = 1,                    // 1 adds tray side slides that engage the rack posts.
    post_slide_width = 3.0,                  // Width of the tray side slide tabs.
    post_slide_cutout = 3.2,                 // Height of the matching slide cutout profile.
    hole_clearance = 0.3                     // Clearance value used in slide and hole fit calculations.
) {

*/
module blank_variable_tray(
    mode                    = "tray", //"tray" or "panel"
    panel_u_size            = 1, // front panel height in U
    front_panel_top_reinforce_mm     = 0, //a reinforcing lip at the top of the panel
    front_panel_bottom_reinforce_mm  = 0, //same but bottom. these are on the back of the panel
    tray_u_size             = undef, // side/base height in U. if undef, defaults to panel_u_size. if 0.6 is used, you can get 2 slides per side, 0.5 would only make the sides high enough for 1 slide
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
    panel_text              = "", //optional text to add to the front panel
    panel_text_font         = "Liberation Mono:style=Bold", //font for the panel text, using the format "FontName:style=Style". you can use any font installed on your system, and specify the style if needed. check the OpenSCAD documentation for details on font naming and styles.
    panel_text_size         = 10, //font size for the panel text
    panel_text_depth        = 0.8, //depth for engraving the panel text. ignored if panel_text is empty.
    panel_text_offset_x     = 0, //X offset for panel text from exact center. positive values move right, negative values move left.
    panel_text_offset_z     = 0, //Z offset for panel text from exact center. positive values move up, negative values move down.
    panel_text_mode         = "engrave", // "emboss" or "engrave" for the panel text
    side_support            = 1, //0 or 1 to add gussets between front panel and sides when panel is taller than sides
    side_support_back       = 40, //how far back the gussets extend (mm)
    side_support_thickness  = 2.0, //normally the same as tray_side_thickness, but can be different if you want thinner gussets
    tray_side_thickness     = 2.0, //thickness of the tray side walls in mm.
    front_panel_thickness   = 3.0, //consider your screw lengths. 3mm is usually fine for m6x16 screws.
    back_panel              = 0, //0 or 1 to add a rear wall to make a drawer. rear wall height controlled by back_panel_height (in U).
    back_panel_thickness    = 2.0, //the rear wall thickness, if you have back_panel=1.
    back_panel_height       = 1.0, //in U units, converted to mm internally
    back_panel_chamfer      = 0.0, //mm front edge chamfer on the rear wall. primary purpose is for printing overhang angle reduction.
    back_panel_chamfer_ang  = 45.0, //degrees for the rear wall chamfer angle. 45 degrees is a good starting point, but you can adjust as needed. this is only used if back_panel_chamfer > 0.
    tray_thickness          = 5.0, //thickness of the tray base in mm.
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
) {
    mode_resolved = (mode == "panel") ? "panel" : "tray";
    slides_enabled = (tray_side_slides == 1) ? 1 : 0;
    slide_allowance = slides_enabled ? post_slide_width : 0;

    tray_u_size_resolved  = is_undef(tray_u_size) ? panel_u_size : tray_u_size;
    tray_height           = max((u_height * tray_u_size_resolved) - 1, post_slide_cutout - hole_clearance);
    tray_depth            = max(rack_depth * tray_depth_scale, 0.01);
    back_panel_depth      = min(back_panel_thickness, tray_depth);
    back_panel_height_mm  = max((u_height * back_panel_height) - 1, post_slide_cutout - hole_clearance);
    tray_x0          = post_width + tray_post_clearance + slide_allowance;
    tray_w           = rack_width - (2 * tray_x0);

    blank_variable_front_panel(
        panel_u_size,
        front_panel_top_reinforce_mm,
        front_panel_bottom_reinforce_mm,
        holes,
        import_file,
        import_type,
        import_width,
        import_height,
        import_depth,
        import_offset_x,
        import_offset_z,
        import_mode,
        panel_text,
        panel_text_font,
        panel_text_size,
        panel_text_depth,
        panel_text_offset_x,
        panel_text_offset_z,
        panel_text_mode,
        front_panel_thickness,
        rack_width,
        post_width,
        hole_d,
        u_height,
        hole_offset_z,
        hole_spacing,
        front_panel_undersizing,
        front_panel_edge_radius,
        tray_post_clearance,
        reinforce_x_override = tray_x0,
        reinforce_w_override = tray_w
    );

    if (mode_resolved == "tray") {
        translate([tray_x0, 0, front_panel_undersizing]) {
            cube([tray_w, tray_depth + front_panel_thickness, tray_thickness]);
        }

        variable_side_slide(
            tray_u_size_resolved,
            side              = 0,
            add_slides        = slides_enabled,
            tray_depth        = tray_depth,
            tray_x0           = tray_x0,
            tray_w            = tray_w,
            front_panel_thickness = front_panel_thickness,
            u_height          = u_height,
            post_slide_cutout = post_slide_cutout,
            hole_clearance    = hole_clearance,
            hole_offset_z     = hole_offset_z,
            tray_side_thickness = tray_side_thickness,
            post_width        = post_width,
            post_slide_width  = post_slide_width,
            tray_post_clearance = tray_post_clearance,
            hole_spacing      = hole_spacing,
            rack_width        = rack_width
        );
        variable_side_slide(
            tray_u_size_resolved,
            side              = 1,
            add_slides        = slides_enabled,
            tray_depth        = tray_depth,
            tray_x0           = tray_x0,
            tray_w            = tray_w,
            front_panel_thickness = front_panel_thickness,
            u_height          = u_height,
            post_slide_cutout = post_slide_cutout,
            hole_clearance    = hole_clearance,
            hole_offset_z     = hole_offset_z,
            tray_side_thickness = tray_side_thickness,
            post_width        = post_width,
            post_slide_width  = post_slide_width,
            tray_post_clearance = tray_post_clearance,
            hole_spacing      = hole_spacing,
            rack_width        = rack_width
        );

        if (back_panel == 1) {
            // Rear wall to connect side panels; height controlled by back_panel_height (in U).
            translate([tray_x0, front_panel_thickness + tray_depth - back_panel_depth, 0]) {
                chamfer_ang = min(max(back_panel_chamfer_ang, 1), 89);
                back_panel_chamfer_h = min(max(back_panel_chamfer, 0), min(back_panel_height_mm, back_panel_depth * tan(chamfer_ang)));
                back_panel_chamfer_d = back_panel_chamfer_h / tan(chamfer_ang);

                if (back_panel_chamfer_h > 0.001) {
                    difference() {
                        cube([tray_w, back_panel_depth, back_panel_height_mm]);

                        // Remove a triangular prism to chamfer the front-top edge of the rear wall.
                        eps = 0.01;
                        translate([tray_w + eps, 0, 0]) {
                            rotate([0, -90, 0]) {
                                linear_extrude(height = tray_w + (eps * 2)) {
                                    polygon(points = [
                                        [back_panel_height_mm - back_panel_chamfer_h, -eps],
                                        [back_panel_height_mm + eps, back_panel_chamfer_d + eps],
                                        [back_panel_height_mm + eps, -eps]
                                    ]);
                                }
                            }
                        }
                    }
                } else {
                    cube([tray_w, back_panel_depth, back_panel_height_mm]);
                }
            }
        }

        if (side_support == 1) {
            variable_tray_front_gusset(
                panel_u_size,
                tray_u_size_resolved,
                side              = 0,
                tray_x0           = tray_x0,
                tray_w            = tray_w,
                support_back      = side_support_back,
                support_thickness = side_support_thickness,
                front_panel_thickness = front_panel_thickness,
                u_height          = u_height,
                post_slide_cutout = post_slide_cutout,
                hole_clearance    = hole_clearance,
                post_width        = post_width,
                post_slide_width  = post_slide_width,
                tray_post_clearance = tray_post_clearance,
                rack_width        = rack_width
            );
            variable_tray_front_gusset(
                panel_u_size,
                tray_u_size_resolved,
                side              = 1,
                tray_x0           = tray_x0,
                tray_w            = tray_w,
                support_back      = side_support_back,
                support_thickness = side_support_thickness,
                front_panel_thickness = front_panel_thickness,
                u_height          = u_height,
                post_slide_cutout = post_slide_cutout,
                hole_clearance    = hole_clearance,
                post_width        = post_width,
                post_slide_width  = post_slide_width,
                tray_post_clearance = tray_post_clearance,
                rack_width        = rack_width
            );
        }
    }
}

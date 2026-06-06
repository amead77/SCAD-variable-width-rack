# Variable width Rack (default=350mm wide, 330mm deep) - Current Public Module Reference

This file documents the current public callable modules in the four core source files that are enough to build a working rack:

- `parts/rack posts.scad`
- `parts/rack panels.scad`
- `parts/rack side panel.scad`
- `parts/blank variable tray.scad`

If you are building a rack from scratch, the core structural parts are usually:

- `rail_1u_holes()` for posts
- `base_joiner()` for front-to-rear joiners
- `blank_05U_front_panel()` for the front and rear, top and bottom bridging panels - headers/footers to joiners
- `post_base_join_panel()` if you are using extra intermediate posts

Then add either:

- `blank_1U_front_panel()` / `blank_2U_front_panel()` / `blank_variable_tray(mode="panel")` for blanking panels
- `blank_variable_tray()` for trays
- `side_panel()` for optional side panels, adds +5 HP

---

## `parts/rack posts.scad`


### `rail_1u_holes()` - Complete rack post

Builds a complete rack post from stacked 1U sections, including screw holes, rear nut traps, optional slide rails, optional footer/header blocks, and optional alignment cones.

```scad
module rail_1u_holes(
    slide_side,                             // 0 = none, 1 = left, 2 = right, 3 = both side rails.
    doublewide = 0,                         // 0 = single-width post, 1 = double-width post.
    post_height = 3,                        // Post height in U units.
    v_post_cones = 1,                       // 1 = add top cones and bottom sockets, 0 = no cones.
    include_footer = 1,                     // 1 = include the lower footer block.
    include_header = 1,                     // 1 = include the upper header block.
    post_width = 15.875,                    // Width/depth of one post section.
    u_height = 44.5,                        // Height of one U section in mm.
    hole_d = 6.3,                           // Diameter of the post mounting holes.
    hole_offset_z = 12.7,                   // Height from the bottom of a 1U segment to the first hole centre.
    hole_spacing = 15.875,                  // Vertical spacing between hole centres within a 1U segment.
    nut_thickness = 6.3,                    // Depth of the rear nut traps.
    nut_diameter_across_flats = 10.3,       // Across-flats size of the hex nut trap.
    post_slide_width = 3.0,                 // Width of the side slide rail.
    post_slide_cutout = 3.2,                // Size of the slide cutouts in each 1U section.
    footer_height = 12.7,                   // Height of the optional footer block.
    header_height = 12.7,                   // Height of the optional header block.
    post_cone_base_diameter = 10.0,         // Diameter at the base of the alignment cone/socket.
    post_cone_top_diameter = 4.0,           // Diameter at the tip of the alignment cone/socket.
    post_cone_height = 2.0,                 // Height/depth of the alignment cone/socket.
    post_top_cone_clearance = 0.1           // Clearance applied so cones fit into sockets.
)
```

Examples:

```scad
rail_1u_holes(slide_side = 1, post_height = 6);
rail_1u_holes(slide_side = 3, doublewide = 1, post_height = 6, v_post_cones = 1);
```

### `base_joiner()` - Front-to-rear joiner

Builds the horizontal joiner that connects front and rear posts. Set `bottom=1` for the lower joiner and `bottom=0` for the upper joiner.

```scad
module base_joiner(
    doublewide = 0,                         // 0 = single-width post mount, 1 = double-width post mount.
    bottom = 1,                             // 1 = bottom/base joiner, 0 = top/header joiner.
    supports = 2,                           // Number of support positions along the joiner, minimum 2.
    beam_thickness = 5.0,                   // Thickness of the long beam that ties the support blocks together.
    post_width = 15.875,                    // Width of one post footprint.
    rack_width = 330,                       // Front-to-rear span used for the main joiner body layout.
    rack_depth = 330,                       // Front-to-rear span used by the mirrored top joiner cone cut positions.
    footer_height = 12.7,                   // Height of the footer-side mounting blocks.
    header_height = 12.7,                   // Height of the header-side mounting blocks or cone sockets.
    hole_offset_z = 12.7,                   // Vertical position of the joiner mounting hole centre.
    hole_d = 6.3,                           // Diameter of the joiner mounting screw holes.
    nut_thickness = 6.3,                    // Depth of the nut traps for the mounting fasteners.
    nut_diameter_across_flats = 10.3,       // Across-flats size of the hex nut trap.
    post_cone_base_diameter = 10.0,         // Diameter at the base of the alignment cone/socket.
    post_cone_top_diameter = 4.0,           // Diameter at the tip of the alignment cone/socket.
    post_cone_height = 2.0,                 // Height/depth of the alignment cone/socket.
    post_top_cone_clearance = 0.1           // Clearance applied so cones fit into sockets.
)
```

Examples:

```scad
base_joiner();
base_joiner(bottom = 0, beam_thickness = 10.0);
base_joiner(doublewide = 1, supports = 3, beam_thickness = 6.0);
```

---

## `parts/rack panels.scad`

### `blank_1U_front_panel()` - Fixed 1U blanking panel

Builds a standard 1U front blanking panel with the normal rack hole pattern.
*Variable tray* can also built panels and is the *recommended method*, as there are far more options avaiable

```scad
module blank_1U_front_panel(
    holes = 2,                              // Number of mounting holes per side: typically 2, 3, 4, or 6.
    rack_width = 350,                       // Overall panel width across the rack.
    post_width = 15.875,                    // Width of one rack post used to place mounting holes.
    u_height = 44.5,                        // Height of one rack unit in mm.
    front_panel_thickness = 3.0,            // Thickness of the panel face.
    front_panel_undersizing = 0.1,          // Clearance trimmed from panel edges for fit.
    front_panel_edge_radius = 2.0,          // Corner radius for the panel; 0 gives square corners.
    hole_d = 6.3,                           // Diameter of the mounting holes.
    hole_offset_z = 12.7,                   // Height from the bottom to the first hole centre.
    hole_spacing = 15.875                   // Vertical spacing between hole centres.
)
```

### `blank_2U_front_panel()` - Fixed 2U blanking panel

Builds a standard 2U front blanking panel. As above.

```scad
module blank_2U_front_panel(
    holes = 4,                              // Number of mounting holes per side: typically 2, 4, or 6 for 2U.
    rack_width = 350,                       // Overall panel width across the rack.
    post_width = 15.875,                    // Width of one rack post used to place mounting holes.
    u_height = 44.5,                        // Height of one rack unit in mm.
    front_panel_thickness = 3.0,            // Thickness of the panel face.
    front_panel_undersizing = 0.1,          // Clearance trimmed from panel edges for fit.
    front_panel_edge_radius = 2.0,          // Corner radius for the panel; 0 gives square corners.
    hole_d = 6.3,                           // Diameter of the mounting holes.
    hole_offset_z = 12.7,                   // Height from the bottom to the first hole centre.
    hole_spacing = 15.875                   // Vertical spacing between hole centres.
)
```

### `blank_05U_front_panel()` - Top/bottom bridging panel

Builds the short panel used to bridge between posts and the base/header parts. This is not a normal half-U rack panel; it is sized from the rack hole spacing.
This *cannot* currently be built by blank_variable_tray()

```scad
module blank_05U_front_panel(
    rack_width = 350,                       // Overall panel width across the rack.
    post_width = 15.875,                    // Width of one rack post used to place mounting holes.
    front_panel_thickness = 3.0,            // Thickness of the panel face.
    front_panel_undersizing = 0.1,          // Clearance trimmed from panel edges for fit.
    front_panel_edge_radius = 2.0,          // Corner radius for the panel; 0 gives square corners.
    hole_d = 6.3,                           // Diameter of the mounting holes.
    hole_offset_z = 12.7                    // Half-U hole offset used to derive the fixed panel height and hole positions.

)
```

### `post_base_join_panel()` - Post-to-joiner connector panel

Create a compact rectangular join panel used to fasten a post footprint to abase or top joiner support position. It can be generated for either a single-width or double-width post footprint.
You only need this if you have internal posts (e.g. more than 4 posts)
Calling with just post_base_join_panel(); will produce the default single-width
join panel.

```scad
module post_base_join_panel(
    doublewide = 0,                         // 0 = single-width post footprint, 1 = double-width post footprint.
    thickness = 3.0,                        // Thickness of the join panel.
    post_width = 15.875,                    // Width of one rack post footprint.
    hole_offset_z = 12.7,                   // Height from the bottom to the first hole centre.
    hole_d = 6.3                            // Diameter of the panel mounting holes.
)
```

---

## `parts/blank variable tray.scad`

### `blank_variable_front_panel()` - Variable-height front panel

Builds a variable-height front panel with optional text, optional imported artwork, and optional reinforcement lips.
Avoid using this directly, use blank_variable_tray() with mode="panel"
That way you get all the options.

### `blank_variable_tray()` - Variable tray or variable panel

Builds either a tray or a panel using the same front-panel geometry. This is the preferred module for most new trays and custom panels. Can also create a tray/panel split, so you can print both parts and screw together.

```scad
module blank_variable_tray(
    mode                    = "tray", //"tray", "panel", "split_panel_show", "split_panel_tray", "split_panel_panel"
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
    side_support_single     = false, // if true, only add a single side support rail per-U, at the lowest position.
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
    tray_post_clearance     = 0.6, //0.5mm clearance, this makes 1mm total tray clearance. adjust as needed. modifying this might require tweaking the post_slide_cutout and hole_clearance to ensure the holes still clear properly.
    tray_side_slides        = 1,   //0 or 1 to add side slides that go into the posts. these are designed to fit into the post 
                                    //cutouts defined by post_slide_cutout/width, so adjust those dimensions if you change the slide design.
    post_slide_width        = 2.8, //*these next 2 are for the slides that go into the posts on the rack.
    post_slide_cutout       = 3.6, //*ideally you should create a 1U post for testing the fit of these before printing everything.
                                   //*you would be better off adjusting the post dimensions, rather than changing the tray dimensions, 
                                   //and create posts to fit the trays. making the side slides smaller to fit would make them weaker. 
                                   //So make the post cutouts bigger instead.
    post_slide_clearance    = 0.4, //clearance for the fit of the tray side slides into the post cutouts. adjust as needed for fit; this is separate from the tray_post_clearance to allow for different clearances on the sides vs the back of the tray if needed.
    hole_clearance          = 0.0, //clearance around the panel holes, for screwing into the posts.
    panel_join_clearance    = 0.3, //clearance for the side parts of the tray to panel join.
    panel_join_thickness    = 5.0, //thickness of the panel joiner.
    panel_join_hole_dia     = 3.5, //diameter of the screw holes for the panel to tray join.
    panel_join_hole_offset_z = 15.875, //offset of the first panel join hole from the bottom of the front panel, in mm.
    panel_join_cs_dia       = 7.0, //countersink the panel join holes on the outer faces.
    panel_join_length       = 15.0, //length of the panel join in the Y direction.
    panel_join_offset_from_edge = 10.0 //distance from the front/back edge of the joiner length to the center of the panel join holes.

)
```

Examples:

```scad
blank_variable_tray(panel_u_size = 1, tray_u_size = 0.75, holes = 2);
blank_variable_tray(panel_u_size = 1, tray_u_size = 0.75, tray_depth_scale = 0.5, back_panel = 1);
blank_variable_tray(mode = "panel", panel_u_size = 1.5, holes = 2);
blank_variable_tray(panel_u_size = 2, tray_u_size = 1.5, holes = 4, import_file = "../images-logo/raspberry-pi.svg", import_type = "svg", import_mode = "emboss");
```

---

## `parts/rack side panel.scad`

### `side_panel()` - Side panel with optional pattern and logo

Builds a side panel with mounting lips and hole pattern sized to the rack, with optional cutout patterning and an optional logo insert/recess area. TODO: Doesn't currently cover the header/footer, or top/bottom joiner. But does look awesome.

```scad
module side_panel(
    p_cv_panel_u_height = 6,                 // Panel height in U units.
    p_c_u_height = 44.5,                     // Height of 1U in mm.
    p_c_foot_add = 0,                        // Extra height added at the bottom.
    p_c_head_add = 0,                        // Extra height added at the top.
    p_c_panel_oversizing = 0.2,              // Extra depth added to improve fit tolerance.
    p_cv_panel_depth = 330,                  // Main panel depth in mm.
    p_c_panel_thickness = 3,                 // Thickness of the side panel body.
    p_c_lip_thickness = 3,                   // Thickness for the front/rear mounting lips.
    p_c_hole_clearance = 0.2,                // Extra clearance added to screw hole diameter.
    p_cv_post_width = 15.875,                // Rack post width used to size lips and hole positions.
    p_c_hole_offset_z = 12.7,                // Height from the bottom to the first hole centre.
    p_c_hole_spacing = 15.875,               // Vertical spacing between mounting holes.
    p_c_front_panel_edge_radius = 2.0,       // Radius on the lip edge corners.

    p_c_pattern = "honeycomb",              // Pattern type: [none, honeycomb, circles, squares, slots].
    p_c_pattern_margin = 20,                 // Margin from panel edges before the cutout pattern starts.
    p_c_pattern_hole_dia = 20,               // Size of the honeycomb/circle/square openings.
    p_c_pattern_offset_y = 0,                // Pattern offset along the panel depth to fine-tune edge cropping.
    p_c_pattern_offset_z = 0,                // Pattern offset along the panel height to fine-tune edge cropping.
    p_c_pattern_edge_offset_left = 1.3,      // Controls whether depth-side cropping is biased toward the start edge.
    p_c_pattern_edge_offset_bottom = 1,      // Controls whether height-side cropping is biased toward the bottom edge.
    p_c_pattern_grid_layout = "offset",     // [inline, offset] Grid layout for circle/square/slot patterns.
    p_c_pattern_slot_length = 50,            // Slot length when using the slot pattern.
    p_c_pattern_slot_width = 15,             // Slot width when using the slot pattern.
    p_c_pattern_slot_wall = 2,               // Material left between slot openings.
    p_c_pattern_slot_rounded = true,         // Whether slot ends are rounded.
    p_c_pattern_slot_rotation = 45,          // Rotation angle for slots in degrees.

    p_c_side_panel_logo = false,             // Enable the logo insert/pocket feature.
    p_c_side_panel_logo_shape = "hexagon",  // [square, circle, hexagon] Base shape behind the logo.
    p_c_side_panel_logo_rotation = 60,       // Rotation applied to the base logo shape.
    p_c_side_panel_logo_size = 100,          // Overall size of the logo base shape.
    p_c_side_panel_logo_import_file = "",   // Optional imported SVG/PNG/STL/3MF for the logo artwork.
    p_c_side_panel_logo_import_width = 40,   // Target width for the imported logo artwork.
    p_c_side_panel_logo_import_height = 50,  // Target height for the imported logo artwork.
    p_c_side_panel_logo_import_rotation = [0, 0, 90], // Rotation applied to the imported artwork.
    p_c_side_panel_logo_import_ypos = 160,   // Depth position of the imported artwork within the logo shape.
    p_c_side_panel_logo_import_zpos = 135,   // Height position of the imported artwork within the logo shape.
    p_c_side_panel_logo_ypos = -1,           // Logo shape depth position; -1 centers it automatically.
    p_c_side_panel_logo_zpos = -1,           // Logo shape height position; -1 centers it automatically.
    p_c_side_panel_import_mode = "recessed", // [recessed, raised] Whether the imported logo is recessed or raised.
    p_c_side_panel_logo_depth = 1.0          // Depth of the recess or height of the raised logo.
)
```

Example:

```scad
side_panel();
side_panel(p_c_pattern = "slots", p_c_pattern_slot_rotation = 45);
side_panel(
    p_c_pattern_hole_dia = 50,
    p_c_side_panel_logo = true,
    p_c_side_panel_logo_import_file = "../images-logo/raspberry-pi.svg",
    p_c_side_panel_logo_depth = 0.01
);
```

---

## Minimal Working Rack

For the minimum functional rack structure, you typically need:

1. `rail_1u_holes(...)` for the posts
2. `base_joiner(bottom = 1, ...)` for the lower joiners
3. `base_joiner(bottom = 0, ...)` for the upper joiners
4. `blank_05U_front_panel(...)` for the top and bottom bridging panels

If you use more than four posts, also add:

5. `post_base_join_panel(...)` for the intermediate post-to-joiner connections

Then add whichever front panels, trays, and side panels you want:

- Fixed panels: `blank_1U_front_panel()` / `blank_2U_front_panel()`
- Variable panel: `blank_variable_tray(mode = "panel", ...)`
- Variable tray: `blank_variable_tray(...)`
- Side panel: `side_panel(...)`

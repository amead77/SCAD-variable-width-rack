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

Builds either a tray or a panel using the same front-panel geometry. This is the preferred module for most new trays and custom panels.

```scad
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

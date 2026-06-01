# Variable width Rack (default=350mm wide, 330mm deep) - Current Public Module Reference

This file documents the current public callable modules in the four core source files that are enough to build a working rack:

- `parts/rack posts.scad`
- `parts/rack panels.scad`
- `parts/rack side panel.scad`
- `parts/blank variable tray.scad`

If you are building a rack from scratch, the core structural parts are usually:

- `rail_1u_holes()` for posts
- `base_joiner()` for front-to-rear joiners
- `blank_05U_front_panel()` for the front/rear top and bottom bridging panels - headers/footers to joiners
- `post_base_join_panel()` if you are using extra intermediate posts

Then add either:

- `blank_1U_front_panel()` / `blank_2U_front_panel()` / `blank_variable_front_panel()` for blanking panels
- `blank_1U_tray()` / `blank_2U_tray()` / `blank_variable_tray()` for trays
- `side_panel()` for optional side panels

---

## `parts/rack posts.scad`

### `post()` - Raw 1U post body

Builds a single 1U post body with optional side slide channels. This is the raw body only; for a usable rack post with holes, nut traps, headers, footers, and cones, use `rail_1u_holes()`.

```scad
post(
    slide_side = 0,          // 0=none, 1=left, 2=right, 3=both
    doublewide = 0,          // 0=single-width, 1=double-width
    post_width = 15.875,
    u_height = 44.5,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
)
```

Example:

```scad
post(slide_side = 3, doublewide = 1);
```

### `rail_1u_holes()` - Complete rack post

Builds a complete rack post from stacked 1U sections, including screw holes, rear nut traps, optional slide rails, optional footer/header blocks, and optional alignment cones.

```scad
rail_1u_holes(
    slide_side,                      // required: 0=none, 1=left, 2=right, 3=both
    doublewide = 0,
    post_height = 3,
    v_post_cones = 1,
    include_footer = 1,
    include_header = 1,
    post_width = 15.875,
    u_height = 44.5,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30),
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    footer_height = 12.7,
    header_height = 12.7,
    post_cone_base_diameter = 10.0,
    post_cone_top_diameter = 4.0,
    post_cone_height = 2.0,
    post_top_cone_clearance = 0.1
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
base_joiner(
    doublewide = 0,
    bottom = 1,
    supports = 2,
    beam_thickness = 5.0,
    post_width = 15.875,
    rack_width = 330,
    rack_depth = 330,
    footer_height = 12.7,
    header_height = 12.7,
    hole_offset_z = 12.7,
    hole_d = 6.3,
    nut_thickness = 6.3,
    nut_diameter_point = 10.3 / cos(30),
    post_cone_base_diameter = 10.0,
    post_cone_top_diameter = 4.0,
    post_cone_height = 2.0,
    post_top_cone_clearance = 0.1
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

```scad
blank_1U_front_panel(
    holes = 2,
    rack_width = 350,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
)
```

### `blank_2U_front_panel()` - Fixed 2U blanking panel

Builds a standard 2U front blanking panel.

```scad
blank_2U_front_panel(
    holes = 4,
    rack_width = 350,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875
)
```

### `blank_05U_front_panel()` - Top/bottom bridging panel

Builds the short panel used to bridge between posts and the base/header parts. This is not a normal half-U rack panel; it is sized from the rack hole spacing.

```scad
blank_05U_front_panel(
    rack_width = 350,
    post_width = 15.875,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    hole_d = 6.3,
    hole_offset_z = 12.7
)
```

### `post_base_join_panel()` - Post-to-joiner connector panel

Builds the compact rectangular panel used to fasten a post footprint to an intermediate joiner support position.

```scad
post_base_join_panel(
    doublewide = 0,
    thickness = 3.0,
    post_width = 15.875,
    hole_offset_z = 12.7,
    hole_d = 6.3
)
```

### `blank_1U_tray()` - Fixed 1U tray

Builds a basic 1U tray with a front panel and side slide tabs.

```scad
blank_1U_tray(
    side_count = 3,
    edge_radius = 2.0,
    holes = 2,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    tray_thickness = 5.0,
    tray_post_clearance = 0.5,
    tray_side_thickness = 2.0,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3
)
```

### `blank_2U_tray()` - Fixed 2U tray

Builds a basic 2U tray with a front panel and side slide tabs.

```scad
blank_2U_tray(
    side_count = 3,
    edge_radius = 2.0,
    holes = 4,
    rack_width = 330,
    post_width = 15.875,
    u_height = 44.5,
    front_panel_thickness = 3.0,
    front_panel_undersizing = 0.1,
    hole_d = 6.3,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    tray_thickness = 5.0,
    tray_post_clearance = 0.5,
    tray_side_thickness = 2.0,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3
)
```

---

## `parts/blank variable tray.scad`

### `blank_variable_front_panel()` - Variable-height front panel

Builds a variable-height front panel with optional text, optional imported artwork, and optional reinforcement lips.

```scad
blank_variable_front_panel(
    u_size = 1,
    front_panel_top_reinforce_mm = 1,
    front_panel_bottom_reinforce_mm = 1,
    holes = 2,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_depth = 0.8,
    import_offset_x = 0,
    import_offset_z = 0,
    import_mode = "emboss",
    panel_text = "",
    panel_text_font = "Liberation Mono:style=Bold",
    panel_text_size = 10,
    panel_text_depth = 0.8,
    panel_text_offset_x = 0,
    panel_text_offset_z = 0,
    panel_text_mode = "engrave",
    front_panel_thickness = 3.0,
    rack_width = 330,
    post_width = 15.875,
    hole_d = 6.3,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    tray_post_clearance = 0.5
)
```

Examples:

```scad
blank_variable_front_panel(u_size = 1.5, holes = 2);
blank_variable_front_panel(u_size = 2, holes = 4, panel_text = "SWITCH", panel_text_mode = "engrave");
blank_variable_front_panel(u_size = 2, holes = 4, import_file = "../images-logo/raspberry-pi.svg", import_type = "svg", import_mode = "emboss");
```

### `blank_variable_tray()` - Variable tray or variable panel

Builds either a tray or a panel using the same front-panel geometry. This is the preferred module for most new trays and custom panels.

```scad
blank_variable_tray(
    mode = "tray",                // "tray" or "panel"
    panel_u_size = 1,
    front_panel_top_reinforce_mm = 0,
    front_panel_bottom_reinforce_mm = 0,
    tray_u_size = undef,
    tray_depth_scale = 1,
    holes = 2,
    import_file = "",
    import_type = "none",
    import_width = 0,
    import_height = 0,
    import_depth = 0.8,
    import_offset_x = 0,
    import_offset_z = 0,
    import_mode = "emboss",
    panel_text = "",
    panel_text_font = "Liberation Mono:style=Bold",
    panel_text_size = 10,
    panel_text_depth = 0.8,
    panel_text_offset_x = 0,
    panel_text_offset_z = 0,
    panel_text_mode = "engrave",
    side_support = 1,
    side_support_back = 40,
    side_support_thickness = 2.0,
    tray_side_thickness = 2.0,
    front_panel_thickness = 3.0,
    back_panel = 0,
    back_panel_thickness = 2.0,
    back_panel_height = 1.0,
    back_panel_chamfer = 0.0,
    back_panel_chamfer_ang = 45.0,
    tray_thickness = 5.0,
    rack_width = 350,
    rack_depth = 330,
    post_width = 15.875,
    hole_d = 6.4,
    u_height = 44.5,
    hole_offset_z = 12.7,
    hole_spacing = 15.875,
    front_panel_undersizing = 0.1,
    front_panel_edge_radius = 2.0,
    tray_post_clearance = 0.5,
    tray_side_slides = 1,
    post_slide_width = 3.0,
    post_slide_cutout = 3.2,
    hole_clearance = 0.3
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

Builds a side panel with mounting lips and hole pattern sized to the rack, with optional cutout patterning and an optional logo insert/recess area.

```scad
side_panel(
    p_cv_panel_u_height = 6,
    p_c_u_height = 44.5,
    p_c_foot_add = 0,
    p_c_head_add = 0,
    p_c_panel_oversizing = 0.2,
    p_cv_panel_depth = 330,
    p_c_panel_thickness = 3,
    p_c_lip_thickness = 3,
    p_c_hole_clearance = 0.2,
    p_cv_post_width = 15.875,
    p_c_hole_offset_z = 12.7,
    p_c_hole_spacing = 15.875,
    p_c_front_panel_edge_radius = 2.0,
    p_c_pattern = "honeycomb",
    p_c_pattern_margin = 20,
    p_c_pattern_hole_dia = 20,
    p_c_pattern_offset_y = 0,
    p_c_pattern_offset_z = 0,
    p_c_pattern_edge_offset_left = 1.3,
    p_c_pattern_edge_offset_bottom = 1,
    p_c_pattern_grid_layout = "offset",
    p_c_pattern_slot_length = 50,
    p_c_pattern_slot_width = 15,
    p_c_pattern_slot_wall = 2,
    p_c_pattern_slot_rounded = true,
    p_c_pattern_slot_rotation = 45,
    p_c_side_panel_logo = false,
    p_c_side_panel_logo_shape = "hexagon",
    p_c_side_panel_logo_rotation = 60,
    p_c_side_panel_logo_size = 100,
    p_c_side_panel_logo_import_file = "",
    p_c_side_panel_logo_import_width = 40,
    p_c_side_panel_logo_import_height = 50,
    p_c_side_panel_logo_import_rotation = [0, 0, 90],
    p_c_side_panel_logo_import_ypos = 160,
    p_c_side_panel_logo_import_zpos = 135,
    p_c_side_panel_logo_ypos = -1,
    p_c_side_panel_logo_zpos = -1,
    p_c_side_panel_import_mode = "recessed",
    p_c_side_panel_logo_depth = 1.0
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
- Fixed trays: `blank_1U_tray()` / `blank_2U_tray()`
- Variable tray: `blank_variable_tray(...)`
- Side panel: `side_panel(...)`

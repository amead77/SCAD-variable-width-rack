# Variable Width Rack Design

No longer are you stuck with a 10 inch rack or a 19 inch rack you cannot print parts for. This design is meant to be printable on large-format printers while still giving you properly supported trays.

Normal defaults are a 350 mm wide panel and a 330 mm deep tray, but the design is parametric and can be changed.

## What This Is

This is a fully parametric rack system built in OpenSCAD. I wanted something bigger than the usual mini-rack designs, printable on a Creality K2 Plus, and flexible enough to suit different equipment without redesigning every part from scratch.

One of the main design goals was fixing a common annoyance in small printed racks: trays that cannot be removed without dismantling the frame. In this design, trays slide into rear support channels so they can be removed far more easily.

If you like the design, you are welcome to buy me a coffee:

https://buymeacoffee.com/amead77

## Quick Overview

Below is an assembly overview showing some of what is possible. Everything is customizable.

1. Top header: an extra joining point added to the post for connecting to the top joiner. Optional, but useful for stability.
2. Top joiner: ties posts together at the top. You can use 4 or more posts. In my example I use 6. Support cones are optional, but recommended.
3. Half-U panel: spans across posts and helps secure top and bottom joins.
4. Bottom joiner: same idea as the top joiner.
5. Post join location: used to connect inner posts to the top and bottom joins so they are not floating.
6. Side panel: optional, and can use different patterns or a logo.

For my rack I used 6 posts. Four face forward and the rear 2 face backwards. Keep that in mind when choosing which side gets tray slide support.

![Assembly overview](overview.png)

## Rear View

![Rear view of assembly](overview-rearish.png)

## 8-Leg Version

![Assembly with 8 legs](overview-8_legs.png)

## Partially Built Rack

This shows my own rack in progress. I do have a tray for the Dell system, but had not printed it at the time of the photo.

![Partially built rack](20260524_191538.jpg)

## Side Panel Example

You do not have to use a honeycomb pattern. There are several possible styles, and the logo/image is optional.

![Side panel](20260524_191549.jpg)

---

## Design Goals

- Rear-slide tray support: trays slide into a slot in the rear post instead of bolting front and rear. That means trays can be removed without dismantling the rack.
- Fully parametric: dimensions, hole counts, heights, and clearances are driven by variables. Use the OpenSCAD Customizer instead of editing everything manually.
- Modular: mix single or double-wide posts, variable-height trays and panels, plus optional joiners.

---

## Parts

### Posts

Posts are the vertical rails of the rack. They can be generated in configurable U heights and in single or double-wide versions. A slide channel can be added to the left side, right side, both sides, or neither.

I strongly recommend double-wide posts with top and bottom headers, cones, and slide support.

![Post](post.png)

### Trays

Trays are available in fully variable sizes. The variable tray supports a rear panel option so it can act more like a drawer. Trays slide into the rear slot of the post for easy removal.

Trays do not need to be full depth. For example, using 0.25 gives a quarter-depth tray on the Y axis.

The main tray logic is in `parts/blank variable tray.scad`, while `parts-optional/intel dg45fg.scad` is a useful example of a custom tray using it.

![Variable tray](blank-tray.png)

### Panels

Flat front panels are available for blanking unused rack slots. There are 1/2U, 1U, and 2U styles.

The variable tray system can also create most panel styles and is generally the recommended approach because it is more customizable.

The half-U panel is especially useful for tying posts together when using headers.

![Half-U panel](half-u-panel.png)

![2U panel](2u-panel.png)

### Footer and Header

Optional pieces added to the top and bottom of posts. They provide attachment points for joiners.

If you want front-to-rear support braces, I recommend including them.

### Joiners

Optional horizontal joiners connect the front posts to the rear posts through the footer and header pieces.

You are not limited to 4 posts. The joiners can support additional intermediate posts, which is useful for wider racks or more tray support points.

![Top joiner](top-joiner.png)

![Base joiner](base-joiner.png)

---

## Custom Trays

The file `parts-optional/intel dg45fg.scad` contains a tray I made for an older mini-ITX board. It includes:

- a mount for a FlexATX PSU
- screw holes for mini-ITX
- a rear panel option
- an LED hole in the front for drive activity
- a large round power button cutout
- engraved board and CPU text on the front panel
- reinforcement on the front panel
- rear reinforcement using a chamfered back panel to reduce support requirements

![Mini-ITX tray](mini-itx-tray.png)

I strongly recommend making test pieces before committing to long prints. Even a short post section with tray slides and a matching tray sample is enough to check fit and tolerances.

![Test print](20260524_191530.jpg)

When I print the full tray, I use the following approach:

- cut away non-critical areas in the slicer to reduce filament usage
- angle cutouts to avoid supports where possible
- print face down so the tray rails do not need supports
- print face down so front text can be done cleanly in a single layer change
- use a shallow rear panel with a 30 degree chamfer for reinforcement without heavy support material

That way, only the PSU mount and mini-ITX screw holes generally need supports.

![Slicer example](slicer.png)

Another custom tray is `parts-optional/ugreen um106x.scad`, which I use for:

- a 5-port switch
- 4 keystone inserts

![Ugreen tray](um106x.png)

---

## Usage

1. Open `rack parts.scad` in OpenSCAD.
2. Open the Customizer panel.
3. Select the part you want from the `part` dropdown.
4. Adjust the parameters to suit your needs.
5. Render with F6 and export to STL or 3MF.

Available part options include:

- `assembly` for a full preview
- `post` for a single post
- `base joiner` and `top joiner` for horizontal joiners
- `1U tray`, `2U tray`, and `variable tray`
- `halfUpanel`, `1U panel`, `2U panel`, and `variable panel`

### Key Parameters

- `post_u_height`: height of the post in U units
- `post_doublewide`: `0` for single-wide, `1` for double-wide
- `slide_side`: `0` none, `1` left, `2` right, `3` both
- `front_panel_height`: panel or tray height in U, including fractional values like `1.5`
- `front_panel_hole_count`: mounting holes per side
- `tray_side_height`: tray wall height in hole spacings
- `tray_back_panel`: `0` open tray, `1` rear panel included
- `footer_include` and `header_include`: include footer and header attachment pieces

### Hardware

The default design is based on M6 screws with M6 hex nuts. If you want different fasteners, adjust the hole and nut parameters in the SCAD files.

---

## File Structure

- `rack parts.scad`: main entry point for selecting and configuring parts
- `parts/rack posts.scad`: post geometry
- `parts/rack panels.scad`: panel geometry for 1/2U, 1U, and 2U panels
- `parts/blank variable tray.scad`: main tray and panel generator
- `parts-optional/intel dg45fg.scad`: example custom tray

The old `parts/rack defines.scad` file is effectively deprecated and kept only for reference. Default values were moved into function and module defaults during refactoring.

---

## Requirements

- OpenSCAD. The nightly builds are recommended over the old stable releases.
- A printer that can handle the size you want. For example, a Creality K2 Plus can handle 350 mm and a Prusa XL can handle 340 mm.

---

## License

This project is licensed under Creative Commons Attribution Non-Commercial, CC BY-NC.

Copyright 2026 Adam Mead

Any Raspberry Pi and Dell logos remain the property of their respective owners. They are included only to avoid missing file errors in the source project.

---

## Why I Made This

This picture is not my design, but I did print it, and it is the main reason I made this rack system instead.

![The rack design that pushed me to make this](angry-rack.png)
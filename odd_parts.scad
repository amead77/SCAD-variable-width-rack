/*
various parts
*/


/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/24r05";
*/

module panel_mount_power_switch_round(diameter = 16, thickness = 16) {
    cylinder(h = thickness, d = diameter, center = true);
}

module panel_mount_led_round(diameter = 5, thickness = 8) {
    cylinder(h = thickness, d = diameter, center = true);
}
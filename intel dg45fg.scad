/*
 mini-itx intel dg45fg retro board in rack mount tray.

*/


/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/15r07";
*/


//spec out the holes for mini-itx board

itx_holes = [   
    [0, 0],
    [157.58, 0],
    [0, 154.94],
    [157.48, 132.08]
];

itx_board_clearance = 6.5;

//this is the diameter for the heat insert, not the screw itself.
itx_heat_insert_diameter = 3.5; //6-32 UNC screw normally. But using metric here. M3.5x0.6 is equiv, but i have M3
itx_heat_insert_outer_diameter = itx_heat_insert_diameter + 1.2;


module itx_screw_standoff() {
    difference() {
        cylinder(h = itx_board_clearance, d = itx_heat_insert_outer_diameter, center = true);
        cylinder(h = itx_board_clearance, d = itx_heat_insert_diameter, center = true);
    }
}


module itx_holes() {
    for (i = [0 : len(itx_holes) - 1]) {
        translate([itx_holes[i][0], itx_holes[i][1], 0])
            itx_screw_standoff();
            //cylinder(h = 10, d = itx_screw_diameter + itx_board_clearance, center = true);
    }
}

itx_holes();
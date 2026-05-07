//keystone for the tray, for routing cables from switch to stuff in the back. Just a cheap amazon keystone.
//
//
//the keystone gets inserted from the rear of the panel, not the front, so the catch clips in, the front stopper should ride
//over the panel front when the catch is squished, then prevent the keystone from being pushed back into the tray.

/*
// next 2 lines used only by my 'on save' script. can be ignored otherwise.
// AUTO-V
version = "v0.1-2026/05/07r102";
*/

ks_width = 15.0; //14.58
ks_height = 18.0; //16.10 //17.7
ks_depth = 30.0;
ks_catch_height = 3.0; //3.70
ks_catch_width = 9.3;
ks_catch_depth = 13.9;
ks_catch_ypos = 5.0;
ks_catch_edge_depth = 3.0; //the edge part is a tab that sticks up slightly more than the catch
ks_catch_edge_height = 1.0; //1.0
ks_side_lip_depth = 1.6;
ks_side_lip_height = 8.0;
ks_side_lip_ypos = 10.0;
ks_side_lip_width = (16.16 - ks_width) / 2;
//there is also a bottom lip, but the catch on top will squish and clip into the case, making the bottom lip a front stopper.
//using this keystone means the front panel is max 2mm thick.

//the panel recess for the keystones, this is because the keystones will otherwise protrude from the front panel. below is for single, not entirely used now.
ks_recess_height = ks_height + ks_catch_height + 6.0; //this is the overall height of the recess in the front panel.
ks_recess_width = ks_width + 10.0; //the overall width of the recess, for multiple this will need adjusting.
ks_recess_depth = 0;//ks_side_lip_depth; //how far to recess the keystone into the front panel.
ks_recess_wall_thickness = 2.0; //this is limited by the (ks_catch_ypos+ks_catch_edge_depth)-ks_side_lip_ypos. as the front panel needs to fit between them,

ks_panel_cutout_width = 105; //(ks_recess_width * 5)+(ks_recess_wall_thickness * 2);
ks_panel_cutout_height = ks_recess_height+(ks_recess_wall_thickness * 2);

ks_num_keystones = 4;



module keystone_panel_recess() {
    difference() {
        cube([(ks_recess_width * 6)+(ks_recess_wall_thickness * 2), ks_recess_depth+ks_recess_wall_thickness, ks_recess_height+(ks_recess_wall_thickness * 2)]);
        translate([ks_recess_wall_thickness, 0, ks_recess_wall_thickness]) {
            cube([ks_recess_width * 6, ks_recess_depth, ks_recess_height]);
        }
    }

    //taking a different approach. Doesn't need to be complicated.
}


module keystone() {
    color("green") {
        cube([ks_width, ks_depth, ks_height]);
    }
    // catch for the keystone to stop it falling out of the tray.
    translate([(ks_width - ks_catch_width)/2, ks_catch_ypos, ks_height]) {
        color("yellow") {
            cube([ks_catch_width, ks_catch_depth, ks_catch_height]);
        }
    }

    //catch edge 
    translate([(ks_width - ks_catch_width)/2, ks_catch_ypos , ks_height + ks_catch_height]) {
        color("yellow") {
            cube([ks_catch_width, ks_catch_edge_depth, ks_catch_edge_height]);
        }
    }


    // side lips for the keystone to help secure it in the tray. left side
    translate([-(ks_side_lip_width), ks_side_lip_ypos, (ks_height / 2)-(ks_side_lip_height/2)]) {
        color("orange") {
            cube([ks_side_lip_width, ks_side_lip_depth, ks_side_lip_height]);
        }
    }
    //right side
    translate([ks_width, ks_side_lip_ypos, (ks_height / 2)-(ks_side_lip_height/2)]) {
        color("orange") {
            cube([ks_side_lip_width, ks_side_lip_depth, ks_side_lip_height]);
        }
    }

}


module keystone_panel() {
//    difference() {
        //multiply by 5 for side by side keystones
//        keystone_panel_recess();
//        translate([7, 0, 0]) {
            for (i = [0:ks_num_keystones-1]) {
                translate([i*(ks_width+10), (-ks_side_lip_ypos)+ks_recess_depth+ks_recess_wall_thickness, 4]) {
                    //translate([-((ks_width/2)-0.5), (-ks_side_lip_ypos)+ks_recess_depth+ks_recess_wall_thickness, -4]) {
                    keystone();
                }
            }
//        }
//    }
}

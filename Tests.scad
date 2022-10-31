LAYER_HEIGHT = 0.4;

use <./Standoffs.scad>

// test the standoffs


cube([10,10,3]);
translate([0,0,3]) {
    
    //translate([5,5,0])
   // part_centred_screw_standoff(3,6,2,4,2, 0.3);

    //translate([5,30,0])
    //part_flat_screw_standoff(6,4,2,0.3);

    translate([5,5,0])
    part_snap_standoff(3,6,2,3,5, 0.3);
}
/**
* Definitions for using the I2CNavKey
**/

LAYER_HEIGHT = 0.3;

use <./Generics.scad>

use <./Standoffs.scad>

include <./I2CNavKey.h>

module i2c_navkey() {
    t1 = (i2c_navkey_pcb_side - i2c_navkey_mounting_hole_centres)/2;
    t2 = i2c_navkey_pcb_side - t1;
    
    
    color("Gray")
    translate([-i2c_navkey_pcb_side/2, -i2c_navkey_pcb_side/2, 0]) {
    // PCB
    difference() {

        translate([0,0,-0.1])
        cube([i2c_navkey_pcb_side, i2c_navkey_pcb_side, 1.1]);
        
        translate([0,0,-0.1]) {
            translate([t1, t1, 0])
            cylinder(h=1.2, d = i2c_navkey_mounting_hole_dia);
            
            translate([t1, t2, 0])
            cylinder(h=1.2, d = i2c_navkey_mounting_hole_dia);
            
            translate([t2, t2, 0])
            cylinder(h=1.2, d = i2c_navkey_mounting_hole_dia);
            
            translate([t2, t1, 0])
            cylinder(h=1.2, d = i2c_navkey_mounting_hole_dia);
        }
    }
    
    // Jog dial
    translate([i2c_navkey_pcb_side/2,i2c_navkey_pcb_side/2,2.5]) {
        rotate_extrude(angle=360)
        polygon([
        [i2c_navkey_dia_1/2,0],
        [i2c_navkey_dia_1/2, 0.5],
        [i2c_navkey_dia_2/2,0.5],
        [i2c_navkey_dia_2/2,i2c_navkey_joypad_height],
        [i2c_navkey_dia_3/2,i2c_navkey_joypad_height-1]
        ]);
        
        cylinder(h=i2c_navkey_joypad_height-1, d=i2c_navkey_dia_3-0.5);
        cylinder(h=i2c_navkey_joypad_height-0.5, d=i2c_navkey_dia_4);

    }
}
}

/**
* Assumes that the standoff is to be built on top of the current z=0
**/
module i2c_navkey_flat_screw_standoff(LAYER_HEIGHT=0.4) {
    
    translate([-i2c_navkey_pcb_side/2, -i2c_navkey_pcb_side/2, 0])
    part_flat_screw_standoff(i2c_navkey_standoff_inner_height, i2c_navkey_standoff_outer_dia,
        i2c_navkey_standoff_hole_dia, LAYER_HEIGHT);
}

module i2c_navkey_snap(LAYER_HEIGHT=0.4) {
    
    translate([-i2c_navkey_pcb_side/2, -i2c_navkey_pcb_side/2, 0])
    part_snap_standoff(i2c_navkey_standoff_outer_height, i2c_navkey_standoff_outer_dia,
        i2c_navkey_standoff_inner_height, i2c_navkey_standoff_hole_dia);
}


module i2c_navkey_flat_screw_standoffs(LAYER_HEIGHT=0.4) {
    t1 = (i2c_navkey_pcb_side - i2c_navkey_mounting_hole_centres)/2;
    t2 = i2c_navkey_pcb_side - t1;

        translate([t1, t1, 0])
        i2c_navkey_standoff(LAYER_HEIGHT);
        
        translate([t1, t2, 0])
        i2c_navkey_standoff(LAYER_HEIGHT);
        
        translate([t2, t2, 0])
        i2c_navkey_standoff(LAYER_HEIGHT);
        
        translate([t2, t1, 0])
        i2c_navkey_standoff(LAYER_HEIGHT);
} 

module i2c_navkey_snaps(LAYER_HEIGHT=0.4) {
    t1 = (i2c_navkey_pcb_side - i2c_navkey_mounting_hole_centres)/2;
    t2 = i2c_navkey_pcb_side - t1;


        translate([t1, t1, 0])
        i2c_navkey_snap(LAYER_HEIGHT);
        
        translate([t1, t2, 0])
        i2c_navkey_snap(LAYER_HEIGHT);
        
        translate([t2, t2, 0])
        i2c_navkey_snap(LAYER_HEIGHT);
        
        translate([t2, t1, 0])
        i2c_navkey_snap(LAYER_HEIGHT);
 
}  
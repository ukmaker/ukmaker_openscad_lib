/**
* Modules representing various small TFT screens
*
* use part_* for a model of the screen itself
* use mnt_* to get panel cutouts, mounting holes and standoffs
**/

use <./Generics.scad>
use <./Standoffs.scad>

tft_2_8_pcb_length = 86;
tft_2_8_pcb_width = 50;
tft_2_8_pcb_thickness = 1.6;
tft_2_8_pcb_hole_dia = 3.2;
tft_2_8_pcb_screw_dia = 3.0; // M3
tft_2_8_pcb_hole_offset_left = 6.9;
tft_2_8_pcb_hole_offset_right = 2.6;
tft_2_8_pcb_hole_offset_y = 2.9;

tft_2_8_module_length = 69;
tft_2_8_module_height = 4;
tft_2_8_module_offset_left = 10.2;

/**
* A 2.8" TFT SPI screen
**/
module part_tft_2_8() {
    color("red")
    part_pcb_with_uneven_holes(
    tft_2_8_pcb_length, tft_2_8_pcb_width, tft_2_8_pcb_thickness,
    tft_2_8_pcb_hole_dia,
    tft_2_8_pcb_hole_offset_left,
    tft_2_8_pcb_hole_offset_right,
    tft_2_8_pcb_hole_offset_y);
    
    translate([tft_2_8_module_offset_left, 0, tft_2_8_pcb_thickness])
    color("black")
    cube([tft_2_8_module_length, tft_2_8_pcb_width, tft_2_8_module_height]);
    
} 


/**
* Cutout for the 2.8" screen
**/
module mnt_cutout_tft_2_8(thickness) {
    color("black")
    translate([tft_2_8_module_offset_left,0,-0.1])
    cube([tft_2_8_module_length, tft_2_8_pcb_width, thickness+0.2]);  
}

/**
* Mounting holes to screw the TFT to the front panel
**/
module mnt_holes_tft_2_8(panel_thickness) {
    op_4_grid(tft_2_8_pcb_length, tft_2_8_pcb_width, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    translate([0,0,-0.1])
   countersink(tft_2_8_pcb_screw_dia,panel_thickness+0.2);
}

/**
* Standoffs for mounting the 2.8" TFT from the back
* Using small screws
**/
module mnt_screws_tft_2_8() {
    
    op_4_grid(tft_2_8_pcb_length, tft_2_8_pcb_width, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    part_flat_screw_standoff(tft_2_8_module_height, tft_2_8_pcb_screw_dia*1.5, tft_2_8_pcb_screw_dia);
}

module mnt_snap_tft_2_8(panel_thickness) {
    
    op_4_grid(tft_2_8_pcb_length, tft_2_8_pcb_width, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    part_snap_standoff(tft_2_8_module_height - panel_thickness, tft_2_8_pcb_screw_dia*1.5, tft_2_8_pcb_thickness, tft_2_8_pcb_screw_dia);
}


part_tft_2_8();

// demo of the panel cutout and mounting holes
translate([0,60,0]) {
    
difference() {
    // panel
    color("blue")
    cube([100,70,3]);
    translate([0,10,0]) {
    mnt_cutout_tft_2_8(3);

        mnt_holes_tft_2_8(3);
    }
}
translate([0,10,0])
mirror([0,0,1])mnt_snap_tft_2_8(3);
    
    
}

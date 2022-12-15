/**
* Modules representing various small TFT screens
*
* use part_* for a model of the screen itself
* use mnt_* to get panel cutouts, mounting holes and standoffs
**/

use <./Generics.scad>
use <./Standoffs.scad>

tft_2_8_pcb_width = 86;
tft_2_8_pcb_depth = 50.5;
tft_2_8_pcb_thickness = 1.6;
tft_2_8_pcb_hole_dia = 3.2;
tft_2_8_pcb_screw_dia = 3.0; // M3
tft_2_8_pcb_hole_offset_left = 7.0;
tft_2_8_pcb_hole_offset_right = 2.7;
tft_2_8_pcb_hole_offset_y = 3.0;

tft_2_8_module_width = 69.5;
tft_2_8_module_height = 4;
tft_2_8_module_offset_left = 10.2;
tft_2_8_touch_occlusion_left = 8;
tft_2_8_screen_width = 59; // usable width
tft_2_8_screen_depth = 44.5;
tft_2_8_fitting_fudge = 0.25; // leave all around any cutouts

/**
* A 2.8" TFT SPI screen
**/
module part_tft_2_8() {
    color("red")
    part_pcb_with_uneven_holes(
    tft_2_8_pcb_width, tft_2_8_pcb_depth, tft_2_8_pcb_thickness,
    tft_2_8_pcb_hole_dia,
    tft_2_8_pcb_hole_offset_left,
    tft_2_8_pcb_hole_offset_right,
    tft_2_8_pcb_hole_offset_y);
    
    translate([tft_2_8_module_offset_left, 0, tft_2_8_pcb_thickness]) {
        // the overall screen size
        color("black")
        cube([tft_2_8_module_width, tft_2_8_pcb_depth, tft_2_8_module_height]);
        
        // the visible area
        color("grey")
        translate([tft_2_8_touch_occlusion_left,(tft_2_8_pcb_depth - tft_2_8_screen_depth)/2,0.1])
        cube([tft_2_8_screen_width, tft_2_8_screen_depth, tft_2_8_module_height]);
        
    }
    
} 


/**
* Cutout for the 2.8" screen
* Makes a hole the size of the module
**/
module mnt_cutout_tft_2_8(thickness) {

left = tft_2_8_module_offset_left - tft_2_8_fitting_fudge;
bottom = - tft_2_8_fitting_fudge;
width = tft_2_8_module_width + 2 * tft_2_8_fitting_fudge;
depth = tft_2_8_pcb_depth + 2 * tft_2_8_fitting_fudge;

    color("black")
    translate([left,bottom,-0.1])
    cube([width, depth, thickness+0.2]);  
}

module mnt_cutout_bezel_tft_2_8(bevel_depth, thickness) {

    left = tft_2_8_module_offset_left + tft_2_8_touch_occlusion_left - tft_2_8_fitting_fudge - bevel_depth;
    bottom = -bevel_depth + (tft_2_8_pcb_depth - tft_2_8_screen_depth) /2 - tft_2_8_fitting_fudge;
    width = tft_2_8_screen_width + 2 * tft_2_8_fitting_fudge + 2 * bevel_depth;
    depth = tft_2_8_screen_depth + 2 * tft_2_8_fitting_fudge + 2 * bevel_depth;

    color("black")
    translate([left,bottom,-0.1])
    cube([width, depth, thickness+0.2]);  
}

/**
* Create a sloping bezel to go around the cutout
**/
module mnt_bezel_tft_2_8(bevel_depth, bevel_height) {
    left = tft_2_8_module_offset_left + tft_2_8_touch_occlusion_left - tft_2_8_fitting_fudge;
    bottom = (tft_2_8_pcb_depth - tft_2_8_screen_depth) /2 - tft_2_8_fitting_fudge;
    width = tft_2_8_screen_width + 2 * tft_2_8_fitting_fudge;
    depth = tft_2_8_screen_depth + 2 * tft_2_8_fitting_fudge;
    
    translate([left, bottom, 0])
    bezel(width, depth, bevel_depth, bevel_height);
}

/**
* Mounting holes to screw the TFT to the front panel
**/
module mnt_holes_tft_2_8(panel_thickness) {
    op_4_grid(tft_2_8_pcb_width, tft_2_8_pcb_depth, 
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
module mnt_screws_tft_2_8(panel_thickness) {
    
    op_4_grid(tft_2_8_pcb_width, tft_2_8_pcb_depth, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    part_flat_screw_standoff(tft_2_8_module_height-panel_thickness, tft_2_8_pcb_screw_dia*1.5, tft_2_8_pcb_screw_dia);
}

module mnt_snap_tft_2_8(panel_thickness) {
    
    op_4_grid(tft_2_8_pcb_width, tft_2_8_pcb_depth, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    part_snap_standoff(tft_2_8_module_height - panel_thickness, tft_2_8_pcb_screw_dia*1.5, tft_2_8_pcb_thickness, tft_2_8_pcb_screw_dia);
}

module mnt_melt_tft_2_8(panel_thickness) {
    
    op_4_grid(tft_2_8_pcb_width, tft_2_8_pcb_depth, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    part_melt_standoff(tft_2_8_module_height - panel_thickness, tft_2_8_pcb_screw_dia*1.5, tft_2_8_pcb_thickness, tft_2_8_pcb_screw_dia);
}

module mnt_melt_bezel_tft_2_8(LAYER_HEIGHT = 0.4) {
    
    op_4_grid(tft_2_8_pcb_width, tft_2_8_pcb_depth, 
        tft_2_8_pcb_hole_offset_left,
        tft_2_8_pcb_hole_offset_right,
        tft_2_8_pcb_hole_offset_y,
        tft_2_8_pcb_hole_offset_y)
    part_melt_standoff(tft_2_8_module_height, tft_2_8_pcb_screw_dia*1.5, tft_2_8_pcb_thickness*2, tft_2_8_pcb_screw_dia, LAYER_HEIGHT);
}

module demo() {
// demo of the panel cutout and mounting holes

part_tft_2_8();

translate([0,-10,5]) {
    
    difference() {
        // panel
        color("blue")
        cube([100,70,3]);
        translate([0,10,0])
        mnt_cutout_bezel_tft_2_8(4, 3); 
    }
    translate([0,10,0]) {
    mirror([0,0,1])mnt_snap_tft_2_8(3);
  
   } 
   translate([0,10,0])
   mnt_bezel_tft_2_8(4,3);   

}
}



//demo();


/**
* EPaper display from Waveshare
**/

use <ukmaker_openscad_lib/Generics.scad>
use <ukmaker_openscad_lib/Standoffs.scad>

eink_panel_width = 79;
eink_panel_height = 36.7;

eink_visible_left = 2.4;
eink_visible_width = 68.2;
eink_visible_height = 30.6;
eink_panel_thickness = 1.4;
eink_pcb_width = 89.6;
eink_pcb_height = 38.6;
eink_pcb_thickness = 1.6;
eink_pcb_hole_dia = 2;
eink_hole_spacing_x = 84.5;
eink_hole_spacing_y = 33;

function waveshare_2_9_epaper_width() = eink_pcb_width;
function waveshare_2_9_epaper_height() = eink_pcb_height;
function waveshare_2_9_epaper_thickness() = eink_pcb_thickness + eink_panel_thickness;
function waveshare_2_9_epaper_pcb_width() = eink_pcb_width;

module waveshare_2_9_epaper_module() {
    // the display panel
    module panel() {

        dx = (eink_pcb_width - eink_panel_width)/2;
        dy = (eink_pcb_height - eink_panel_height) /2;
        dz = eink_pcb_thickness;
        translate([dx,dy,dz])
        color("#888888")
        cube([eink_panel_width,eink_panel_height, eink_panel_thickness]);
    }

    module visible() {

        dx = (eink_pcb_width - eink_panel_width)/2 + eink_visible_left;
        dy = (eink_pcb_height - eink_visible_height) /2;
        dz = eink_pcb_thickness+0.1;
        translate([dx,dy,dz])
        color("#ffffff")
        cube([eink_visible_width,eink_visible_height, eink_panel_thickness]);
    }

    module pcb() {
        // the PCB
        color("#4444ff")
        cube([eink_pcb_width, eink_pcb_height, eink_pcb_thickness]);
        // the connector
        dx = eink_pcb_width - 8;
        dy = (eink_pcb_height - 20)/2;
        dz = (-5.6);
        translate([dx,dy,dz])
        color("White")
        cube([10,20,5.6]);

    }

    pcb();
    panel();
    visible();
}

module waveshare_2_9_epaper_cutout() {

        dx = (eink_pcb_width - eink_panel_width)/2 + eink_visible_left;
        dy = (eink_pcb_height - eink_visible_height) /2;
        dz = eink_pcb_thickness;
        translate([dx,dy,dz])
        color("#888888")
        cube([eink_visible_width,eink_visible_height, eink_panel_thickness*4]);
}

module waveshare_2_9_epaper_standoffs() {
    w = eink_pcb_width;
    h = eink_pcb_height;
    dx = (eink_pcb_width - eink_hole_spacing_x) / 2;
    dy = (eink_pcb_height - eink_hole_spacing_y) / 2;

    op_4_grid(w,h,dx,dx,dy,dy) {

        base_height = eink_panel_thickness;
        base_dia = eink_pcb_hole_dia * 2;
        melt_height = eink_pcb_thickness * 3;
        melt_dia = eink_pcb_hole_dia * 0.9; // so it fits
        LAYER_HEIGHT = 0.15;
        translate([0,0,base_height])
        rotate([180,0,0])
        part_melt_standoff(base_height, base_dia, melt_height, melt_dia, LAYER_HEIGHT);
    }
}

module waveshare_2_9_epaper_mounting_clip() {
    pcb_mounting_clip(eink_pcb_height, 1.6, 5.1, 1.6, 4);
}

module waveshare_2_9_epaper_mounting_clips() {
    eink_pcb_width = 89.6;
    
    translate([0,-0.3,3.3]) {
            
        translate([eink_pcb_width-4.8,41,0])
        rotate([180,0,0])
        waveshare_2_9_epaper_mounting_clip();
        
        translate([0,41,0])
        rotate([180,0,0])    
        waveshare_2_9_epaper_mounting_clip();
    }
}

waveshare_2_9_epaper_cutout();

waveshare_2_9_epaper_module();

waveshare_2_9_epaper_mounting_clips();
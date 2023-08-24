use <ukmaker_openscad_lib/Generics.scad>


module Sparkfun_twoByTwoButtons() {

    tbt_hole_separation = 45;
    tbt_hole_offset = 2.5;
    tbt_hole_dia = 3;
    tbt_side = 50;
    tbt_button_offset = 4.5;
    tbt_button_spacing = 9.0;
    tbt_button_side = 16;
    tbt_button_height = 13.7;
    tbt_button_corner_radius = 2;
    tbt_pcb_thickness = 2;

    offset = tbt_button_offset;
    inset = tbt_button_offset + tbt_button_side;

    op_4_grid(50,50,offset, inset, inset, offset) {

        color("#ffffff")
        linear_extrude(height = tbt_button_height)
        uk_rounded_rectangle(tbt_button_side, tbt_button_side, tbt_button_corner_radius);
    }   
}

Sparkfun_twoByTwoButtons();
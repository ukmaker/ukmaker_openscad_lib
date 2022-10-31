/**
* A selection of generic shapes
**/
BOTTOM = 0;
TOP = 1;
LEFT = 2;
RIGHT = 3;
FRONT = 4;
BACK = 5;
module rounded_square(length, width, radius) {
    
    translate([radius, radius, 0])
    hull() {
        circle(r=radius);
        
        translate([length - 2 * radius,0,0])
        circle(r=radius);
        
        translate([length - 2 * radius, width - 2 * radius,0])
        circle(r=radius);
        
        translate([0, width - 2 * radius,0])
        circle(r=radius);
    }
}

/**
* Operator to apply to lay out 4 of something on a grid
* Generates 4 spaced on an XY grid
**/
module op_4_grid(length, width, offset_left, offset_right, offset_top, offset_bottom) {
    translate([offset_left, offset_bottom, 0])
    children();
    
    translate([length - offset_right, offset_bottom, 0]) 
    children();
    
    translate([length - offset_right, width - offset_top, 0]) 
    children();
    
    translate([offset_left, width - offset_top, 0]) 
    children();
}

module countersink(screw_hole_dia, thickness, LAYER_HEIGHT = 0.4) {
    print_height = thickness + LAYER_HEIGHT;
    translate([0,0,-LAYER_HEIGHT/2])
    rotate_extrude() 
    polygon(points=[[0,0],[screw_hole_dia/2,0],[screw_hole_dia/2,thickness/2],[screw_hole_dia,print_height],[0,print_height]]);
}
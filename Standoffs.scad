/**
* Basic shapes for electronics
**/
use <Generics.scad>

$fn=100;




module part_pcb(length, width, thickness) {
    cube([length, width, thickness]);
}

/**
* Holes are at the same distance from the edges along the Y-axis
* but can be offset by different amounts on the X-axis
**/
module part_pcb_with_uneven_holes(length, width, thickness, hole_dia, hole_offset_left, hole_offset_right, hole_offset_y) {
    
    difference() {
        part_pcb(length, width, thickness);
        
        translate([0,0,-0.1]) {
            op_4_grid(length, width, hole_offset_left, hole_offset_right, hole_offset_y, hole_offset_y)
            cylinder(h = thickness+0.2, d = hole_dia);  
        }
    }
}

module part_pcb_with_holes(length, width, thickness, hole_dia, hole_offset_x, hole_offset_y) {
    part_pcb_with_uneven_holes(length, width, thickness, hole_dia, hole_offset_x,     hole_offset_x, hole_offset_y);
}

/**
* Create simple standoffs to support PCBs
**/

/**
* Creates a two-level standoff with a hole in the middle
* which should take a screw.
* If this results in a hole which is too small to be usable
* consider using
* - flat_screw_standoff
* - snap_standoff
**/
module part_centred_screw_standoff(outer_height, outer_dia, inner_height, inner_dia, hole_dia, LAYER_HEIGHT) {
    
    // move down by 2 layers for best adhesion
    translate([0,0,-2*LAYER_HEIGHT])
    difference() {
        union() {
            cylinder(h=outer_height+ 2*LAYER_HEIGHT, d=outer_dia);
            translate([0,0,outer_height])
            cylinder(h=inner_height + 2 * LAYER_HEIGHT, d=inner_dia);
        }
        translate([0,0,2 * LAYER_HEIGHT])
        cylinder(h=(outer_height+inner_height + LAYER_HEIGHT), d=hole_dia);
    }
}

module part_flat_screw_standoff(height, dia, hole_dia, LAYER_HEIGHT=0.4) {
    
    // move down by 2 layers for best adhesion
    translate([0,0,-2*LAYER_HEIGHT])
    difference() {
        cylinder(h=height + 2 * LAYER_HEIGHT, d=dia);
        translate([0,0, 2 * LAYER_HEIGHT])
        cylinder(h=height + LAYER_HEIGHT, d=hole_dia);
    }
}
/**
* Makes a standoff which snaps into the hole
* the height of the part above the hole defaults to 5mm
**/
module part_snap_standoff(height, dia, inner_height, hole_dia, snap_height = 5, LAYER_HEIGHT = 0.4) {
    
    // move down by 2 layers for best adhesion
    print_height = height + 2 * LAYER_HEIGHT;
    translate([0,0,-2*LAYER_HEIGHT]) {
        cylinder(h=print_height, d=dia);
        cylinder(h=(print_height + inner_height + snap_height),d=hole_dia);
        
        translate([0,0,print_height+inner_height]){
            
            s = (snap_height < 3) ? 0 : 1;
            
            rotate_extrude(angle=60)
            polygon([[0.1,s],[hole_dia/2 + 2 * LAYER_HEIGHT, 0],[0.1,snap_height]]);
                
                
            rotate([0,0,90])
            rotate_extrude(angle=60)
            polygon([[0.1,s],[hole_dia/2 + 2 * LAYER_HEIGHT, 0],[0.1,snap_height]]);
                
        }
    }
}

part_centred_screw_standoff(3,6,2,4,2, 0.3);

translate([0,20,0])
part_flat_screw_standoff(6,4,2,0.3);

translate([0,7,0])
part_snap_standoff(3,6,2,4,5, 0.3);

translate([10,0,0])
part_pcb_with_holes(50,50,2,3,3,3);

translate([70,0,0])
part_pcb_with_uneven_holes(50,50,2,3,3,15,3);

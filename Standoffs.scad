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

module part_flat_screw_standoff(height, dia, hole_dia, LAYER_HEIGHT=0.15) {
    
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
module part_snap_standoff(height, dia, inner_height, hole_dia, snap_height = 5, LAYER_HEIGHT = 0.15) {
    
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
module part_melt_standoff(base_height, base_dia, melt_height, melt_dia, LAYER_HEIGHT = 0.15) {
    
    // move down by 2 layers for best adhesion
    print_height = base_height + 2 * LAYER_HEIGHT;
    translate([0,0,-2*LAYER_HEIGHT]) {
        cylinder(h=print_height, d=base_dia);
        cylinder(h=(print_height + melt_height),d=melt_dia);
    }
}

/*
* A melt standoff on a foot which can be stuck down
*/
module part_melt_standoff_sticky_foot(foot_dia, foot_thickness, base_height, base_dia, melt_height, melt_dia, LAYER_HEIGHT = 0.4) {

    cylinder(h=foot_thickness, d=foot_dia);
    translate([0,0,foot_thickness])
    part_melt_standoff(base_height, base_dia, melt_height, melt_dia, LAYER_HEIGHT);
}

module part_bite_sticky_foot(foot_dia, foot_thickness, base_height, base_dia, pcb_thickness, bite_height, bite_depth = 2.5, LAYER_HEIGHT = 0.15) {
    cylinder(h=foot_thickness, d=foot_dia);
    translate([0,0,foot_thickness])
    difference() {
    
        cylinder(h=base_height, d= base_dia);
        
        translate([base_dia/2 - bite_depth, -base_dia, bite_height])
        cube([2 * base_dia, 2 * base_dia, pcb_thickness + LAYER_HEIGHT]);
    }
    
}

module part_snap_bite_sticky_foot(foot_dia, foot_thickness, base_height, base_dia, pcb_thickness, bite_height, bite_depth = 2.5, LAYER_HEIGHT = 0.15) {
    cylinder(h=foot_thickness, d=foot_dia);
    //translate([0,0,foot_thickness])
    difference() {
    
        cylinder(h=base_height, d= base_dia);
        
        translate([base_dia/2 - bite_depth, -base_dia, bite_height])
        cube([2 * base_dia, 2 * base_dia, pcb_thickness + LAYER_HEIGHT]);
        
        // chop off some of the front of the bit
        translate([base_dia/2 - pcb_thickness/2, -base_dia/2, bite_height])
        cube([base_dia, base_dia, base_dia]);        
        // cut off the top leaving 1mm at the rim
        theta = atan((base_height - bite_height - pcb_thickness + LAYER_HEIGHT - 0)/(base_dia/2));
        translate([0,-base_dia, base_height])
        rotate([0,theta,0])
        cube([2 * base_dia, 2 * base_dia, base_height]);       
    }
    
}

module pcb_mounting_clip(pcb_depth, pcb_thickness, clip_width, clearance, clip_depth = 3) {
    // left side is just a slot
    // right side is a triangularclip which should flex
    // make this out of something which won't just snap
    // like PLA would. PETG is probably good
    tolerance = 0.4;
    left_shelf = 2;
    right_shelf = 2;
    snap_width = 1;
    right_edge = pcb_depth + clip_depth - left_shelf - right_shelf;
    
    module pillar(w, d, h) {
    
        hull() {
            cube([w, d, h - clip_depth/2]);
            
            translate([0,d/2,h - d/2])
            rotate([0,90,0])
            cylinder(w,d=d);
        }
    }
    
    module left() {
          pillar(clip_width, clip_depth, clearance + pcb_thickness * 4);
    }
    
    module right() {
        
        clip_height = 10 + clearance + pcb_thickness;
        slit_height = clip_height - 2 - clearance - pcb_thickness;
        pcb_top = clearance + pcb_thickness + tolerance;
        clip_thickness = clip_depth / 3;
        
        translate([0,right_edge,0])
        difference() 
       {
            pillar(clip_width, clip_depth, clip_height);
            
            translate([-0.05,clip_thickness,pcb_top - 0.05])
            pillar(clip_width+0.1,clip_thickness,slit_height);
            
       }
    }
    
    module prism(w,d,h) {
        translate([w,0,0])
        rotate([0,-90,0])
        linear_extrude(height = w)
        polygon([[0,0],[0,d],[h,d]]);
    }
    
    module pedestal() {
        cube([clip_width,2*clip_depth+pcb_depth- left_shelf - right_shelf, clearance/2]);
    }
    
    module cutout() {
        thickness = pcb_thickness + tolerance;
        translate([-0.01,clip_depth - left_shelf- tolerance/2,clearance])
        cube([clip_width+0.02, pcb_depth + tolerance, thickness]);
    }  
    
    difference() {
        union() {
            left();
            right();
            pedestal();
        }
        cutout();
    }
}

module mounting_pillar(pillar_side, pillar_height, pillar_hole_dia) {
    // just a cube with a hole in it
    difference() {
        translate([0,0,pillar_height/2])
        rounded_cube(pillar_side,pillar_side,pillar_height,1,true);
        cylinder(h = pillar_height + 0.1, d = pillar_hole_dia);
    }
}

// A mounting pillar with a foot which blends to one side
// so that it can be printed vertically without supports
module blended_mounting_pillar(pillar_side, pillar_height, pillar_hole_dia, foot_height) {
    mounting_pillar(pillar_side, pillar_height, pillar_hole_dia);
    step = 0.2; // resolution of a layer
    steps = foot_height / step;
    translate([-pillar_side/2, -pillar_side/2,0])
    for(i=[0:steps-1]) {
        translate([0,0,-(foot_height / steps * i)])
        scale([(steps-i)/steps,(steps-i)/steps,1])
        rounded_cube(
            pillar_side,
            pillar_side,
            step,
            1,
            false);
    }
}

// a rounded cube
// dimensioned to butt to the inner wall of a box
// Pillar is sized to take an M screw of the given diameter
// with a gap of 2mm by default around the edge from a countersunk cap
// Pillar is oversized by 0.2mm to allow it to be sunk into the wall by 0.2mm
module box_lid_pillar(screw_dia, pillar_height, inner_rounding, gap = 2) 
{
    // distance from the origin to the screw-hole centre
    // to allow the gap 
    countersink_dia = screw_dia * 2;
    dx = gap + countersink_dia/2;
    dy = dx;
    x = 2 * dx;
    y = 2 * dy; 

    difference()
    {
        rounded_cube(x + 0.2, y + 0.2, pillar_height, inner_rounding);
        // the screw-hole
        translate([dx + 0.1, dy + 0.1, 0.1])
        cylinder(h=pillar_height, d=screw_dia);
    }

}

function box_lid_pillar_side(screw_dia, gap = 2) = 
    2 * (gap + screw_dia);

module examples() {
    part_centred_screw_standoff(3,6,2,4,2, 0.3);

    translate([0,20,0])
    part_flat_screw_standoff(6,4,2,0.3);

    translate([0,7,0])
    part_snap_standoff(3,6,2,4,5, 0.3);

    translate([0,14,0])
    part_melt_standoff(3,6,5,4, 0.3);

    translate([0,35,0])
    part_melt_standoff_sticky_foot(10,1,3,6,5,4, 0.3);

    translate([10,0,0])
    part_pcb_with_holes(50,50,2,3,3,3);

    translate([70,0,0])
    part_pcb_with_uneven_holes(50,50,2,3,3,15,3);

    translate([0,50,0])
    part_bite_sticky_foot(10,1, 10, 6, 1.6, 6);

    translate([0,60,0])
    part_snap_bite_sticky_foot(10,1, 10, 6, 1.6, 6);

    translate([0,80,0])
    pcb_mounting_clip(37, 1.6, 5, 1.4, 4);

    translate([20,100,0])
    box_lid_pillar(2, 10, 2, 2);
}

blended_mounting_pillar(pillar_side=6, pillar_height=10, pillar_hole_dia=2, foot_height=6);
/**
* A selection of generic shapes
**/
BOTTOM = 0;
TOP = 1;
LEFT = 2;
RIGHT = 3;
FRONT = 4;
BACK = 5;
NW = 0;
NE = 1;
SW = 2;
SE = 3;

function north_west() = NW;
function north_east() = NE;
function south_west() = SW;
function south_east() = SE;

module uk_rounded_rectangle(length, width, radius) {
    
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

module countersink(screw_hole_dia, thickness, LAYER_HEIGHT = 0.15) {
    print_height = thickness + LAYER_HEIGHT;
    translate([0,0,-LAYER_HEIGHT/2])
    rotate_extrude() 
    polygon(points=[[0,0],[screw_hole_dia/2,0],[screw_hole_dia/2,thickness/2],[screw_hole_dia,print_height],[0,print_height]]);
}

// produces a triangular extrusion along the X-axis
// y extent is depth and z extent is height
module bevel(length, depth, height) {
translate([length,depth,0])
rotate([0,0,-90])
rotate([90,0,0])
linear_extrude(height = length)
polygon([[0,0],[depth,0],[depth,height]]);
}

/**
* Create a sloping bezel to go around a rectangular cutout placed on (0,0)
**/
module bezel(inner_width, inner_depth, bevel_depth, bevel_height, LAYER_HEIGHT = 0.15) {

    module knitted_bezel(inner_width, inner_depth, bevel_depth, bevel_height) {

        bezel_width = inner_width + 2 * bevel_depth;
        bezel_depth = inner_depth + 2 * bevel_depth;

        // left
        translate([-bevel_depth, bezel_depth - bevel_depth,0])
        rotate([0,0,-90])
        bevel(bezel_depth, bevel_depth, bevel_height);
        
        // top
        translate([bezel_width - bevel_depth, bezel_depth - bevel_depth, 0])
        rotate([0,0,180])
        bevel(bezel_width, bevel_depth, bevel_height);
        
        // right
        translate([bezel_width-bevel_depth, -bevel_depth,0])
        rotate([0,0,90])
        bevel(bezel_depth, bevel_depth, bevel_height);    
        // bottom
        translate([- bevel_depth, -bevel_depth, 0])
        rotate([0,0,0])
        bevel(bezel_width, bevel_depth, bevel_height);
  }
  
  knitted_bezel(inner_width, inner_depth, bevel_depth + LAYER_HEIGHT, bevel_height);
}

// Generates a grid of squares which can be used to cut out
// a grille for a loudspeaker
module speaker_grille_square(speaker_dia, hole_thickness, LAYER_HEIGHT = 0.15) {

    // 
    module grid() {
        // make the hole size three times the panel thickness
        side = hole_thickness * 2;
        // and the hole gap the same as the panel thickness
        gap = hole_thickness;
        spacing = side + gap;

        
        nSquares = (speaker_dia - gap) / (side + gap);
        iSquares = floor(nSquares);

        // move everything to be centred on the origin
        dx = -(iSquares * side)/2 - (iSquares-1) * gap /2;
        dy = dx;
        
        // position the squares centrally
        translate([dx,dy,0])
        for(x = [0:iSquares-1]) {
            for(y = [0:iSquares-1]) {
                translate([x * spacing, y * spacing, 0])
                cube([side, side, hole_thickness + 2 * LAYER_HEIGHT]);
            }
        }
    }
    
    module mask() {
        st = hole_thickness + 2 * LAYER_HEIGHT;
        ct = hole_thickness + 4 * LAYER_HEIGHT;
        translate([0,0,-LAYER_HEIGHT])
        difference() {
            translate([-speaker_dia, -speaker_dia,0])
            cube([speaker_dia * 2, speaker_dia * 2, st]);
            //translate([speaker_dia/2, speaker_dia/2,-LAYER_HEIGHT])
            cylinder(h = ct, d = speaker_dia);
        }
    }
    
    difference() {
        color("red")grid();
        mask();
    }
}

module rounded_cube(w,l,h,r=2,centre=false) {

    if(centre) {
     translate([-w/2,-l/2,-h/2])
        linear_extrude(height = h)
        uk_rounded_rectangle(w,l,r);
    } else {
        linear_extrude(height = h)
        uk_rounded_rectangle(w,l,r);
    }
}

// return the inner rounding radius to use to keep a constant wall thickness
function inner_rounding(outer_rounding, wall_thickness) =
    outer_rounding - wall_thickness;

    
module cone(height,dia) {
    rotate_extrude($fn=100)
    polygon( points = [[0,0],[dia/2,0],[0,height]]);
}

// A quarter of a cone in the (+x, +y) quadrant
module quarter_cone(height, dia) {

    difference()
    {
        cone(height,dia);
        translate([0, -dia, 0])
        cube([2*dia,2*dia,2*height], true);
        translate([-dia, 0, 0])
        cube([2*dia,2*dia,2*height], true);
    }
}
//speaker_grille_square(20,2);

//rotate([0,0,-90])
//bevel(100,6,3);

//bezel(200,150,4,3);
//color("red")
//translate([2,1,0])
//cube([198,148,2]);

quarter_cone(10,4);
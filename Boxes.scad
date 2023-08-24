/**
 * A selection of boxes
 **/
use <Generics.scad>
use <Standoffs.scad>
$fn = 100;

// Generic box with no top
// external dimensions
module box_no_top(width, depth, height, thickness, rounding) 
{
    inner_width = width - 2*thickness;
    inner_height = height;
    inner_depth = depth - 2*thickness;
    dx = thickness;
    dy = thickness;
    dz = thickness;
    
    difference()
    {
        rounded_cube(width, depth, height, rounding);
        translate([dx,dy,dz])
        rounded_cube(inner_width, inner_depth, inner_height, inner_rounding(rounding, thickness));
    }
}

module box_no_top_with_panel_pillars(width, depth, height, thickness, rounding, pillar_screw_dia, pillar_height) 
{
    inner_rounding = inner_rounding(rounding, thickness);
    
    dx = thickness - 0.2;
    dy = dx;
    dz = height - pillar_height - thickness;
    pillar_side = box_lid_pillar_side(pillar_screw_dia);
    
    box_no_top(width, depth, height, thickness, rounding);
    translate([dx, dy, dz])
    box_lid_pillar(pillar_screw_dia, pillar_height, inner_rounding, gap = 2);
    
    translate([width - pillar_side - dx, dy, dz])
    box_lid_pillar(pillar_screw_dia, pillar_height, inner_rounding, gap = 2);
    
    translate([width - pillar_side - dx, depth - pillar_side - dy, dz])
    box_lid_pillar(pillar_screw_dia, pillar_height, inner_rounding, gap = 2);
    
    translate([dx, depth - pillar_side - dy, dz])
    box_lid_pillar(pillar_screw_dia, pillar_height, inner_rounding, gap = 2);
    
}

/**
* A box with a sloping front panel (e.g. for an alarm clock)
**/
module
sloping_front_console(width, height, depth_top, depth_bottom, thickness, rounding) {

    module sloping_front_core(width, height, depth_top, depth_bottom, rounding) {

    
        // box fits in the volume which would enclose top and bottom
        // joined by an edg of zero radius
        // so the front is described as the hypotenuse on a triangle
        // of sides h and d1-d2
        // then we clip the top and bottom for the edge cylinder
        //
        //                  d1
        //         O---------------
        //        /
        //       /
        //      /                  h
        //     /
        //    /              d2
        //    O--------------------
        base = depth_bottom - depth_top;
        theta = atan(height/base);
        delta1 = rounding * tan(theta / 2);

        delta2 = rounding / tan(theta / 2);

        s = sqrt(height*height + base*base);
        hypotenuse = s - delta1 - delta2;
        
        module side() {
 


        // sloping front, vertical back
        topx = (s - delta1) * cos(theta);
        toph = (s - delta1) * sin(theta);
        botx = delta2 * cos(theta);
        boty = delta2 * sin(theta);
        rotate([90,0,90])
        linear_extrude(height=width)
         polygon(
         [
            [delta2,0],
            [depth_bottom,0],
            [depth_bottom,height],
            [base+delta1,height],
            [topx,toph],
            [botx,boty],
            [delta2,0]
          ]); 
         }

        hull() {
            // bottom cylinder along x-axis
            translate([0,delta2,rounding])
            rotate([0,90,0])
            cylinder(h=width,r=rounding);

            // top cylinder
            translate([0,base+delta1, height-rounding])
            rotate([0,90,0])
            cylinder(h=width,r=rounding);

            side();
        }

    }
    
    difference() {
        
        base = depth_bottom - depth_top;
        theta = atan(height/base);
        dy = thickness / sin(theta) + thickness / tan(theta);
        px = (width - 2*thickness) / width;
        py = 1;
        pz = (height - 2 * thickness) / height;
        
        
        sloping_front_core(width, height, depth_top, depth_bottom, rounding);
        
        
        translate([thickness,dy,thickness])
        scale([px,pz,pz])
        sloping_front_core(width, height, depth_top, depth_bottom, rounding);
        
        // chop the back off
        translate([thickness,depth_bottom-dy,thickness])
        cube([width - 2 * thickness, 2 * thickness, height - 2 * thickness]);
        
        //rotate([theta,0,0])
        //#cube([dy,150,dy]);
    }
    
}

/**
* A sloped box with a top cutout for an upwards-facing front panel
**/
module
sloping_top_console (width, depth, height_front, height_back, thickness, rounding,
              screw_hole_dia, LAYER_HEIGHT = 0.4)
{

  // tilt it and chop the bottom off
  theta = asin ((height_back - height_front) / depth);
  screw_hole_offset = thickness + 1.5 * screw_hole_dia - LAYER_HEIGHT;
  d = depth;
  dh = height_back - height_front;
  l = sqrt (d * d + dh * dh);

  difference ()
  {
    translate ([ 0, depth, 0 ]) rotate ([ theta, 0, 0 ])
        translate ([ 0, -depth, 0 ])
    {
      difference ()
      {
        union ()
        {
          // build a rounded corner, rectangular box
          difference ()
          {
            union() {
                rounded_core (width, depth, height_back, thickness, rounding);
                translate ([ 0, depth+0.1, 0 ]) rotate ([ 90, 0, 0 ]) children(1);
            }
            // back panel cutouts
            translate ([ 0, depth+0.1, 0 ]) rotate ([ 90, 0, 0 ]) children(0);
          }
          // add extrusions to hold screws
          op_4_grid (width, depth, screw_hole_offset, screw_hole_offset,
                     screw_hole_offset, screw_hole_offset) difference ()
          {
            cylinder (h = height_back - 2 * thickness, d = screw_hole_dia * 3);
            translate ([ 0, 0, -LAYER_HEIGHT ])
                cylinder (h = height_back + (LAYER_HEIGHT - thickness) * 2,
                          d = screw_hole_dia);
          }
        }

        // add a recessed lip into which the top will fit
        // height of the lip is the wall thickness
        // recess is half the wall thickness
        translate ([
          thickness / 2, thickness / 2, height_back - thickness - LAYER_HEIGHT
        ]) rounded_core (width - thickness, depth - thickness,
                         thickness + 2 * LAYER_HEIGHT, thickness, rounding);
      }
    }
    // chop off the bottom
    translate ([ -width / 2, -depth / 2, -height_back ])
        cube ([ width * 2, depth * 2, height_back ]);

    // create the lip on the bottom
  }

  color ("RED") linear_extrude (height = thickness)
      uk_rounded_rectangle (width, d, rounding);
}

module
rounded_core (width, depth, height, thickness, rounding)
{
  // the core box
  linear_extrude (height = height) difference ()
  {
    uk_rounded_rectangle (width, depth, rounding);
    translate ([ thickness, thickness, 0 ]) 
    uk_rounded_rectangle (
        width - thickness * 2, depth - thickness * 2, rounding);
  }
}

// sloping_body (150, 100, 40, 60, 3, 5, 3);

sloping_front_console(160,100,60,80,2,4);

translate([200,0,0])
box_no_top_with_panel_pillars(width = 100, depth = 50, height = 30, thickness = 2, rounding = 4, pillar_screw_dia = 2.5, pillar_height = 10);
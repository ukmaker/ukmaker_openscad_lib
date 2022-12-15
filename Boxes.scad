/**
 * A selection of boxes
 **/
use <Generics.scad>
$fn = 100;

module
sloping_console (width, depth, height_front, height_back, thickness, rounding)
{
}

module
sloping_body (width, depth, height_front, height_back, thickness, rounding,
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
      rounded_square (width, d, rounding);
}

module
rounded_core (width, depth, height, thickness, rounding)
{
  // the core box
  linear_extrude (height = height) difference ()
  {
    rounded_square (width, depth, rounding);
    translate ([ thickness, thickness, 0 ]) rounded_square (
        width - thickness * 2, depth - thickness * 2, rounding);
  }
}

// sloping_body (150, 100, 40, 60, 3, 5, 3);
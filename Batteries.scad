/**
* Battery holders
**/

aa_height = 48.5;
aa_dia = 14;
aa_terminal_height = 1.5;
aa_terminal_dia = 5.5;

aa_box_height = 58;
aa_box_width = 64;
aa_box_depth = 15.5;
aa_box_wall_thickness = 1.6;

aa_box_hole_dia = 4.7;
aa_box_hole_spacing = 46/3;
aa_box_num_holes = 4;

aaa_height = 44.5;
aaa_dia = 10.5;
aaa_terminal_height = 0.8;
aaa_terminal_dia = 3.8;


aaa_box_height = 52;
aaa_box_width = 47.4;
aaa_box_depth = 12;
aaa_box_wall_thickness = 1.7;
aaa_box_hole_dia = 2.9;
aaa_box_hole_spacing = 36.4 - aaa_box_hole_dia;
aaa_box_num_holes = 2;


aaa_leaded_box_height = 52;
aaa_leaded_box_width = 49;
aaa_leaded_box_depth = 12.5;
aaa_leaded_box_wall_thickness = 2.1;
aaa_leaded_box_hole_dia = 2.65;
aaa_leaded_box_hole_spacing = 39.5 - aaa_leaded_box_hole_dia;
aaa_leaded_box_num_holes = 2;

aa_cell_dimensions = [ aa_height, aa_dia, aa_terminal_height, aa_terminal_dia];
aaa_cell_dimensions = [ aaa_height, aaa_dia, aaa_terminal_height, aaa_terminal_dia];

aa_x4_flat_holder_dimensions = [ aa_box_height, aa_box_width, aa_box_depth, aa_box_wall_thickness, aa_box_hole_dia, aa_box_hole_spacing, aa_box_num_holes ];

aaa_x4_flat_holder_dimensions = [ aaa_box_height, aaa_box_width, aaa_box_depth, aaa_box_wall_thickness, aaa_box_hole_dia, aaa_box_hole_spacing, aaa_box_num_holes ];

aaa_x4_flat_leaded_holder_dimensions = [ aaa_leaded_box_height, aaa_leaded_box_width, aaa_leaded_box_depth, aaa_leaded_box_wall_thickness, aaa_leaded_box_hole_dia, aaa_leaded_box_hole_spacing, aaa_leaded_box_num_holes ];

cell_dimensions = [ aa_cell_dimensions, aaa_cell_dimensions ];
x4_flat_holder_dimensions = 
[ aa_x4_flat_holder_dimensions, aaa_x4_flat_holder_dimensions , aaa_x4_flat_leaded_holder_dimensions ];

function cell_height() = 0;
function cell_dia() = 1;
function cell_terminal_height() = 2;
function cell_terminal_dia() = 3;

function x4_flat_box_height() = 0;
function x4_flat_box_width() = 1;
function x4_flat_box_depth() = 2;
function x4_flat_box_wall_thickness() = 3;
function x4_flat_box_hole_dia() = 4;
function x4_flat_box_hole_spacing() = 5;
function x4_flat_box_num_holes() = 6;

function aa_cell() = 0;
function aaa_cell() = 1;

function aa_holder() = 0;
function aaa_holder() = 1;
function aaa_leaded_holder() = 2;

module dry_cell(cell_dimensions) {
    color("Gold")
    cylinder(h = cell_dimensions[cell_height()], d = cell_dimensions[cell_dia()]);

    translate([0,0,aa_height-0.01])
    color("Silver")
    cylinder(h=cell_dimensions[cell_terminal_height()], d = cell_dimensions[cell_terminal_dia()]);
}


module up_cell(dimensions)
{
    dry_cell(dimensions);
}

module down_cell(dimensions)
{
    translate([0,0,dry_cell(dimensions[cell_height()])]);
    rotate([180,0,0])
    dry_cell(dimensions);
}

module oriented_cell(up, dimensions) {
    if(up)
    {
        up_cell(dimensions);
    } 
    else 
    {
        down_cell(dimensions);
    }
}

module aa_cell(up = true)
{
    oriented_cell(up, cell_dimensions[aa_cell()]);
}

module aaa_cell(up = true)
{
    oriented_cell(up, cell_dimensions[aaa_cell()]);
}



module x4_flat_battery_holder(dimensions) {

    box_height = dimensions[x4_flat_box_height()];
    box_width = dimensions[x4_flat_box_width()];
    box_depth = dimensions[x4_flat_box_depth()];
    box_wall_thickness = dimensions[x4_flat_box_wall_thickness()];
    box_hole_dia = dimensions[x4_flat_box_hole_dia()];
    box_hole_spacing = dimensions[x4_flat_box_hole_spacing()];
    box_num_holes = dimensions[x4_flat_box_num_holes()];

    module form(h,w,d) {
        // cylinders at each end 
        cylinder(h=h, d=d);
        delta = w - d;
        translate([delta,0,0])
        cylinder(h=h, d= d);
        // cube for the base
        translate([-d/2, 0,0])
        cube([w, d/2, h]);
        // cube for the centre
        translate([0,-d/2,0])
        cube([delta, d, h]);
    }
    difference() {
       color("Blue")
       form(box_height, box_width, box_depth);

        // now cut out the same shape but slightly smaller
        translate([0,0,box_wall_thickness])
        form(   box_height - 2*box_wall_thickness, 
                box_width - 2*box_wall_thickness, 
                box_depth - 2*box_wall_thickness
            );
        // and the openening on the top
        translate([box_wall_thickness, -box_depth/2 - box_wall_thickness,box_wall_thickness])
        cube([box_width-box_depth, box_depth, box_height  - 2*box_wall_thickness]);
        
        // mounting holes
        x4_flat_battery_holder_mounting_holes(2 * box_wall_thickness, dimensions);
        
   }
    /*
    // put some batteries in
   translate([ box_wall_thickness / 2, 0, 2 * box_wall_thickness]) {
   aa_cell();
   translate([box_width / 4, 0,0])
   aa_cell(false);
   translate([2 * box_width / 4, 0,0])
   aa_cell();
   translate([3 * box_width / 4, 0,0])
   aa_cell(false);
   }*/
}

module x4_flat_battery_holder_mounting_holes(depth, dimensions) {
    box_height = dimensions[x4_flat_box_height()];
    box_width = dimensions[x4_flat_box_width()];
    box_depth = dimensions[x4_flat_box_depth()];
    box_wall_thickness = dimensions[x4_flat_box_wall_thickness()];
    box_hole_dia = dimensions[x4_flat_box_hole_dia()];
    box_hole_spacing = dimensions[x4_flat_box_hole_spacing()];
    box_num_holes = dimensions[x4_flat_box_num_holes()];
    
        // mounting holes
        v = box_height / 2;
        l = (box_width - box_hole_spacing * (box_num_holes - 1)) / 2 - box_depth/2;
        rotate([90,0,0])
        translate([l, v, -box_depth/2 - 1]) {
            for(i = [0:(box_num_holes - 1)]) 
            {
              translate([box_hole_spacing * i,0,0]) cylinder(h=depth, d = box_hole_dia);
            }
        }
}

module generic_x4_flat_battery_holder(dimensions, with_holder = true, with_holes = false, hole_depth = 3) 
{
    if(with_holder && !with_holes) 
    {
        x4_flat_battery_holder(dimensions);
    } else if(with_holder && with_holes) 
    {
        difference() 
        {
            x4_flat_battery_holder(dimensions);
            x4_flat_battery_holder_mounting_holes(hole_depth, dimensions);
        }
    } else if(with_holes) {
        x4_flat_battery_holder_mounting_holes(hole_depth, dimensions);
    }
}

module aa_x4_flat_battery_holder(with_holder = true, with_holes = false, hole_depth = 3) 
{
    generic_x4_flat_battery_holder(x4_flat_holder_dimensions[aa_holder()], with_holder, with_holes, hole_depth);
}

module aaa_x4_flat_battery_holder(with_holder = true, with_holes = false, hole_depth = 3) 
{
    generic_x4_flat_battery_holder(x4_flat_holder_dimensions[aaa_holder()], with_holder, with_holes, hole_depth);
}

module aaa_x4_flat_leaded_battery_holder(with_holder = true, with_holes = false, hole_depth = 3) 
{
    generic_x4_flat_battery_holder(x4_flat_holder_dimensions[aaa_leaded_holder()], with_holder, with_holes, hole_depth);
}

if($preview) 
{
    aa_x4_flat_battery_holder(true,true);
    translate([80,0,0])
    aaa_x4_flat_battery_holder(true,true);
    translate([160,0,0])
    aaa_x4_flat_leaded_battery_holder(true,true);
}
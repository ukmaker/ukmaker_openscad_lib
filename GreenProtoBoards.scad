use <Standoffs.scad>
$fn=100;
/**
* A bunch of things to use with my green proto boards
**/

proto_board_hole_dia = 2.3;
proto_board_thickness = 1.6;
board_clearance = 5;

proto_board_mounting_hole_dia = 2.3;

module standoff(LAYER_HEIGHT = 0.15) {

    part_melt_standoff_sticky_foot(10,1,
    board_clearance,           proto_board_hole_dia * 2,
    proto_board_thickness * 2 ,proto_board_hole_dia
    , LAYER_HEIGHT);

}
    
module bite_standoff(bite_depth, LAYER_HEIGHT = 0.15) {

    part_bite_sticky_foot(10,1,
    board_clearance + 2 * proto_board_thickness,proto_board_hole_dia * 2,
    proto_board_thickness,
    board_clearance, bite_depth
    , LAYER_HEIGHT);

}

module snap_bite_standoff(bite_depth, LAYER_HEIGHT = 0.15) {

    part_snap_bite_sticky_foot(10,1,
    board_clearance + 2 * proto_board_thickness,proto_board_hole_dia * 2,
    proto_board_thickness,
    board_clearance, bite_depth
    , LAYER_HEIGHT);

}

module _proto_board(w,d) {
    mounting_hole_x_spacing = w - 4.3;
    mounting_hole_y_spacing = d - 4;
    mounting_hole_offset = 2.15;

    color("Green")
    difference() 
    {
        cube([w,d,proto_board_thickness]);
        translate([mounting_hole_offset,mounting_hole_offset,-0.05])
        {
            cylinder(h=proto_board_thickness+0.1, d=proto_board_mounting_hole_dia);
            translate([0,mounting_hole_y_spacing,0])
            cylinder(h=proto_board_thickness+0.1, d=proto_board_mounting_hole_dia);
            translate([mounting_hole_x_spacing,mounting_hole_y_spacing,0])
            cylinder(h=proto_board_thickness+0.1, d=proto_board_mounting_hole_dia);
            translate([mounting_hole_x_spacing,0,0])
            cylinder(h=proto_board_thickness+0.1, d=proto_board_mounting_hole_dia);
       
      }
    }
}

module proto_board_70_x_50() {
    _proto_board(70,50);
}

module proto_board_80_x_20() {
    _proto_board(80,20);
}

for(y = [0:20:60]) {

translate([0,y,0]) {

standoff();

translate([20,0,0])
standoff();
    //snap_bite_standoff(proto_board_thickness);

translate([40,0,0])
standoff();
    //bite_standoff(proto_board_thickness*1.5);

translate([60,0,0])
standoff();
    //snap_bite_standoff(proto_board_thickness*1.5);
}
}

translate([100,0,0])
proto_board_70_x_50();

translate([100,60,0])
proto_board_80_x_20();
/**
* Collection of basic models
* showing the volumetric shape
* of various development boards
*
* Basically just the PCB and any big
* sticky-out bits
**/
// board = [ w, h, thickness, [ [x0, y0, d0],[x1, y1, d1]...] drillings ]

WIDTH = 0;
HEIGHT = 1;
THICKNESS = 2;

BlackPillBoard = [ 52.81, 20.78, 1.2, [] ];

module rectangular_board(board_def) {
    cube([board_def[WIDTH], 
    board_def[HEIGHT], board_def[THICKNESS]]);
}

module we_act_black_pill() {
    color("Black")
    difference() 
    {
        rectangular_board(BlackPillBoard);
        we_act_black_pill_piercings();
    }

}

module we_act_black_pill_piercings() {
    // should probably generate all the pin holes
    // since there are no mounting holes
    hole_dia = 0.8;
    pad_dia = 1.4;
    pad_spacing = 2.54;
    row_spacing = 15.22;
    num_pads_per_side = 20;
    first_pad_left_offset = 1.27;
    
    module pad() {
        // just the drilling
        cylinder(h = BlackPillBoard[THICKNESS] + 0.2, d = hole_dia);
    }
    
    module row_of_pads() 
    {
        dy = 0;
        dz = -0.1;
        for(i = [0:num_pads_per_side-1] ) 
        {
            dx = first_pad_left_offset + i * pad_spacing;
            translate([dx, dy, dz]) pad();
        }
    }
    dy = (BlackPillBoard[HEIGHT] - row_spacing) / 2;
    translate([0,dy,0]) row_of_pads();
    translate([0,dy + row_spacing,0]) row_of_pads();
}

if($preview) {
    we_act_black_pill();
}
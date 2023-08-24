if($preview) {
    $fn = 20;
} else {
    $fn = 100;
}

module clip() {
    
    hole_dia = 8;
    slot_width = 3.5;
    slot_depth = 8;
    thickness = 2;
    
    t = 0.1;
    
    module hook() {
eps = 0.01;
        
       translate([-15,0,-2]) 
        rotate([90,110,0])
        scale(0.2) {
        translate([eps, 60, 0])
        rotate_extrude(angle=200, convexity=10)
        translate([40, 0]) 
           circle(15);
           /*
rotate_extrude(angle=90, convexity=10)
   translate([20, 0]) circle(10);
translate([20, eps, 0])
   rotate([90, 0, 0]) cylinder(r=10, h=80+eps);*/
        }
    }
    
    module base() {
        
        cylinder(h=6, d=hole_dia*1.5);
        
        translate([0,0,6-t])
        cylinder(h=thickness,d=slot_width);
        
        translate([0,0,6+thickness-t])
        cylinder(h=4,d=hole_dia - 0.4);
        
    }
    
    base();
    hook();
    
    
}

clip();
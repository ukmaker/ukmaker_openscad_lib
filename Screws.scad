/**
* Understandable screws
**/

module countersunk_screw(l,thread_d, dk, k) {
    dfd = thread_d / 10;
    scale([1.005, 1.005, 1])
    translate([0,0,l-0.1])
    rotate_extrude()
    polygon([[0,0],[thread_d/2,0],[dk/2,k-dfd],[dk/2,k],[0,k],[0,0]]);
    cylinder(h=l,d=thread_d);
}

// SEE: http://thai.screws-bolt.com/photo/screws-bolt/editor/20160906122700_47354.jpg


module countersunk_screw_M2(length) {
    hole_dia = 2;
    hole_dk = 4;
    hole_k = 1.2;
    
    countersunk_screw(length,hole_dia,hole_dk,hole_k);
}


module countersunk_screw_M2_5(length) {
    hole_dia = 2.5;
    hole_dk = 5;
    hole_k = 1.5;

    countersunk_screw(length,hole_dia,hole_dk,hole_k);
}
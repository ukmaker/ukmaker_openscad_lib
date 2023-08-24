
module speaker_round_50mm() {

    spk_dia_1 = 50;
    spk_dia_2 = 30;
    spk_dia_3 = 20;
    spk_t_1 = 4;
    spk_t_2 = 2;
    spk_t_3 = 6;

    cylinder(h=spk_t_1,d=spk_dia_1);
    translate([0,0,spk_t_1])
    cylinder(h=spk_t_2, d=spk_dia_2);
    translate([0,0,spk_t_2])
    cylinder(h=spk_t_3,d=spk_dia_3);
}

module grille_speaker_round_50mm(hole_dia, hole_thickness) {

    // one central hole then two concentric rings of holes
    cylinder(h = hole_thickness, d = hole_dia);
    for(i = [0 : 5]) {
        phi = i * 60;
        rotate([0,0,phi])
        translate([8.5,0,0])
        cylinder(h = hole_thickness, d = hole_dia);
    }
    for(i = [0 : 11]) {
        phi = i * 30;
        rotate([0,0,phi])
        translate([17,0,0])
        cylinder(h = hole_thickness, d = hole_dia);
    }
}
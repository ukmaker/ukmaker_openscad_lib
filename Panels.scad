/**
* Panels with various mountings
**/
use <Generics.scad>
use <Boxes.scad>
use <Screws.scad>

function Panel_Component_Cover() = 0;
function Panel_Component_Panel() = 1;
function Panel_Component_Recess() = 2;

module panel_with_recess_and_screw_cover_components(
    // 0 => return the cover
    // 1 => return the panel
    // 2 => return the recess  
    component,
    
    // external dimensions of the panel
    width, depth, thickness, rounding,
    
    // internal dimensions of the recess
    recess_width, recess_depth, recess_height, recess_wall_thickness, recess_rounding,
    
    // thickness of the cover plate
    recess_cover_thickness, 
    
    // offset from the panel's origin of the recess inner (0,0)
    recess_x, recess_y,
    
    // width of snap tabs
    tab_width,
    // dia of the screw hole
    tab_hole_dia,
    // countersink the hole
    tab_hole_countersink = true
    )
{
    // recess outer dimensions
    // these are also the width and depth of the cover
    row = recess_width + 2 * recess_wall_thickness;
    rod = recess_depth + 2 * recess_wall_thickness;
    roh = recess_height + recess_wall_thickness;
    
    // offsets
    rox = recess_x - recess_wall_thickness;
    roy = recess_y - recess_wall_thickness;
    roz = -roh + 0.2;
    rcoz = thickness - recess_cover_thickness + 0.01;
    
    module cover(for_difference = false) {
        // cutout for the recess cover
        fdx = 0.05;
        fdy = 0.05;
        fdz = 0.05;
        
        translate([rox, roy, rcoz]) 
        {

        if(for_difference) {
            translate([-fdx,-fdy,-fdz])
            rounded_cube(row+2*fdx, rod+2*fdy, recess_cover_thickness+fdz, recess_rounding);  
        } else {
            rounded_cube(row, rod, recess_cover_thickness, recess_rounding);  
        }        
        //  tabs at 1/4 and 3/4 on the left
        $fn=100;
        translate([-recess_cover_thickness, tab_width, -recess_cover_thickness-0.1])
        rounded_cube(tab_width, tab_width, recess_cover_thickness+0.2);
        translate([-recess_cover_thickness, rod - 2*tab_width, -recess_cover_thickness-0.1])
        rounded_cube(tab_width, tab_width, recess_cover_thickness+0.2);
        // single tab with a screw-hole on the right
        dy = rod/2 - tab_width/2;
        dx = row - 2*recess_cover_thickness;
        translate([dx,dy,0])
        if(!for_difference) {
            difference() 
            {
                rounded_cube(1.5 * tab_width, tab_width, recess_cover_thickness);
                // the screw hole
                translate([tab_width,tab_width/2,-0.1]) {
                    cylinder(h = recess_cover_thickness+0.2, d = tab_hole_dia);
                    if(tab_hole_countersink) {
                    translate([0,0,-10+recess_cover_thickness/2 - 0.2])
                        countersunk_screw_M2(10);
                    }
                }
            } 
        } else {
            translate([-fdx,-fdy,-fdz])
            rounded_cube(1.5 * tab_width + 2*fdx, tab_width+2*fdy, recess_cover_thickness+fdz);
            // the screw hole
            translate([1 * tab_width,tab_width/2,-thickness-0.1])
            cylinder(h = thickness+0.2, d = tab_hole_dia * 0.75);
        }
        }
    }
    
    module panel() {
       difference() 
       {
            // The blank panel
            rounded_cube(width, depth, thickness, rounding);
            
            // cutout for the recess cover
            //translate([rox, roy, rcoz]) 
            cover(true);
            
            // cutout for the recess inner
            translate([rox + recess_wall_thickness, roy + recess_wall_thickness, -0.1])
            rounded_cube(
                recess_width, 
                recess_depth,
                thickness+0.2, recess_rounding);
                
            // Indent for the recess itself
            recess(true);

        }
    }
    
    module recess(for_difference = false) {
        // the recess
        dx = 0.05;
        dy = 0.05;
        dz = 0.05;
        
        translate([rox, roy, roz])
        difference() {
            if(for_difference) {
                translate([-dx,-dy,-dz])
                rounded_cube(row + 2*dx, rod + 2*dy, roh+dz, recess_rounding);
            } else {
                rounded_cube(row, rod, roh, recess_rounding);
            }
            translate([recess_wall_thickness, recess_wall_thickness, recess_wall_thickness+0.1])
            rounded_cube(recess_width, recess_depth, recess_height, recess_rounding);
            if(!for_difference) {
                translate([0, 0, rcoz - roz]) 
                cover(true);
            }
        }
    }
    
    if(component == Panel_Component_Cover()) {
        cover();
    } else if(component == Panel_Component_Panel()) {
        panel();
    } else {
        recess();
    }
}

// example
module example(component) {
    panel_with_recess_and_screw_cover_components(component, 
        100,80,4,3,  
        50,60,12,2, 
        2,  
        1.5, 
        10,10, 
        5, 
        2);
}
//translate([128.2,8.2,3])
example(0);
//translate([80,0,0]) 
example(1);
//translate([200,0,0]) 
example(2);
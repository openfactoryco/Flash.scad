
module base(){
    $fn = 200;
    translate([0,0,plate_thickness+foot_length])
    color("blue"){
        cutTube(inner=base_radius-5,outer=base_radius,h=base_height,start=-20,finish=130,round=true);
        hull(){
            rotate([0,0,-20])translate([base_radius-5,0,0])cube([5,0.1,base_height]);
            rotate([0,0,-100])translate([base_radius-5,0,0])cube([5,0.1,base_height]);
        }
    }
}

module base_side(){
    $fn = 200;
    r=5;
    translate([0,0,plate_thickness+foot_length])
    color("blue"){
        cutTube(inner=base_radius-r,outer=base_radius,h=base_height,start=50,finish=360,round=true);
        hull(){
            rotate([0,0,0])translate([base_radius-r/2,0,0])cylinder(r=r/2,h=base_height);
            rotate([0,0,-5])translate([base_radius-15,0,0])cylinder(r=r/2,h=base_height);
        }
    }
}


module top_plate(){
    wall = 5;
    asm_loc = [0,0,base_height+foot_length+plate_thickness];
    $fn = 200;

    color("black"){
        difference(){
            translate(asm_loc)cylinder(r=base_radius, h=plate_thickness);
            extrusion(diff=true);
            stepper_subasm(diff=true);
            minkowski(){
                projector_throw();
                sphere(r=2, $fn=60);
            }
        }
    }
}

module bottom_plate(){
    asm_loc = [0,0,foot_length];
    $fn = 500;
    translate(asm_loc)
    color("black"){
        hull()cutTube(inner=base_radius-5,outer=base_radius,h=plate_thickness,start=50,finish=130,round=true);
    }
}


module amber_lid(){
    asm_loc = [0,0,base_height+plate_thickness*2+foot_length];
    $fn = 500;
    color("DarkOrange", 0.5){
        translate(asm_loc)difference(){
            cylinder(r=base_radius, h=lid_height);
            r1 = base_radius - lid_thickness;
            h1 = base_height - lid_thickness;
            translate([0,0,-1])cylinder(r=r1, h=h1+2);
        }
    }
}

module vat_lower(r=5,window_r=2,h=10){
    color("orange"){
        minkowski(){
            difference(){
                translate([-area[0]/2,0,1+base_height+plate_thickness*2+foot_length])cube([area[0]+r*2,area[1]+r*2,h-2]);
            minkowski(){
                projector_throw(diff=true);
                sphere(r=2, $fn=60);
            }
            }
            cylinder(r=r,h=1);
        }
    }
}

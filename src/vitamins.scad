module extrusion(x=20, y=20, z=extrusion_length, diff=false){
    asm_rot = [0,0,90];
    asm_loc = [-x/2-10-vat_stepper_gap,stepper_obj[WIDTH]-extrusion_stepper_gap,plate_thickness+foot_length];
    rotate(asm_rot)
    translate(asm_loc)
    color("silver"){
        if(diff) {
            cube([x,y,z]);
        }
        else {
            translate([10,10,0])for(i=[0:3])
                rotate([0,0,90*i])
                difference(){
                    union(){
                        cube([4,4,z]);
                        translate([4,8.5,0])cube([6,1.5,z]);
                        translate([8.5,4,0])cube([1.5,6,z]);
                        rotate([0,0,45])translate([0,-1.5/2,0])cube([13,1.5,z]);
                    }
                    translate([0,0,-1])cylinder(r=1.5, h=z+2);
                }
        }
    }
}

module acme_nut(){
    start = movement[0];
    finish = movement[1];
    range = finish-start;

    translate([stepper_loc[0],stepper_loc[1],stepper_loc[2]-3.81+start+$t*range+stepper_obj[LENGTH]+rail_gap])
    color("black")
    difference(){
        union(){
            cylinder(r=25.4/2, h=3.81);
            cylinder(r=12.7/2, h=19.05);
        }
        for(i=[1:3]){
            rotate([0,0,120*i])translate([19.05/2,0,-1])cylinder(r=3.56/2,h=3.81+2);
        }
        translate([0,0,-1])cylinder(r=4,h=19.05+2);
    }
}

module projector_throw(diff=false){
    case_dims = [264,220,85];
    lens_r = 52/2;
    translate([-area[0]/2+vat_loc[0],vat_loc[1],-area[1]/2+case_dims[2]-lens_r-10.5])
    color("violet", 0.2){
        x = area[0];
        y = area[1];
        optic_axis_length = area[0];
        inner = base_height + plate_thickness - area[0]/2*sin(45);
        left = optic_axis_length - inner;
        difference(){
            union(){
                if(diff) {
                    cube([x,y,base_height + plate_thickness+100]);
                }
                else {
                    cube([x,y,base_height + plate_thickness+1]);
                }
                translate([0,area[0]/2*sin(45),0])cube([x,left,y]);
            }
            translate([-1,y,0])rotate([135,0,0])cube([x+2,y*2,x*2]);
        }
    }
}

module acer_h6510bd(){
    case_dims = [264,220,85];
    lens_r = 52/2;
    asm_loc = [-case_dims[0]+31+lens_r, 100+vat_loc[1],0];
    translate(asm_loc)
    union(){
        // body
        color("white"){
            difference(){
            //case
                cube(case_dims);
                // lens cut
                translate([case_dims[0]-31-lens_r,-1,case_dims[2]-lens_r-10.5])rotate([-90,0,0])cylinder(r=lens_r, h=75+2);
                // focus cut
                z1 = lens_r*2;
                x1 = 49;
                translate([case_dims[0]-31-lens_r-49/2,16.5,case_dims[2]-lens_r-10.5])cube([49,35,z1]);
            }
        }
        // lens
        color("grey"){
            r1 = 49/2;
            translate([case_dims[0]-31-r1,9,case_dims[2]-r1-10.5])rotate([-90,0,0])cylinder(r=r1, h=75-9);
        }
    }
    projector_throw();
}

module stepper_subasm(diff=false){
    so = object(stepper_type);
    translate(stepper_loc)stepper(stepper_type,diff=diff,diff_length=20);
}

//http://www.file-vault.us/pdfs/hiwinguideway.pdf
module rail(length=200){
    translate([-15/2+10,-vat_stepper_gap,base_height+plate_thickness*2+rail_gap])
    rotate([0,0,0])
    steel(){
        linear_extrude(height=length){
            difference(){
                square([15,12.5]);
                translate([0,8])circle(r=2);
                translate([15,8])circle(r=2);
            }
        }
    }
}

module rambo_mini(diff=false){
    translate([-10,-90,foot_length+plate_thickness+1])
    rotate([0,0,30])
    color("green")
    difference(){
        cube([105,20,71]);
        if(diff){
        }
        else {
            polyCylinder(r=3, h=20);
        }
    }
}

module build_plate(){
    color("silver"){
        translate([-platform_size[0]/2,area[0]/2-platform_size[0]/2-vat_loc[1]/2,base_height+plate_thickness*2+foot_length])cube(platform_size);
    }
}


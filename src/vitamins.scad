module extrusion(z=extrusion_length, diff=false){
    translate([-10,-10,0])
    color("silver"){
        if(diff) {
            cube([10,10,z]);
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

module acme_nut(move_length=200-57,diff=false){
    translate([stepper_loc[0],stepper_loc[1],foot_length+plate_thickness*2+base_height+rail_gap+move_length*$t])
    rotate([0,180,0])
    color("black")
    if(!diff)
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
    else {
        union(){
            polyCylinder(r=25.4/2, h=3.81);
            polyCylinder(r=12.7/2, h=19.05);
            for(i=[1:3]){
                rotate([0,0,120*i])translate([19.05/2,0,-20])polyCylinder(r=1,h=70);
            }
            translate([0,0,-50])polyCylinder(r=12.7/2,h=100);
        }
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
    translate([-15/2,0,0])
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

module rail_car(move=200,diff=false){
    translate([-34/2,24-19.5,(move-57)*$t])
    color("green"){
        difference(){
            cube([34,19.5,57]);
            if(!diff)
                for(x_i=[0,26]) for(z_i=[0,26])
                    translate([4+x_i,20.5,15.5+z_i])rotate([90,0,0])cylinder(r=1.5, h=5);
        }
    }
}

module rail_subasm(length=200){
    rail(length=length);
    rail_car(move=length);
}

module power_supply(dims=[78,110,36]){
    translate([-base_radius,-base_radius+30,foot_length+plate_thickness])
    color("silver"){
        cube(dims);
    
    }
}


module rambo_mini(diff=false){
    translate([4,-89,foot_length+plate_thickness+72])
    rotate([-90,0,35])
    difference(){
        union(){
            color("green")cube([105,71,3]);
            color("silver")translate([105-13,26,3])cube([16,12,11]);
            color("black")translate([10,0,3])cube([40,71,21]);
            if(diff){
                translate([105-13,26,3])cube([30,12,11]);
                translate([100,14.87,7.2,])rotate([0,90,0])polyCylinder(r=3,h=30);
                for(x_i=[0,95]) for(y_i=[0,61])
                    translate([5+x_i,5+y_i,-10])polyCylinder(r=1, h=20);
            }
        }
        if(!diff)
            for(x_i=[0,95]) for(y_i=[0,61])
                translate([5+x_i,5+y_i,-1])cylinder(r=2, h=5);
    }
}

module fan_diff(){
    union(){
        cylinder(r=25, h = 50,center=true);
        for(i=[0:3])
            rotate([0,0,90*i])translate([20,20,0])polyCylinder(r=1, h=50,center=true);
    }
}

module build_plate(){
    color("silver"){
        translate([-platform_size[0]/2,-platform_size[1]/2,0])cube(platform_size);
    }
}


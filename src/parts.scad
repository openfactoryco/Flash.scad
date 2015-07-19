
module base_posts(distance, angs, radius, shift, height, screw_depth=10, screw_radius=1,wall=4,diff=false){
    $fn = 20;
    for(ang=angs){
    rotate([0,0,ang])
        if(diff){
            translate([distance-radius-shift,0,-11])polyCylinder(r=3,h=8);
            translate([distance-radius-shift,0,-11])polyCylinder(r=2,h=12);
            translate([distance-radius-shift,0,height+3])polyCylinder(r=3,h=8);
            translate([distance-radius-shift,0,height-1])polyCylinder(r=2,h=12);
        }
        else {
            difference(){
                union(){
                    hull(){
                        translate([distance-radius-shift,0,0])cylinder(r=radius,h=screw_depth);
                        translate([distance-radius,0,0])cylinder(r=radius,h=screw_depth);
                        translate([distance-wall/2,0,screw_depth*2])cylinder(r=wall/2,h=1);
                    }
                    hull(){
                        translate([distance-radius-shift,0,height-screw_depth])cylinder(r=radius,h=screw_depth);
                        translate([distance-radius,0,height-screw_depth])cylinder(r=radius,h=screw_depth);
                        translate([distance-wall/2,0,height-screw_depth*2])cylinder(r=wall/2,h=1);
                    }
                }
                translate([distance-radius-shift,0,-1])polyCylinder(r=screw_radius,h=screw_depth+1);
                translate([distance-radius-shift,0,height-screw_depth])polyCylinder(r=screw_radius,h=screw_depth+1);
            }
        }
    }
}


module base(wall=4,diff=false){
    $fn = 200;
    difference(){
        translate([0,0,plate_thickness+foot_length])
        color("blue")
        union(){
            if(diff){
                base_posts(base_radius, [140,170,210,240,270,300,330], 4,2, height=base_height,diff=true);
            }
            else {
                cutTube(inner=base_radius-wall,outer=base_radius,h=base_height,start=-15,finish=130,round=true);
                base_posts(base_radius, [140,170,210,240,270,300,330], 4,2, base_height,diff=false);
                //electronics mounts
                hull(){
                    translate([4,-89,base_height])
                        rotate([-90,0,35])
                            translate([0,0,-3])
                            cube([10,base_height,1]);
                    rotate([0,0,-90])translate([base_radius-wall,0,0])cube([wall,0.001,base_height]);
                    rotate([0,0,-80])translate([base_radius-wall,0,0])cube([wall,0.001,base_height]);
                }
                hull(){
                    translate([4,-89,base_height])
                        rotate([-90,0,35])
                            translate([95,0,-3])
                            cube([10,base_height,1]);
                    rotate([0,0,-20])translate([base_radius-wall,0,0])cube([wall,0.001,base_height]);
                    rotate([0,0,-30])translate([base_radius-wall,0,0])cube([wall,0.001,base_height]);
                }
            }
        }
        rambo_mini(true);
    }
}

module base_side(diff=false){
    $fn = 200;
    r=4;
    post_radius = 4;
    post_shift = 2;
    difference(){
        translate([0,0,plate_thickness+foot_length])
        color("blue"){
            if(diff){
                base_posts(base_radius, [10,40], 4,2, base_height,diff=true);
            }
            else{
                cutTube(inner=base_radius-r,outer=base_radius,h=base_height,start=50,finish=360,round=true);
                hull(){
                    rotate([0,0,0])translate([base_radius-r/2,0,0])cylinder(r=r/2,h=base_height);
                    rotate([0,0,-8])translate([base_radius-15,0,0])cylinder(r=r/2,h=base_height);
                }
                hull(){
                    rotate([0,0,-8])translate([base_radius-15,0,0])cylinder(r=r/2,h=base_height);
                    rotate([0,0,-14])translate([base_radius-5,0,0])cylinder(r=r/2,h=base_height);
                }
                base_posts(base_radius, [10,40], 4,2, base_height,diff=false);
            }
        }
        rambo_mini(true);
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
            base_side(diff=true);
            base(diff=true);
        }
    }
}

module bottom_plate(){
    asm_loc = [0,0,foot_length];
    $fn = 500;
    color("black")
    difference(){
        union(){
            translate(asm_loc)
                hull()cutTube(inner=base_radius-5,outer=base_radius,h=plate_thickness,start=50,finish=130,round=true);
            
        }
        base_side(diff=true);
        base(diff=true);
    }
}

module platform_attachment(h=3,r=5,sphere_r=11){
    color("gray")
    difference(){
        union(){
            hull(){
                translate([platform_size[0]/2-r,platform_size[1]/2-r,0])
                    cylinder(r=5,h=h);
                translate([-platform_size[0]/2+r,platform_size[1]/2-r,0])
                    cylinder(r=5,h=h);
                translate([-platform_size[0]/2+r,-platform_size[1]/2+r,0])
                    cylinder(r=5,h=h);
                translate([platform_size[0]/2-r,-platform_size[1]/2+r,0])
                    cylinder(r=5,h=h);
                translate([0,0,h])
                    cylinder(r1=platform_size[1]/2,r2=0,h=h);
            }
            translate([0,0,sphere_r])sphere(r=sphere_r);
        }
    }
}


module amber_lid(){
    asm_loc = [0,0,base_height+plate_thickness*2+foot_length];
    $fn = 200;
    color("DarkOrange", 0.5){
        translate(asm_loc)difference(){
            cylinder(r=base_radius, h=lid_height);
            r1 = base_radius - lid_thickness;
            h1 = base_height - lid_thickness;
            translate([0,0,-1])cylinder(r=r1, h=h1+2);
        }
    }
}

module vat_lower(r=5,size=area,wall=[25,15],tension_height=5, window_r=2,h=10){
    color("orange"){
        difference(){
            union(){
                minkowski(){
                    translate([r,r,0])cube([area[0]+wall[0]*2-r*2,area[1]+wall[1]*2-r*2,h-1]);
                    cylinder(r=r, h=1);
                }
                minkowski(){
                    hull(){
                        translate([wall[0]-2,wall[1]-2,h-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                        translate([wall[0]-2,wall[1]+2+area[1],h-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                        translate([wall[0]+2+area[0],wall[1]-2,h-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                        translate([wall[0]+2+area[0],wall[1]+2+area[1],h-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                    }
                    sphere(r=2,$fn=20);
                }
            }
            minkowski(){
                translate([wall[0],wall[1],0])cube([area[0],area[1],h]);
                translate([0,0,-0.5])cylinder(r=2,h=10);
            }
        }
    }
}

module extrusion_cap(){
    translate([12.5,-10,10])
    rotate([0,180,0])
    color("orange")
    difference(){
        union(){
            cube([25,40,10]);
        }
        translate([12.5,10,-1])polyCylinder(r=2.5,h=12);
        translate([12.5,10,-1])polyCylinder(r=4.5,h=7);
        translate([7.5,41,5])rotate([90,0,0])polyCylinder(r=1,h=12);
        translate([25-7.5,41,5])rotate([90,0,0])polyCylinder(r=1,h=12);
    }
}

module extrusion_guard(){
    module guard_half(){
        translate([9,1,0])cube([3,2,rail_gap]);
        translate([11,1,0])cube([2,18,rail_gap]);
        translate([0,10,0])cube([12,9,rail_gap]);
    }
    color("orange"){
        mirror([1,0,0])guard_half();
        guard_half();
    }
}

module vat_subasm(){
    translate([0,area[0]/2-vat_loc[0],0])
    translate([-area[0]/2-25,-area[1]/2-15,foot_length+plate_thickness*2+base_height]){
        vat_lower();
    }
}

module extrusion_subasm(){
    translate([0,-vat_stepper_gap,foot_length+plate_thickness]){
        translate([0,0,extrusion_length])extrusion_cap();
        extrusion();
        translate([0,10,base_height+plate_thickness+rail_gap])
            rail_subasm();
        translate([0,0,plate_thickness+base_height])extrusion_guard();
    }
    acme_nut();
}

module build_tray_subasm(){
    translate([0,0,foot_length+plate_thickness*2+base_height]){
        translate([0,0,platform_size[2]])platform_attachment();
        build_plate();
    }
}

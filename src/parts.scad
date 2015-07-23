
module base_posts(distance, angs, radius, shift, height, screw_depth=10, screw_radius=1,wall=4,diff=false){
    $fn = 20;
    for(ang=angs){
    rotate([0,0,ang])
        if(diff){
            translate([distance-radius-shift,0,-11])polyCylinder(r=3,h=8);
            translate([distance-radius-shift,0,-11])polyCylinder(r=2,h=12);
            translate([distance-radius-shift,0,height+3])polyCylinder(r=3,h=20);
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
    $fn = 100;
    difference(){
        translate([0,0,plate_thickness+foot_length])
        color("blue")
        union(){
            if(diff){
                base_posts(base_radius, [140,170,210,240,270,300,330], 4,2, height=base_height,diff=true);
            }
            else {
                cutTube(inner=base_radius-wall,outer=base_radius,h=base_height,start=-15,finish=115,round=true);
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
    $fn =  100;
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
                cutTube(inner=base_radius-r,outer=base_radius,h=base_height,start=65,finish=360,round=true);
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


module top_plate(vat_wall=[12,12]){
    wall = 5;
    asm_loc = [0,0,base_height+foot_length+plate_thickness];
    $fn = 100;

    color("grey"){
        difference(){
            translate(asm_loc)
            difference(){
                union(){
                    hull(){
                        hull()
                            cutTube(inner=base_radius-5,outer=base_radius,h=plate_thickness,start=65,finish=115,round=true);
                        translate([0,0,plate_thickness-1])
                            cylinder(r=base_radius, h=1);
                    }
                    minkowski(){
                        difference(){
                            translate([0,0,plate_thickness])cylinder(r1=base_radius-lid_thickness-3,
                                     r2=base_radius-lid_thickness*2-3,
                                     h=lid_thickness);
                             translate([0,0,plate_thickness-1])
                                cylinder(r=base_radius-lid_thickness*2-3,
                                         h=lid_thickness+2);
                             }
                         sphere(r=3, $fn=10);
                     }
                }
                translate([40,-40,0])rotate([0,0,0])fan_diff();
                translate([-area[0]/2-vat_wall[0],-vat_wall[1],plate_thickness])cube([area[0]+vat_wall[0]*2,area[1]+vat_wall[1]*2,10]);
                minkowski(){
                    translate([-area[0]/2,0,-1])
                        cube([area[0],area[1],10]);
                    cylinder(r=2, h=2);
                }
                //extrusion
                translate([-10,-20-24,-1])cube([20,20,plate_thickness+2]);
            }
            stepper_subasm(diff=true);
            base_side(diff=true);
            base(diff=true);
        }
    }
}

module bottom_plate(){
    asm_loc = [0,0,foot_length];
    $fn = 500;
    color("grey")
    difference(){
        union(){
            translate(asm_loc)
                hull()cutTube(inner=base_radius-5,outer=base_radius,h=plate_thickness,start=65,finish=115,round=true);
            
        }
        base_side(diff=true);
        base(diff=true);
    }
}

module platform_attachment(h=3.5,r=5,sphere_r=11){
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
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*platform_size[0]/2-i*r-i*5,j*platform_size[1]/2-j*r-j*5,-1]){
                polyCylinder(r=1.5,h=h+2);
                translate([0,0,4])
                    polyCylinder(r=3,h=h+2);
                }
    }
}


module amber_lid(){
    asm_loc = [0,0,base_height+plate_thickness*2+foot_length];
    $fn = 200;
    color("DarkOrange", 0.5){
        translate(asm_loc)
        difference(){
            cylinder(r=base_radius, h=lid_height);
            r1 = base_radius - lid_thickness;
            h1 = base_height - lid_thickness;
            translate([0,0,-1])cylinder(r=r1, h=h1+2);
        }
    }
}

module vat_lower(r=5,size=area,wall=[15,15],tension_height=5, window_r=2,h=7){
    translate([-area[0]/2-wall[0],-area[1]/2-wall[1],0])
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
            for(i=[0:5])translate([wall[0]/2-1+(area[0]+wall[0]+2)*i/5,0,0]){
                translate([0,wall[1]/2-1,-1])
                    polyCylinder(r=1,h=h+2);
                translate([0,wall[1]*3/2+area[1]+1,-1])
                    polyCylinder(r=1,h=h+2);
            }
            for(i=[0:4])translate([0,wall[1]/2-1+(area[1]+wall[1]+2)*i/4,0]){
                translate([wall[0]/2-1,0,-1])
                    polyCylinder(r=1,h=h+2);
                translate([wall[0]*3/2+area[0]+1,0,-1])
                    polyCylinder(r=1,h=h+2);
            }
        }
    }
}

module vat_upper(r=5,size=area,wall=[15,10],tension_height=5, window_r=2,h=17){
    translate([-area[0]/2-wall[0],-area[1]/2-wall[1],0])
    color("orange"){
        difference(){
            union(){
                hull(){
                    minkowski(){
                        translate([r,r,0])cube([area[0]+wall[0]*2-r*2,area[1]+wall[1]*2-r*2,h/5-1]);
                        cylinder(r=r, h=1);
                    }
                    translate([wall[0]-2,wall[1]-2,h-1])cylinder(r=3,h=1);
                    translate([wall[0]-2,wall[1]+2+area[1],h-1])cylinder(r=3,h=1);
                    translate([wall[0]+2+area[0],wall[1]-2,h-1])cylinder(r=3,h=1);
                    translate([wall[0]+2+area[0],wall[1]+2+area[1],h-1])cylinder(r=3,h=1);
                }
            }
            minkowski(){
                translate([wall[0],wall[1],0])cube([area[0],area[1],h]);
                translate([0,0,-0.5])cylinder(r=2,h=10);
            }
            minkowski(){
                hull(){
                    translate([wall[0]-2,wall[1]-2,-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                    translate([wall[0]-2,wall[1]+2+area[1],-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                    translate([wall[0]+2+area[0],wall[1]-2,-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                    translate([wall[0]+2+area[0],wall[1]+2+area[1],-2])cylinder(r1=tension_height-2,r2=0,h=tension_height-2);
                }
                sphere(r=2,$fn=20);
            }
            for(i=[0:5])translate([wall[0]/2-1+(area[0]+wall[0]+2)*i/5,0,0]){
                translate([0,wall[1]/2-1,0]){
                    translate([0,0,3])polyCylinder(r=3,h=h);
                    translate([0,0,-1])polyCylinder(r=1.5,h=h);
                }
                translate([0,wall[1]*3/2+area[1]+1,0]){
                    translate([0,0,3])polyCylinder(r=3,h=h);
                    translate([0,0,-1])polyCylinder(r=1.5,h=h);
                }
            }
            for(i=[0:4])translate([0,wall[1]/2-1+(area[1]+wall[1]+2)*i/4,0]){
                translate([wall[0]/2-1,0,0]){
                    translate([0,0,3])polyCylinder(r=3,h=h);
                    translate([0,0,-1])polyCylinder(r=1.5,h=h);
                }
                translate([wall[0]*3/2+area[0]+1,0,0]){
                    translate([0,0,3])polyCylinder(r=3,h=h);
                    translate([0,0,-1])polyCylinder(r=1.5,h=h);
                }
            }
        }
    }
}

module extrusion_cap(){
    translate([12.5,-10,15])
    rotate([0,180,0])
    color("orange")
    difference(){
        union(){
            cube([25,40,15]);
        }
        translate([12.5,10,-1])polyCylinder(r=2.5,h=15);
        translate([12.5,10,-1])polyCylinder(r=4.5,h=7);
        translate([7.5,41,7])rotate([90,0,0])polyCylinder(r=1,h=12);
        translate([25-7.5,41,7])rotate([90,0,0])polyCylinder(r=1,h=12);
    }
}

module extrusion_guard(){
    module guard_half(){
        translate([9,1,0])cube([3,2,rail_gap]);
        translate([10.5,1,0])cube([1.5,18,rail_gap]);
        translate([0,10,0])cube([12,12,rail_gap]);
        translate([0,10,rail_gap-2])cube([12,25,2]);
    }
    color("orange"){
        mirror([1,0,0])guard_half();
        guard_half();
    }
}

module z_shoe(sphere_r=11){
    gap = area[1]/2-15;
    split = 4;
    split_height = 20;
    translate([-34/2,-gap,0])
    color("grey"){
        difference(){
            union(){
                difference(){
                    union(){
                        hull(){
                            translate([0,0,0])cube([34,gap-3,57]);
                            translate([34/2,gap,0])cylinder(r=area[1]/2-15,h=57);
                        }
                        translate([-4+34/2,0,15.5+32])rotate([-90,0,0])cylinder(r=8, h=gap*2);
                        hull(){
                            translate([34/2,0,20])rotate([-90,0,0])cylinder(r=8, h=gap*2);
                            translate([6,0,13])rotate([-90,0,0])cylinder(r=6, h=gap*2);
                            translate([34-6,0,13])rotate([-90,0,0])cylinder(r=6, h=gap*2);
                        }
                    }
                    translate([-1,gap-split/2,-1])cube([36,split,split_height]);
                    translate([34/2,gap,-rail_gap+10+platform_size[2]+sphere_r])sphere(r=sphere_r+0.1);
                }
            }
            translate([34/2,-1,20])rotate([-90,0,0])polyCylinder(r=2, h=gap*2+2);
            translate([-4+34/2,-1,15.5+32])rotate([-90,0,0])polyCylinder(r=2, h=gap*2+2);
            translate([6,-1,13])rotate([-90,0,0])polyCylinder(r=2, h=gap*2+2);
            translate([34-6,-1,13])rotate([-90,0,0])polyCylinder(r=2, h=gap*2+2);
            translate([6,-1,13])rotate([-90,0,0])cylinder(r=4, h=6, $fn=6);
            translate([34-6,-1,13])rotate([-90,0,0])cylinder(r=4, h=6, $fn=6);
        }
    }
}

module z_arm(){
    difference(){
        translate([0,0,foot_length+plate_thickness*2+base_height+rail_gap+(200-57)*$t])
        color("orange")
        difference(){
            union(){
                hull(){
                    translate([stepper_loc[0],stepper_loc[1],0])cylinder(r=13, h=20);
                    translate([-34/2-20,0,0])cube([20,10,57]);
                }
                hull(){
                    translate([-34/2,0,0])cube([34,15,57]);
                    translate([-34/2-20,0,0])cube([20,10,57]);
                }
            }
            for(x_i=[0,26]) for(z_i=[0,26]){
                translate([4+x_i-34/2,11,15.5+z_i])rotate([90,0,0])cylinder(r=2, h=16);
                translate([4+x_i-34/2,3,15.5+z_i])rotate([-90,0,0])cylinder(r=3.75, h=13);
            }
            translate([0,-1,20])rotate([-90,0,0])cylinder(r=2, h=17);
            translate([-4,-1,15.5+32])rotate([-90,0,0])cylinder(r=2, h=17);
            translate([0,-1,20])rotate([-90,0,0])cylinder(r=4, h=4.5, $fn=6);
            translate([-4,-1,15.5+32])rotate([-90,0,0])cylinder(r=4, h=4.5,$fn=6);
        }
        acme_nut(diff=true);
    }
}


module vat_subasm(wall=[12,12],lower_h=7,upper_h=20){
    translate([0,area[1]/2-vat_loc[1],foot_length+plate_thickness*2+base_height])
    union()
    {
        vat_lower(wall=wall,h=lower_h);
        translate([0,0,lower_h])vat_upper(wall=wall,h=rail_gap-2-lower_h);
    }
}

module extrusion_subasm(){
    translate([0,-34,foot_length+plate_thickness]){
        translate([0,0,extrusion_length])extrusion_cap();
        extrusion();
        translate([0,10,base_height+plate_thickness+rail_gap])
            rail_subasm();
        translate([0,0,plate_thickness+base_height])extrusion_guard();
    }
    acme_nut();
    z_arm();
}

module build_tray_subasm(){
    translate([0,area[1]/2,foot_length+plate_thickness*2+base_height+10+(200-57)*$t]){
        translate([0,0,platform_size[2]])platform_attachment();
        build_plate();
        translate([0,0,rail_gap-10])z_shoe();
    }
}

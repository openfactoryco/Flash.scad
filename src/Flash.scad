//Config

area = [60,80];


base_radius = 4*25.4;
base_height = 100;

plate_thickness = 8;

lid_height = 9*25.4;
lid_thickness = 3;

phi = 1.618033988;

module base(){
$fn = 500;
color("blue"){
    d = base_radius*2;
    difference(){
        cylinder(r=base_radius, h=base_height);
        translate([0,0,-1])cylinder(r=base_radius-5, h=base_height+2);
        translate([-d/2,d-d/phi,-1])cube([d,d/2,base_height+2]);
    }
}
}

module top_plate(){
wall = 5;
asm_loc = [0,0,base_height];
$fn = 500;

translate(asm_loc)
color("black"){
    cylinder(r=base_radius, h=plate_thickness);
}

}

module bottom_plate(){
asm_loc = [0,0,-plate_thickness];
$fn = 500;
translate(asm_loc)
color("black"){
    cylinder(r=base_radius, h=plate_thickness);
}
}

module projector_throw(bevel=true){
color("violet", 0.5){
    r = 10;
    x = area[0]-r*2;
    y = area[1]-r*2;
    minkowski(){
    hull(){
        rotate([0,45,90])translate([0,-area[1]/2,0])cube([x,y,x]);
        translate([0,0,100])rotate([0,45,90])translate([0,-area[1]/2,0])cube([x,y,x]);
    }
    if(bevel){
        sphere(r=r/2);
    }
    }
}
}

module amber_lid(){
asm_loc = [0,0,base_height+plate_thickness];
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



module assembly(){
    base();
    top_plate();
    bottom_plate();
    translate([0,0,50])projector_throw();
    amber_lid(); // put at end so transparency works.
}

assembly();

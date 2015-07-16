// includes
include <Magpie/magpie.scad>; // https://github.com/sjkelly/Magpie/blob/master/docs/tutorial.md
include <vitamins.scad>
include <parts.scad>

/*
TODO

- mirror mount
- parameterize base height
- fan mount
- vat
- z arm
- z shoe
- build plate
- rambo mini
- extrusion cap
- extrusion guard (integrate with top plate)
- electronics bottom mount

*/
//Config
area = [60*16/9,60];

platform_size = [3*25.4, 45,0.5*25.4];

foot_length = 5;

base_radius = 4*25.4;
base_height = 75;

plate_thickness = 8;

lid_height = 255;
lid_thickness = 3;

rail_gap = 30;

vat_loc = [0,5];

extrusion_length = 320;

phi = 1.618033988;

// from base
movement = [5,200];

stepper_type = "NEMA17_TR8X8_210mm";
vat_stepper_gap = 20-vat_loc[1];
stepper_obj = object(stepper_type);
stepper_loc = [-stepper_obj[WIDTH]/2,-stepper_obj[WIDTH]/2-vat_stepper_gap,base_height-stepper_obj[LENGTH]+plate_thickness+foot_length];

extrusion_stepper_gap = stepper_obj[WIDTH] + 20;

module assembly(){
    electronics_cover();
    base();
    base_side();
    //top_plate();
    bottom_plate();
    extrusion();
    acer_h6510bd();
    stepper_subasm();
    translate([0,0,0])acme_nut();
    rail();
    rambo_mini();
    vat_lower();
    build_plate();
    amber_lid(); // put at end so transparency works.
}

assembly();

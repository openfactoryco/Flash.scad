// includes
include <Magpie/magpie.scad>; // https://github.com/sjkelly/Magpie/blob/master/docs/tutorial.md
include <vitamins.scad>
include <parts.scad>

/*
TODO

- mirror mount - 1
- extrusion mount - 1
TCB
*/

//Config
area = [60*16/9,60];

platform_size = [3*25.4, 45,0.5*25.4];

mirror_size = [90,50,6];

foot_length = 5;

base_radius = 4*25.4;
base_height = 75;

plate_thickness = 8;

lid_height = 255;
lid_thickness = 3;

//24mm bottom to top of car
rail_gap = 30;

vat_loc = [0,0];

extrusion_length = base_height+plate_thickness+rail_gap+200;


phi = 1.618033988;

// from base
movement = [5,200];

stepper_type = "NEMA17_TR8X8_210mm";
vat_stepper_gap = 20;
stepper_obj = object(stepper_type);
stepper_loc = [-stepper_obj[WIDTH]/2-10,-34,base_height-stepper_obj[LENGTH]+plate_thickness+foot_length];

module assembly(){
    top_plate();
    translate([0,0,0.1])bottom_plate();
    base();
    base_side();
    extrusion_subasm();
    vat_subasm();
    acer_h6510bd();
    stepper_subasm();
    rambo_mini();
    build_tray_subasm();
    amber_lid(); // put at end so transparency works.
}

assembly();
//z_arm();
//vat_subasm();
//base_side();
//base();
//rambo_mini();
//rail_subasm();
//extrusion_subasm();
//vat_subasm();
//build_tray_subasm();

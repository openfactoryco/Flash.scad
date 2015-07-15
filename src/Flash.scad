//Config
area = [60,80];


base_radius = 4*25.4;
base_height = 100;

plate_thickness = 8;

lid_height = 9*25.4;
lid_thickness = 3;

phi = 1.618033988;


// includes
include <Magpie/magpie.scad>; // https://github.com/sjkelly/Magpie/blob/master/docs/tutorial.md
include <vitamins.scad>
include <parts.scad>

module assembly(){
    base();
    top_plate();
    bottom_plate();
    translate([0,0,50])projector_throw();
    #extrusion();
    amber_lid(); // put at end so transparency works.
}

assembly();

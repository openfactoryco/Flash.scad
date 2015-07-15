
module extrusion(x=20, y=60, z=300, diff=false){
    asm_rot = [0,0,90];
    asm_loc = [-base_radius/3,-y/2,0];
    rotate(asm_rot)
    translate(asm_loc)
    color("silver"){
        if(diff) {
            cube([x,y,z]);
        }
        else {
            cube([x,y,z]);
        }
    }
}

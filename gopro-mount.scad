// GoPro mount adapter for generic Garmin handlebar mount.
// This adapter should be epoxied under the Garmin mount with a snug fit.
// Jason Thrasher 10/15/2017

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

module cubecase() {
    //dimensions in mm
    CUBE_FRAME_WIDTH = 40.64; //mm
    CUBE_FRAME_HEIGHT = 40.64; //mm
    CUBE_FRAME_HOLE_Z = 19.06; //mm
    CUBE_FRAME_HOLE_H = 7.93; //mm
    rotate([90])
    translate([-CUBE_FRAME_WIDTH/2,-CUBE_FRAME_HOLE_H,-CUBE_FRAME_HOLE_Z])
    import("Polaroid_Cube_Case_Crea3D-blank.stl");
}

BEVEL = 2.5;
GARMIN_INNER_DIA = 29.1; // mm 28 was too small
GARMIN_OUTER_DIA = GARMIN_INNER_DIA + BEVEL*2;
GARMIN_THICKNESS = 4+BEVEL; // mm

GOPRO_FIN_C = 3.2; // 3.2 actual, but prints at 3.35
GOPRO_FIN_DIA = 15.0 - 0.15; // 15.0 actual, but prints .15 too large

HINGE_TOLORANCE = 5.2; // 1.2 is minimum
CENTER_FIN_WIDTH = 3.2 - 0.15; // 3.2 actual, but prints at 3.35
CUT_WIDTH = 3.05 + .3;

GARMIN_SETBACK = GARMIN_INNER_DIA/2 + 10;
GARMIN_DROP = GOPRO_FIN_DIA/2+0;
// hexagonal bolt hole
HEX_THICKNESS = 3;
HEX_DIM = 8.4; // actual 7.82, but 8.3 and too small

module hexagon(length, depth = 2) {
    width = 2 * length * tan(30);
    union() {
        cube(size = [ length * 2, width, depth ], center = true);
        rotate(a = [ 0, 0, 60 ]) {
            cube(size = [ length * 2, width, depth ], center = true);
        }
        rotate(a = [ 0, 0, -60 ]) {
            cube(size = [ length * 2, width, depth ], center = true);
        }
    }
}
module bevelshim() {
    color(1,0,0)
        difference(){
            cylinder(d=GARMIN_OUTER_DIA, h=BEVEL);
            translate([-50, GOPRO_FIN_DIA/2, -50])
            cube([100, GOPRO_FIN_DIA, 100], center=false);
            rotate([180,0,0])
            translate([-50, GOPRO_FIN_DIA/2, -50])
            cube([100, GOPRO_FIN_DIA, 100], center=false);
            translate([50, 0, 0])
            cube([100, 100, 100], center=true);
        }
}

module goprofins() {
    
    difference() {
        group() {
            hull(){
                cylinder(d=GOPRO_FIN_DIA, h=GOPRO_FIN_DIA, center=true);
                translate([GARMIN_DROP+15,GARMIN_SETBACK,0])
                cube([0.01, GARMIN_INNER_DIA*.8, GOPRO_FIN_DIA], center=true);
            }
        }
        
        // cut hole
        translate([0,0,-GOPRO_FIN_DIA])
        cylinder(d=5.6, h=GOPRO_FIN_DIA*2, center=false);
        
        // cut fins
        rotate([0,0,atan2(GARMIN_SETBACK,GARMIN_DROP)]) {
            translate([0, 0, CENTER_FIN_WIDTH+(CUT_WIDTH-CENTER_FIN_WIDTH)/2]) //3.0
            cube([GOPRO_FIN_DIA * HINGE_TOLORANCE, GOPRO_FIN_DIA * HINGE_TOLORANCE, CUT_WIDTH], center=true);
            
            rotate([0,180,0])
            translate([0, 0, CENTER_FIN_WIDTH+(CUT_WIDTH-CENTER_FIN_WIDTH)/2]) //3.0
            cube([GOPRO_FIN_DIA * HINGE_TOLORANCE, GOPRO_FIN_DIA * HINGE_TOLORANCE, CUT_WIDTH], center=true);
        }
    }
    
    rotate([0,180,0])
    difference() {
        hull() {
            translate([0,0,GOPRO_FIN_DIA/2])
            cylinder(d=GOPRO_FIN_DIA, h=.001);
            translate([0,0,GOPRO_FIN_DIA/2])
            cylinder(d=11, h=HEX_THICKNESS);
        }
        translate([0,0,GOPRO_FIN_DIA/2+HEX_THICKNESS/2])
        hexagon(HEX_DIM/2, HEX_THICKNESS+1);
    }
}

rotate([0,90,0]) goprofins();
//cubecase();


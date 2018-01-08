// Aerobar bridge
// dimensions in inches

 use <NACA_Airfoil_lib/shortcuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <NACA_Airfoil_lib/naca4.scad>

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

AEROBAR_DIA = 7/8; // tube dia
AEROBAR_WIDTH_C2C = 4.02; // center to center of bars
CLIP_DIA = AEROBAR_DIA + 0.25;
BRIDGE_LENGTH = 2;
WING_RADIUS = (AEROBAR_WIDTH_C2C/2) + 0.21;

ZIP_HEIGHT = .1; // ziptie hole height
ZIP_WIDTH = .2; // ziptie hole width

GARMIN_DIA = 1.4; // garmin-issue mount with band hooks removed
GARMIN_TH = 0.2; // thickness of garmin-issue mount

module aerobars() {
    LENGTH = 4;
    cylinder(d=AEROBAR_DIA, h=LENGTH);
    translate([AEROBAR_WIDTH_C2C, 0, 0]) cylinder(d=AEROBAR_DIA, h=LENGTH);
}

module clip() {
    difference()
    {
        cylinder(d=CLIP_DIA, h=BRIDGE_LENGTH);
        //cylinder(d=AEROBAR_DIA, h=BRIDGE_LENGTH);
        translate([0, CLIP_DIA/2, BRIDGE_LENGTH/2]) cube([BRIDGE_LENGTH,CLIP_DIA,BRIDGE_LENGTH*2], center=true);
    }
}

module clips() {
    rotate([0,0,0]) clip();
    translate([AEROBAR_WIDTH_C2C, 0, 0])
    rotate([0,0,0]) clip();
}
module wing() {
    translate([(AEROBAR_WIDTH_C2C)/2, .001, BRIDGE_LENGTH-3])
    rotate([0,0,180])
    rotate_extrude(angle = 180, convexity = 10)
    translate([WING_RADIUS, 3, 0])
    R(0, -180, 90)
    polygon(points = airfoil_data([0.0, 0.0, 0.3], L=BRIDGE_LENGTH + 0.3));    
    clips();
}
module ziptie() {
    rotate_extrude(angle = 360, convexity = 2) {
        translate([CLIP_DIA/2, BRIDGE_LENGTH - ZIP_WIDTH - ZIP_WIDTH, 0])
        square(size = [ZIP_HEIGHT,ZIP_WIDTH], center = false);
    }
    rotate_extrude(angle = 360, convexity = 2) {
        translate([CLIP_DIA/2, ZIP_WIDTH, 0])
        square(size = [ZIP_HEIGHT,ZIP_WIDTH], center = false);
    }
}
module zipties() {
    ziptie();
    translate([AEROBAR_WIDTH_C2C, 0, 0])
    ziptie();
}
module bridge() {
    color([1,1,1]) difference() {
        wing();
        translate([0,0,-1]) aerobars();
        zipties();
        translate([-1, -3, -1]) cube([6,3,1]);
    }
}

module beam() {
    ADAPTER_DIA = 31.8 / 25.4;
    LEN = 4.2;
    dia = .58;
    hull() {
        translate([-KEDGE_INSERT_DIA/2,0,0]) cylinder(d=dia, h=LEN);
        translate([KEDGE_INSERT_DIA/2,0,0]) cylinder(d=dia, h=LEN);
    }
}
module beam_round() {
    difference() {
        rotate([180,0,0])
        translate([AEROBAR_WIDTH_C2C/2, WING_RADIUS-.05, -1.25]) beam();
translate([AEROBAR_WIDTH_C2C/2,-WING_RADIUS+.3,-2.2])
rotate([90,0,0]) kedge_insert();    }
}
beam_round();
bridge();
KEDGE_INSERT_DIA = 1.325;
module kedge_insert() {
    btw_screws = 0.79;
    cylinder(d=KEDGE_INSERT_DIA, h=.2);
    translate([0,btw_screws/2,-.2]) cylinder(d=.1, h=.2);
    translate([0,-btw_screws/2,-.2]) cylinder(d=.1, h=.2);
    
    translate([0,0,.2]) cylinder(r1=1.2, r2=1.63, h=.71);
}

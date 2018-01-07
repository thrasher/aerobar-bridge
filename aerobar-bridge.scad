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
    difference() {
        cylinder(d=CLIP_DIA, h=BRIDGE_LENGTH);
        cylinder(d=AEROBAR_DIA, h=BRIDGE_LENGTH);
        translate([0, CLIP_DIA/2, BRIDGE_LENGTH/2]) cube([BRIDGE_LENGTH,CLIP_DIA,BRIDGE_LENGTH], center=true);
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
        aerobars();
        zipties();
        translate([-1, -3, -1]) cube([6,3,1]);
    }
}

    ARM_HT=.5;
GRMN_CENTER_SETBACK = 1.7 + 1;
module garmin() {
    //cube([.5, ARM_HT, 3], center=true);
    rotate([0,90,0]) {
        hull() {
            translate([1.7,.1,0]) cylinder(d = .1, h=GARMIN_TH + GARMIN_DIA, center=true);
            translate([-0.8,0,0]) cylinder(d = .5, h=GARMIN_TH + GARMIN_DIA, center=true);
        }
    }
    difference() {
        hull() {
            translate([0,ARM_HT/2,.5]) rotate([90,0,0])
            cylinder(d=GARMIN_TH + GARMIN_DIA, h=GARMIN_TH);
            translate([0,ARM_HT/2,-GRMN_CENTER_SETBACK]) rotate([90,0,0])
            cylinder(d=GARMIN_TH + GARMIN_DIA, h=GARMIN_TH);
        }
        translate([0,ARM_HT/2,-GRMN_CENTER_SETBACK]) rotate([90,0,0])
        translate([0,0,-.5]) cylinder(d=GARMIN_DIA, h=GARMIN_TH+1);
    }

}
    GARMIN_MOUNT_HT=.12; // height of mating cylinder
module garmin_computer() {
    BASE_DIA = 0.9825;
    BASE_FACE= 1.3;//face of mating mount surface
    cylinder(d=BASE_DIA, h=GARMIN_MOUNT_HT);
    translate([0,0,GARMIN_MOUNT_HT]) cylinder(d=BASE_FACE, h=.1);
    translate([0,0,GARMIN_MOUNT_HT + .35]) cube([1.9,2.86,.7], center=true);
}
module beam_quarter_turn() {
difference() {
//translate([AEROBAR_WIDTH_C2C/2, -2.4+ARM_HT/2-GARMIN_MOUNT_HT, -GRMN_CENTER_SETBACK]) rotate([90,0,0]) garmin_computer();
translate([AEROBAR_WIDTH_C2C/2, -2.37, 0]) garmin();
    bridge();
}
}
module beam() {
    ADAPTER_DIA = 31.8 / 25.4;
    LEN = 4.2;
    dia = .5;
    hull() {
    translate([-.5,0,0]) cylinder(d=dia, h=LEN);
    translate([.5,0,0]) cylinder(d=dia, h=LEN);
    }
}
module beam_round() {
    difference() {
        rotate([180,0,0])
        translate([AEROBAR_WIDTH_C2C/2, WING_RADIUS, -0.9]) beam();
        bridge();
    }
}
beam_round();
bridge();

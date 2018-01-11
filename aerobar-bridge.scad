// Aerobar bridge
// dimensions in inches

 use <NACA_Airfoil_lib/shortcuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <NACA_Airfoil_lib/naca4.scad>
 use <gopro-mount.scad>

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

AEROBAR_DIA = 7/8; // tube dia
AEROBAR_WIDTH_C2C = 4.02; // center to center of bars
CLIP_THICKNESS = 0.125;
CLIP_DIA = AEROBAR_DIA + CLIP_THICKNESS*2;
BRIDGE_LENGTH = 2;
WING_RADIUS = (AEROBAR_WIDTH_C2C/2) + 0.21;

ZIP_HEIGHT = .1; // ziptie hole height
ZIP_WIDTH = .2; // ziptie hole width

GARMIN_DIA = 1.337 + 0.05; // 1.337 k-edge garmin adapter diameter
GARMIN_TH = 0.200 + 0.05; // 0.200 thickness of k-edge garmin thickness

module aerobars() {
    LENGTH = 4;
    cylinder(d=AEROBAR_DIA, h=LENGTH);
    translate([AEROBAR_WIDTH_C2C, 0, 0]) cylinder(d=AEROBAR_DIA, h=LENGTH);
}

module clip() {

    difference()
    {
        union() {
            translate([0,0,.1*2]) cylinder(d=CLIP_DIA, h=BRIDGE_LENGTH-.1*4);
            translate([0,0,BRIDGE_LENGTH- 2*.1])
            cylinder(d1=CLIP_DIA, d2=CLIP_DIA-CLIP_THICKNESS*1.8, h=.1*2);
            translate([0,0,0])
            cylinder(d2=CLIP_DIA, d1=CLIP_DIA-CLIP_THICKNESS*1.8, h=.1*2);
        }
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
    color([.9,0,0]) difference() {
        wing();
        translate([0,0,-1]) aerobars();
        zipties();
        translate([-1, -3, -1]) cube([6,3,1]);
    }
}

BAR_DIA = .56;
BAR_LEN = 4.5;
module beam() {
    hull() {
        translate([-GARMIN_DIA/2,0,0]) cylinder(d=BAR_DIA, h=BAR_LEN);
        translate([GARMIN_DIA/2,0,0]) cylinder(d=BAR_DIA, h=BAR_LEN);
    }
}

module kedge_insert() {
    btw_screws = 0.79;
    cylinder(d=GARMIN_DIA, h=GARMIN_TH);
    translate([0,btw_screws/2,-.5]) cylinder(d=.1, h=1);
    translate([0,-btw_screws/2,-.5]) cylinder(d=.1, h=1);
    
    // garmin unit rotating, device corner extents
    translate([0,0,GARMIN_TH]) cylinder(r1=1.2, r2=1.63, h=.71);
    
    translate([0,0,-1])
    difference() {
        cylinder(d=GARMIN_DIA*3, h=3);
        cylinder(d=BAR_DIA+GARMIN_DIA, h=4);
        translate([0,5,0]) cube([10,10,10], center=true);
    }
}

module beam_round() {
    difference() {
        rotate([180,0,0])
            translate([AEROBAR_WIDTH_C2C/2, WING_RADIUS-.059, -1.25])
            beam();
        translate([AEROBAR_WIDTH_C2C/2,-WING_RADIUS+.3,-2.2])
            rotate([90,0,0])
            kedge_insert();
    }
}

module body() {
    beam_round();
    bridge();
}

module battery() {
    // https://www.anker.com/products/variant/PowerCore%2B-Mini-3350/A11040B1
    BATT_LEN = 3.75; // 3.727
    BATT_DIA = 0.92; // 0.909
    color([.5,.5,.5])
    translate([AEROBAR_WIDTH_C2C/2,-WING_RADIUS+.8,-2.5])
    cylinder(d = BATT_DIA, h = BATT_LEN);
}

module gopro() {
    translate([AEROBAR_WIDTH_C2C/2,-1.2,2.4])
    rotate([270,0,0]) rotate([0,90,0])
    scale(1/25.4)
    goprofins();
}

module slice() {
    translate([AEROBAR_WIDTH_C2C/2,-2,-.501]) rotate([0,90,0]) rotate([90,0,0]) {
        hexagon(1, 5);
        translate([2.5,0,0]) cube([6,6,5], center=true);
    }
}


// final drawing
module final_wing() {
    difference() {
        body();
        slice();
    }
}
module final_arm() {
    difference() {
        body();
        final_wing();
    }
}

final_wing();
//final_arm();
//body();
//battery();


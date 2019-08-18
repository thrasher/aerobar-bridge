// Aerobar bridge
// dimensions in inches

 use <NACA_Airfoil_lib/shortcuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <NACA_Airfoil_lib/naca4.scad>
  use <mount2.scad>

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

AEROBAR_DIA = 7/8; // tube dia
AEROBAR_WIDTH_C2C = 4.02; // center to center of bars
CLIP_THICKNESS = 0.125;
CLIP_DIA = AEROBAR_DIA + CLIP_THICKNESS*2;
BRIDGE_LENGTH = 1.5;
WING_RADIUS = (AEROBAR_WIDTH_C2C/2) + 0.21;

ZIP_HEIGHT = .1; // ziptie hole height
ZIP_WIDTH = .2; // ziptie hole width

MARGIN = 0.02; // error allowance for part fit
GARMIN_DIA = 1.337 + MARGIN; // 1.337 k-edge garmin adapter diameter
GARMIN_TH = 0.200; // 0.200 k-edge garmin adapter thickness

module aerobar() {
    LENGTH = 4;
    color([.1,.8,0])
    translate([AEROBAR_WIDTH_C2C/2, 0, 0])
    cylinder(d=AEROBAR_DIA, h=LENGTH);
}
module aerobars() {
	aerobar();
	mirror([1,0,0]) aerobar();
}

module clip() {
	translate([AEROBAR_WIDTH_C2C/2, 0, 0])
	rotate([0,0,-90])
    difference() {
        union() {
            translate([0,0,.1*2]) cylinder(d=CLIP_DIA, h=BRIDGE_LENGTH-.1*4);
            translate([0,0,BRIDGE_LENGTH- 2*.1])
            cylinder(d1=CLIP_DIA, d2=CLIP_DIA-CLIP_THICKNESS*1.8, h=.1*2);
            translate([0,0,0])
            cylinder(d2=CLIP_DIA, d1=CLIP_DIA-CLIP_THICKNESS*1.8, h=.1*2);
        }
        // cut out the aerobar
        cylinder(d=AEROBAR_DIA, h=BRIDGE_LENGTH*4, center=true);

        // cut the oposite side off
        TRIM = 0.7;
        translate([0, CLIP_DIA/2 * TRIM, BRIDGE_LENGTH/2]) cube([BRIDGE_LENGTH,CLIP_DIA,BRIDGE_LENGTH*2], center=true);

        // cut top/bottom edges for straight bar
        rotate([0,0,90]) {
			  translate([0, AEROBAR_DIA, 0])
			  cube([AEROBAR_DIA,AEROBAR_DIA,BRIDGE_LENGTH*2], center=true);
			  translate([0, -AEROBAR_DIA, 0])
			  cube([AEROBAR_DIA,AEROBAR_DIA,BRIDGE_LENGTH*2], center=true);
			}
    }
}

module clips() {
    clip();
    mirror([1,0,0]) clip();
}
    WING_LEN = AEROBAR_WIDTH_C2C-AEROBAR_DIA;
module wing() {
    // translate([(AEROBAR_WIDTH_C2C)/2, .001, BRIDGE_LENGTH-3])
    difference() {
	    R(0,-90,0)
  	  linear_extrude(height = WING_LEN,center=true,convexity=10,twist=0,slices=10)
    	polygon(points = airfoil_data([0.0, 0.0, 0.2], L=BRIDGE_LENGTH));
    	// cut trailing edge off wing to make it safer
    	translate([0,0,BRIDGE_LENGTH + .5 - .2])
    	cube([WING_LEN,1,1],center = true);
    }
}
module wing2() {
	THICKNESS = 4 / 25.4; // mm
	translate([0,0,THICKNESS/2])
	rotate([0,90,0])
	hull() {
	cylinder(d = THICKNESS, h = WING_LEN, center = true);
	translate([THICKNESS - BRIDGE_LENGTH, 0, 0])
	cylinder(d = THICKNESS, h = WING_LEN, center = true);
	}
}

module ziptie() {
	translate([(AEROBAR_WIDTH_C2C)/2, 0, 0])
    rotate_extrude(angle = 360, convexity = 2) {
        translate([CLIP_DIA/2, (BRIDGE_LENGTH - ZIP_WIDTH)/2, 0])
        square(size = [ZIP_HEIGHT,ZIP_WIDTH], center = false);
    }
}
module zipties() {
    ziptie();
    mirror([1,0,0]) ziptie();
}
module kedge_insert() {
  btw_screws = 0.79;
  color([1,0,0])
  translate([0,0.12,.8])
  rotate([-90,0,0])
  union() {
    translate([0,0,-GARMIN_TH]) {
        cylinder(d=GARMIN_DIA, h=GARMIN_TH + 1);
        translate([0,btw_screws/2,-.05]) cylinder(d=.1, h=1);
        translate([0,-btw_screws/2,-.05]) cylinder(d=.1, h=1);
    }

    // garmin unit rotating, device corner extents
    cylinder(r1=1.2, r2=1.63, h=.71);
  }
}
module cleat_mount() {
    translate([0, 0, BRIDGE_LENGTH/2])
    // translate([0,0.11,0.95])
    rotate([-90,0,0])
    scale(1/2.56/10) // convert from mm to inches
    mount();
}
module mount_cutout() {
    translate([0, 0.00, BRIDGE_LENGTH/2])
    rotate([-90,0,0])
    scale(1/2.56/10)
    cylinder(d = 32, h = 10, center = true);
    // cube([34,34,3], center = true);
}

module assembly() {
	difference() {
		union() {
			clips();
			translate([0,0.4,0])
			wing2();
		}
		zipties();
		//kedge_insert();
        mount_cutout();

	}
    //cleat_mount();
}
cleat_mount();
// aerobars();
//zipties();
assembly();

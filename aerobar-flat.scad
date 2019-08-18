// Aerobar bridge
// dimensions in inches

use <NACA_Airfoil_lib/shortcuts.scad>  // see: http://www.thingiverse.com/thing:644830
use <NACA_Airfoil_lib/naca4.scad>
use <mount2.scad>
CLEAT_THICKNESS = 5; // specified in other file
GARMIN_SEAT_DIA = 34.0; // specified in other file

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

AEROBAR_DIA = 22.225; // 7/8 inches tube dia
AEROBAR_WIDTH_C2C = 101.6; // 101.6mm = 4" or 4.02 inches center to center of bars
CLIP_THICKNESS = 3.175; // 0.125 inches
CLIP_DIA = AEROBAR_DIA + CLIP_THICKNESS*2;
BRIDGE_LENGTH = 18; // 1.5 inches
WING_RADIUS = (AEROBAR_WIDTH_C2C/2) + 5.33;

ZIP_HEIGHT = 2.5; // ziptie hole height
ZIP_WIDTH = 5.0; // ziptie hole width

MARGIN = 0.5; // error allowance for part fit
GARMIN_DIA = 34 + MARGIN; // 1.337 k-edge garmin adapter diameter
GARMIN_TH = 5.12; // 0.200 k-edge garmin adapter thickness

ROTATE = 50; // used to turn the clips around the bar

module aerobar() {
    LENGTH = 100;
    color([.1,.8,0])
    cylinder(d=AEROBAR_DIA, h=LENGTH, center = true);
}
module aerobars() {
  translate([AEROBAR_WIDTH_C2C/2, 0, 0])
  rotate([0,0,ROTATE])
	children();

	mirror([1,0,0])
	translate([AEROBAR_WIDTH_C2C/2, 0, 0])
	rotate([0,0,ROTATE])
	children();
}

module clip() {
	rotate([0,0,-90]) {
    difference() {
     	hull() {
     			WEDGE_HEIGHT = BRIDGE_LENGTH*.3;
          translate([0,0,(BRIDGE_LENGTH-WEDGE_HEIGHT)/2])
          cylinder(d1=CLIP_DIA, d2=1+CLIP_DIA-CLIP_THICKNESS*1.8, h=WEDGE_HEIGHT, center = true);

          translate([0,0,0-(BRIDGE_LENGTH-WEDGE_HEIGHT)/2])
          cylinder(d2=CLIP_DIA, d1=1+CLIP_DIA-CLIP_THICKNESS*1.8, h=WEDGE_HEIGHT, center = true);
      }
      // cut out the aerobar
      aerobar();
      //cylinder(d=AEROBAR_DIA, h=BRIDGE_LENGTH*4, center=true);

      // cut the opposite side off
      TRIM = 0.7;
      translate([0, CLIP_DIA/2 * TRIM, 0])
      cube([BRIDGE_LENGTH*10,CLIP_DIA,BRIDGE_LENGTH*10], center=true);

	    difference() {
		    cylinder(d = AEROBAR_DIA*2, h = BRIDGE_LENGTH*2, center = true);
			  translate([0, -CLIP_THICKNESS, 0])
		    cylinder(d = AEROBAR_DIA, h = BRIDGE_LENGTH*2, center = true);
	    }
    }
  }
}
//clip();
module clips() {
		translate([AEROBAR_WIDTH_C2C/2, 0, 0])
    clip();

    mirror([1,0,0])
    translate([AEROBAR_WIDTH_C2C/2, 0, 0])
    clip();
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

module wing3() {
  SPREAD = 5;
  SURFACE = AEROBAR_WIDTH_C2C/2;
  DROP = (GARMIN_SEAT_DIA+6)/2 - CLEAT_THICKNESS/2 - SPREAD/2;
  translate([0,DROP/2+3.5,0]) {
	difference() {
		translate([0,0,AEROBAR_DIA/2 - CLEAT_THICKNESS + CLIP_THICKNESS + 1])
		hull() {
	    rotate_extrude(angle = 360, convexity = 2) {
	        translate([(GARMIN_SEAT_DIA+6)/2-CLEAT_THICKNESS/2, 0, 0])
	        circle(d = CLEAT_THICKNESS, center = false);
	    }
	    translate([SURFACE,SPREAD/2-DROP,0])
	    sphere(d = CLEAT_THICKNESS);
	    translate([SURFACE,-SPREAD/2-DROP,0])
	    sphere(d = CLEAT_THICKNESS);
	    translate([-SURFACE,SPREAD/2-DROP,0])
	    sphere(d = CLEAT_THICKNESS);
	    translate([-SURFACE,-SPREAD/2-DROP,0])
	    sphere(d = CLEAT_THICKNESS);
    }
    // cut ends off spheres inside aerobars
    translate([AEROBAR_WIDTH_C2C/2,0,0])
    rotate([90,0,0])
	  cylinder(d = AEROBAR_DIA, h = BRIDGE_LENGTH * 10, center = true);
	  translate([-AEROBAR_WIDTH_C2C/2,0,0])
    rotate([90,0,0])
	  cylinder(d = AEROBAR_DIA, h = BRIDGE_LENGTH * 10, center = true);

    // cut hole for cleat mount
    cylinder(d = GARMIN_SEAT_DIA, h = CLEAT_THICKNESS*10, center = true);
  }
	translate([0,0,AEROBAR_DIA/2 - CLEAT_THICKNESS + CLIP_THICKNESS + 1])
  mount();
  }
}
// wing3();

module ziptie() {
	translate([-CLIP_THICKNESS, 0, 0])
    rotate_extrude(angle = 360, convexity = 2) {
        translate([AEROBAR_DIA/2, (- ZIP_WIDTH)/2, 0])
        square(size = [ZIP_HEIGHT,ZIP_WIDTH], center = false);
    }
}
module cleat_mount() {
    // translate([0, 0, BRIDGE_LENGTH/2])
    translate([0,AEROBAR_DIA/2 - CLEAT_THICKNESS/2,0])
    rotate([-90,0,0])
    mount();
}
module mount_cutout() {
    translate([0, 0.00, BRIDGE_LENGTH/2])
    rotate([-90,0,0])
    cylinder(d = 32, h = 10, center = true);
    // cube([34,34,3], center = true);
}

module assembly() {
	difference() {
		union() {
			aerobars() clip();
			rotate([90,0,0])
			wing3();
		}
		aerobars() ziptie();
	}
}

assembly();
//aerobars() aerobar();

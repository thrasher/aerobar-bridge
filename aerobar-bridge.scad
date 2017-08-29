// Aerobar bridge
// dimensions in inches

 use <NACA_Airfoil_lib/shortcuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <NACA_Airfoil_lib/naca4.scad>

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

AEROBAR_DIA = 7/8; // tube dia
AEROBAR_WIDTH_INTERNAL = 3.0; // space between bars
CLIP_DIA = AEROBAR_DIA + 0.2;

module aerobars() {
    LENGTH = 4;
    cylinder(d=AEROBAR_DIA, h=LENGTH);
    translate([AEROBAR_WIDTH_INTERNAL + AEROBAR_DIA, 0, 0]) cylinder(d=AEROBAR_DIA, h=LENGTH);
}

module clip() {
    LENGTH = 2;

    difference() {
        cylinder(d=CLIP_DIA, h=LENGTH);
        cylinder(d=AEROBAR_DIA, h=LENGTH);
        translate([0, CLIP_DIA/2, LENGTH/2]) cube([LENGTH,CLIP_DIA,LENGTH], center=true);
    }
}

module clips() {
    rotate([0,0,0]) clip();
    translate([AEROBAR_WIDTH_INTERNAL + AEROBAR_DIA, 0, 0])
    rotate([0,0,0]) clip();
}
module wing() {
    translate([(AEROBAR_WIDTH_INTERNAL + AEROBAR_DIA)/2, (AEROBAR_WIDTH_INTERNAL + AEROBAR_DIA)/2 +.1, -1])
    rotate([0,0,180+45])
    rotate_extrude(angle = 90, convexity = 10)
    translate([3, 3, 0])
    R(0, -180, 90)
    polygon(points = airfoil_data([0, 0, .3], L=2));    
    clips();
}
module ziptie() {
    rotate_extrude(angle = 360, convexity = 2) {
        translate([CLIP_DIA/2, 1.6, 0])
        square(size = [.1,.2], center = false);
    }
    rotate_extrude(angle = 360, convexity = 2) {
        translate([CLIP_DIA/2, .2, 0])
        square(size = [.1,.2], center = false);
    }
}
module zipties() {
    ziptie();
    translate([AEROBAR_WIDTH_INTERNAL + AEROBAR_DIA, 0, 0])
    ziptie();
}
difference() {
    wing();
    aerobars();
    zipties();
}
//rotate([-45,90, 270])


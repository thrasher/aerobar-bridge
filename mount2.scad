// Garmin Edge mount
// re-draw using basic primitives

// units in millimeters
$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

ERR_MARGIN = 0.4; // make diameters this much bigger
DIVOT_DISTANCE = 28.15;// + ERR_MARGIN/2; // dia of garmin tab divots
GARMIN_TAB_DIA = 28.70; // diameter of tab limits
GARMIN_INNER_DIA = 25.0; // diameter of garmin inner mount
GARMIN_SEAT_DIA = 34.0; // 34mm dia of garmin mount seat surface
GARMIN_DEPTH = 3.0; // depth or height of cleat
HEIGHT = 5; // height of part
GARMIN_TAB_WIDTH = 11.0; // width of cleat tabs

module lock_key() {
    //inner cylinder bumps
    DIVOT_DIA = 3;
    translate([(DIVOT_DISTANCE+DIVOT_DIA)/2, 0 , 0])
    cylinder(h=HEIGHT, d=DIVOT_DIA, center=true);
    translate([-(DIVOT_DISTANCE+DIVOT_DIA)/2, 0, 0])
    cylinder(h=HEIGHT, d=DIVOT_DIA, center=true);
}

module tab_cutout() {
	BRIDGE_BUFFER = 2;
    cube([GARMIN_TAB_WIDTH + ERR_MARGIN, BRIDGE_BUFFER + GARMIN_TAB_DIA + ERR_MARGIN, 10], center = true);
}

module mount() {
    difference() {
        //cube([GARMIN_SEAT_DIA,GARMIN_SEAT_DIA,HEIGHT], center = true);
        cylinder(d = GARMIN_SEAT_DIA, h = HEIGHT, center = true);
        cylinder(d = GARMIN_INNER_DIA + ERR_MARGIN, h = HEIGHT*2, center = true);
        translate([0,0,-GARMIN_DEPTH/2 * 0.9 + ERR_MARGIN/2])
        cylinder(d = GARMIN_TAB_DIA + ERR_MARGIN, h = HEIGHT, center = true);
        tab_cutout();
    }
    lock_key();
}

mount();
// tab_cutout();

// units in millimeters
$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

INNER_DIA = 30.25;
WALL = 3;
DIVOT_DISTANCE = 28.15; // dia of garmin tab divots

module border() {
	translate([0,0,-(4.5+.6)/2])
	difference() {
		cube([INNER_DIA + WALL,INNER_DIA + WALL,(4.5+.6)], center=true);
		cylinder(h=40, d = INNER_DIA + WALL, center=true);
	}
}
module mask() {
	difference() {
		cylinder(h=10, d=60, center=true);
		cylinder(h=40, d = INNER_DIA + WALL, center=true);
	}
	translate([0,0,-5.6])
	cube([40,40,10], center=true);
}
module part() {
	translate([0,0,-4.5])
	difference() {
		union() {
			import("garmin-edge-mount.stl", convexity = 10);

			//inner cylinder bumps
			DIVOT_DIA = 3;
			translate([0, (DIVOT_DISTANCE+DIVOT_DIA)/2,0])
			cylinder(h=9, d=DIVOT_DIA, center=true);
			translate([0, -(DIVOT_DISTANCE+DIVOT_DIA)/2,0])
			cylinder(h=9, d=DIVOT_DIA, center=true);
		}

		mask();
	}
}

part();
border();


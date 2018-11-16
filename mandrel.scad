// Mandrel for TT bike rear brake noodle

// units in millimeters
$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

MARGIN = 0.1;
TUBE_DIA = 4.17 + MARGIN;
BEND_DIA = 25 + TUBE_DIA/2;
BEND_ANGLE = 90+40;
THICKNESS = 10;
NUB_DIA = 5.54;

// flex tube override dimensions
//TUBE_DIA = 4.92 + MARGIN;
//NUB_DIA = 5.89;


module tube() {
cylinder(d=NUB_DIA + MARGIN, h=25.4);
cylinder(d=6.87 + MARGIN, h=2.0 + MARGIN);

translate([-BEND_DIA/2,0,0])
rotate([-90,0,0])
rotate_extrude(angle=BEND_ANGLE, convexity=10)
       translate([BEND_DIA/2, 0]) circle(d=TUBE_DIA);

translate([-BEND_DIA/2,0,0])
rotate([0,BEND_ANGLE+180,0])
translate([-BEND_DIA/2,0,0])
cylinder(d=TUBE_DIA, h=40);
}


module mold() {
    rotate([90,0,0]) cylinder(d=BEND_DIA, h=THICKNESS,center=true);
    hull() {
    translate([0,0,BEND_DIA/2])cube([BEND_DIA,THICKNESS,BEND_DIA], center=true);
    rotate([0,BEND_ANGLE,0]) translate([0,0,-BEND_DIA/2]) cube([BEND_DIA,THICKNESS,BEND_DIA], center=true);
    }
}

difference() {
    mold();
    translate([BEND_DIA/2,0,0])
    tube();
    rotate([90,0,0])
    cylinder(d = 0.25*25.4, THICKNESS*2, center=true); // 1/4 inch hole in center
}
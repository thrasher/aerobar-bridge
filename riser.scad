
// units in millimeters
$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

LENGTH = 80-6;
WIDTH = 95 - 4;
CORNER_RADIUS = 20;
RISE = 20;
ANGLE = 90;

module corner() {
    cylinder(r=CORNER_RADIUS, h=RISE+20);
}

module riser() {
    difference() {
        translate([CORNER_RADIUS-WIDTH/2, CORNER_RADIUS-LENGTH/2,0])
        hull() {
            corner();
            translate([0,LENGTH-(2*CORNER_RADIUS),0]) corner();
            translate([WIDTH-(2*CORNER_RADIUS),LENGTH-(2*CORNER_RADIUS),0]) corner();
            translate([WIDTH-(2*CORNER_RADIUS),0,0]) corner();
        }
        
        // arm rest
        translate([0, 0, 100 + RISE])
        rotate([ANGLE,0,0])
        cylinder(r=100, h=200, center=true);
        
        lift();

//        bolt_holes();
//        translate([18,0,0]) bolt_holes();
    }
}


module bolt_holes() {
        BOLT_HOLE = 14;
        translate([-WIDTH/2+18,-LENGTH/2 + 35,0])
        cylinder(d=BOLT_HOLE, h=100);
        translate([-WIDTH/2+18,-LENGTH/2 + 65,0])
        cylinder(d=BOLT_HOLE, h=100);
}

module lift() {
    LIFT_RADIUS = 30;
    translate([18,50,LIFT_RADIUS])
    rotate([90,0,0])
    difference() {
        cylinder(r=100, h=LENGTH*1.2);
        cylinder(r=LIFT_RADIUS, h=LENGTH*1.2);
        translate([-500,0,0]) cube([1000,100,100]);
        translate([-100,-100,0]) cube([100,100,100]);    
    }
}

// use mirror to create right and left hand parts

module left() {
    riser();
}
module right() {
    mirror([1,0,0])
    riser();
}

module export(part) { 
    if (part == 1) left(); 
    if (part == 2) right(); 
}
// to be called from bash script
part = 1; // default part for rendering in editor
export(part);

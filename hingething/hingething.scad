$fn=50;

difference(){
    union(){
        cylinder(r=11,h=2);
        cylinder(r1=7.35,h=9.5,r2=7.25);
        translate([0,0,9.5]) cylinder(r1=7.25,r2=6,h=3.5);
    }
    translate([0,0,-0.5]) cylinder(r=3.25,h=20);
    translate([0,0,5.24]) cylinder(r1=5,r2=3.25,h=1.76);
    translate([0,0,-0.5]) cylinder(r=5,h=5.75);
}

// Parabolic Arch Wall
// Created by Antony Furneaux
// 17/06/2013

use <parch_wall.scad>



translate([6,-5,0])
ArchWall(9,10,7,6,1.4, 40, 26, true);

translate([6,82,0])
ArchWall(14,10,1,9,3, 40, 20, true);

translate([0,0,13])
cube([12,12,26],true);
translate([50,0,13])
cube([12,12,26],true);


color("Grey")
rotate([0,0,120])
{
translate([50,0,0])
cylinder(r=6,h=20);
translate([6,-5,0])
ArchWall(5,10,5,5,0.7, 41, 20, true);
}


color("Blue")
translate([50,0,0])
rotate([0,0,60])
{
translate([50,0,0])
cylinder(r=6,h=20);
translate([6,-5,0])
ArchWall(10,10,1,5,0.7, 41, 20, true);
}


color("Green")
rotate([0,0,120])
translate([50,0,0])
rotate([0,0,-60])
{
translate([50,0,0])
cylinder(r=6,h=20);
translate([6,-5,0])
ArchWall(8,10,6,5,2, 41, 20, true);
}


color("Red")
translate([50,0,0])
rotate([0,0,60])
translate([50,0,0])
rotate([0,0,60])
{
translate([50,0,0])
cylinder(r=6,h=20);
translate([6,-5,0])
ArchWall(12,10,5,5,2.5, 40, 20, true);
}

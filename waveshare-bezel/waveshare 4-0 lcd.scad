// text_on_cube.scad - Example for text() usage in OpenSCAD

echo(version=version());

font = "Liberation Sans";

cube_size = 10;
letter_size = 50;
letter_height = 5;

PCB_height = 76.54;
PCB_width = 98.58;
PCB_hole_width = 90;
PCB_hole_height = 66;
SCREEN_width = 97.8;
SCREEN_height = 57.3;
SCREEN_thickness = 3.4;
VIEWABLE_width = 87.75;
VIEWABLE_height = 52.44;

wall_thickness = 1.5;
bezel_thickness = 1;

VIEWABLE_offset = 7.95;
shim = 0.5;

o = cube_size / 2 - letter_height / 2;

CubePoints = [
  [  -bezel_thickness,  -bezel_thickness,  0 ],  //0
  [ VIEWABLE_width+bezel_thickness,  -bezel_thickness,  0 ],  //1
  [ VIEWABLE_width+bezel_thickness,  VIEWABLE_height+bezel_thickness,  0 ],  //2
  [  -bezel_thickness,  VIEWABLE_height+bezel_thickness,  0 ],  //3
  [  0,  0,  bezel_thickness ],  //4
  [ VIEWABLE_width,  0,  bezel_thickness ],  //5
  [ VIEWABLE_width,  VIEWABLE_height,  bezel_thickness ],  //6
  [  0,  VIEWABLE_height,  bezel_thickness ]]; //7
  
CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
module letter(l) {
  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
  }
}

union(){
    difference() {
        color("gray") cube([PCB_width + (2*wall_thickness)+ shim,PCB_height  + (2*wall_thickness)+ shim,cube_size], center = true);

        translate([0,0,SCREEN_thickness+bezel_thickness])cube([PCB_width,PCB_height,cube_size], center = true);
        translate([0,0,bezel_thickness])cube([SCREEN_width, SCREEN_height, cube_size], center=true);
        translate([VIEWABLE_offset/2, 0, -0.1])cube([VIEWABLE_width, VIEWABLE_height, cube_size],center=true);
    translate([-VIEWABLE_width/2+VIEWABLE_offset/2,-VIEWABLE_height/2,-cube_size/2-0.05])polyhedron( CubePoints, CubeFaces );    
    translate([0,0,-(cube_size/2)+SCREEN_thickness]){
        translate([PCB_hole_width/2, PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
        translate([-PCB_hole_width/2, -PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
        translate([-PCB_hole_width/2, PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
        translate([PCB_hole_width/2, -PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
    }
    }

}
    //translate([0, -o, 0]) rotate([90, 0, 0]) letter("C");
    //translate([o, 0, 0]) rotate([90, 0, 90]) letter("U");
    //translate([0, o, 0]) rotate([90, 0, 180]) letter("B");
    //translate([-o, 0, 0]) rotate([90, 0, -90]) letter("E");


  // Put some symbols on top and bottom using symbols from the
  // Unicode symbols table.
  // (see https://en.wikipedia.org/wiki/Miscellaneous_Symbols)
  //
  // Note that depending on the font used, not all the symbols
  // are actually available.
  //translate([0, 0, o])  letter("\u263A");
  //translate([0, 0, -o - letter_height])  letter("\u263C");



// Written in 2014 by Torsten Paul <Torsten.Paul@gmx.de>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

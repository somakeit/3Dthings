/*
 * So Make It (http://www.somakeit.org.uk/) Logo Key Ring
 *
 * Copyright (c) 2013 Mark Hindess & Bracken Dawson
 * License:
 *   Creative Commons Attribution-ShareAlike 3.0 Unported License
 *   http://creativecommons.org/licenses/by-sa/3.0
 */

thickness = 2.5;
size = 40;
corner_radius = 7;
nfc_tag_radius = 14.5;
hole_radius = 3;
$fn = 30;

module top() {
  difference() {

    // simple rounded square
    hull() {
      translate([corner_radius, corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
      translate([size-corner_radius, corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
      translate([size-corner_radius, size-corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
      translate([corner_radius, size-corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
    }
    // slightly off center to allow for "handle"
    translate([size/2, size/2.3, 1.5]) {
      difference() {
        // large octagon
        rotate([0,0,22.5])
          cylinder(r = size/3, h = thickness, center = true, $fn = 8);
  
        // central bar
        translate([0,-(1+size/6),-1])
          cube([size/4, 1+size/3, thickness], center = true);
        // octagonal end of central bar
        rotate([0,0,22.5])
          cylinder(r = size/(8*cos(22.5)), h = thickness,
                   $fn = 8, center = true);
      }
  
      // handle
      translate([0,size/3,0])
        cube([size/4, size/4, thickness], center = true);
   }
  
    // hole for attachment
    translate([size-hole_radius-(corner_radius/2),
               size-hole_radius-(corner_radius/2), 0])
      cylinder(r = hole_radius, h = thickness+2, center = true);
  }
}

module bottom() {
  difference() {

    // simple rounded square
    hull() {
      translate([corner_radius, corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
      translate([size-corner_radius, corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
      translate([size-corner_radius, size-corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
      translate([corner_radius, size-corner_radius, 0])
        cylinder(r = corner_radius, h = thickness, center = true);
    }
    // slightly off center to allow for "handle"
    mirror([0,0,1]) translate([size/2, size/2.3, 1.5]) {
      difference() {
        // large octagon
        rotate([0,0,22.5])
          cylinder(r = size/3, h = thickness, center = true, $fn = 8);
  
        // central bar
        translate([0,-(1+size/6),-1])
          cube([size/4, 1+size/3, thickness], center = true);
        // octagonal end of central bar
        rotate([0,0,22.5])
          cylinder(r = size/(8*cos(22.5)), h = thickness,
                   $fn = 8, center = true);
      }
  
      // handle
      translate([0,size/3,0])
        cube([size/4, size/4, thickness], center = true);
    }

    // Relief for NFC tag

    translate([size/2, size/2, 1.5]) cylinder(r = nfc_tag_radius, h = 2, center = true);
  
    // hole for attachment
    translate([size-hole_radius-(corner_radius/2),
               size-hole_radius-(corner_radius/2), 0])
      cylinder(r = hole_radius, h = thickness+2, center = true);
  }
}

top();
translate([size + 10, 0, 0]) bottom();


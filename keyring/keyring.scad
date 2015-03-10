
/* 
* (c) Copyright 2015 So Make It Limited
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


keyring_length	        =  55;   // mm  the main body of the keyring, not the tag
keyring_width		=  25;   // mm
keyring_thickness	=   4.0; // mm
keyring_border_width    =   2.0; // mm
keyring_border_height   =   1.5; // mm

keyring_tag_r           =   7.5; //mm
keyring_hole_r          =   3.5; //mm
// another offset so the hole_x_offset is really the mid point of the
// cylinder used to produce the hull rather than the hole itself
additional_x_offset     =   3.0; // mm

image_file              = "mylogo.png";
image_length            = 158 * 2.0; //mm
image_width             =  73 * 2.0; //mm

pi = 3.142;

tag_l = keyring_width / sqrt(2.0);
tag_r = (keyring_width - keyring_border_width * 2.0) / sqrt(2.0);

hole_x_offset = sqrt(tag_l * tag_l - (keyring_width / 2.0) * (keyring_width / 2.0));
inner_x_offset = sqrt(tag_r * tag_r - (keyring_width / 2.0 - keyring_border_width) * (keyring_width / 2.0 - keyring_border_width));

$fn = 100;
                        
union() {
    
    translate ([-keyring_length / 2.0 - hole_x_offset, 0, 0]) {
        difference() {
            rotate([0, 0, 45.0 + 270.0]) {
                difference() {
                    hull() {
                        cube([tag_l, tag_l, keyring_thickness]);
                        cylinder(r = keyring_tag_r, h = keyring_thickness);
                    }
                    translate([0,
                                0,
                                keyring_thickness - keyring_border_height]) {
                        hull() {
                            translate([keyring_border_width, keyring_border_width, 0]) {
                                cube([tag_r, tag_r, keyring_thickness]);
                            }
                            translate([0, 0, 0]) {
                                cylinder(r = keyring_tag_r - keyring_border_width, h = keyring_thickness);
                               
                            }
                        }
                    }
                }
            }
            // hole
            translate([additional_x_offset, 0, 0]) cylinder(r = keyring_hole_r, h = keyring_thickness);
            // cut off remainder
            translate([2.0 * hole_x_offset, 0, keyring_thickness / 2.0]) {
                cube([keyring_width, keyring_width, keyring_thickness], center = true);
            }
        }
    }
    
    // add a collar around the hole
    translate([-keyring_length / 2.0 - hole_x_offset + additional_x_offset, 0, keyring_thickness - keyring_border_height]) {
        difference() {
            cylinder(r = keyring_hole_r + keyring_border_width, h = keyring_border_height);
            cylinder(r = keyring_hole_r, h = keyring_border_height);
        }
    }
    
    translate([0, 0, keyring_thickness - keyring_border_height]) {
        logo();
    }
    
    difference() {
        translate([0, 0, keyring_thickness / 2.0])
            cube([keyring_length,
                    keyring_width,
                    keyring_thickness], center=true);
        translate([-keyring_border_width / 2.0, 0, keyring_thickness - 0.5 * keyring_border_height ])
            cube([keyring_length - keyring_border_width,
                    keyring_width - (2.0 * keyring_border_width),
                    keyring_border_height], center=true);
    }
}
          

module logo() {
    
    // lazy
    scale([keyring_length / image_length, keyring_width / image_width, keyring_border_height / 100.0]) {
        surface(file = image_file, center = true, invert = false);
    }
}

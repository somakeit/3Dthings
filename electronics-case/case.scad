
// *************************************************************************
/*
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// *************************************************************************


box_external_length    = 150;    // mm
box_external_width     =  90;    // mm
box_external_height    =  45;    // mm
wall_thickness         =   7;    // mm
lid_tolerance          =   0.5;  // mm
pcb_mount_pitch_length = 100;    // mm 
pcb_mount_pitch_width  =  80;    // mm
pcb_mount_radius       =   1.5;  // mm
pcb_mount_height       =   4;    // mm
pcb_mount_origin       =   [wall_thickness, wall_thickness]; // mm

union() {
    
    // The PCB mounts
    translate (pcb_mount_origin) { 
        pcb_mount(pcb_mount_pitch_length,
                    pcb_mount_pitch_width,
                    pcb_mount_radius,
                    pcb_mount_height);
    }
                
    // The lid
    translate ([wall_thickness, wall_thickness, box_external_height - wall_thickness]) {
        color("SeaGreen", a = 0.5) {
            rounded_box(box_external_length - 2.0 * wall_thickness,
                        box_external_width - 2.0 * wall_thickness,
                        wall_thickness);
        }
    }
    
    // The main body of the box
    difference() {
        rounded_box(box_external_length,
                    box_external_width,
                    box_external_height);
    
        translate ([wall_thickness, wall_thickness, wall_thickness]) {
            rounded_box(box_external_length - 2.0 * wall_thickness,
                        box_external_width - 2.0 * wall_thickness,
                        box_external_height - wall_thickness);
            }

    }
}


module rounded_box(length, width, height) {

    minkowski() {

        cylinder(r = 10, h = 1);

        cube(size=[ length, width, height ], center = false);

    }

}

module pcb_mount_hole(radius, height) {

    width = 2.0; // mm

    difference() {
        cylinder(r = radius + width, h = height, center = false);
        cylinder(r = radius, h = height, center = false);
    }

}

module pcb_mount(pitch_length, pitch_height, radius, height) {
 
    for (i = [0:1]) {
        for (j = [0:1]) {
            translate([i * pitch_width, j * pitch_length, 0]) {
                pcb_mount_hole(radius, height);
            }
        }
    }
    
}
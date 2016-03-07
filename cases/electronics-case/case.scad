
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

use <MCAD/polyholes.scad>;

// Box configuration
wall_thickness         =   4;    // mm
box_external_length   = 110 + wall_thickness;    // mm
box_external_width    =  55 + wall_thickness;    // mm
box_external_height   =  35 + 2 * wall_thickness;    // mm
lid_tolerance          =   0.5;  // mm

// PCB mount configuration
pcb_mount_pitch_length =  60;    // mm 
pcb_mount_pitch_width  =  30;    // mm
pcb_mount_radius       =   1.5;  // mm
pcb_mount_height       =   4;    // mm
pcb_mount_origin       = [(box_external_length - pcb_mount_pitch_length) - wall_thickness * 2.0, (box_external_width - pcb_mount_pitch_width) / 2.0]; // mm
pcb_mount_auto_centre  = false;

// Mains socket?
mains_socket = true;
mains_socket_width = 28.5;  // mm
mains_socket_height = 20.5;  // mm
mains_socket_mount_pitch = 40.0; //mm
mains_socket_mount_d = 4.0;  //mm

// grommet?
grommet = true;
grommet_type = "rectangular";
grommet_width =  9.25;  // mm
grommet_height =  6.25;  // mm


// Style configuration
corner_style    = "rounded";  // only style currently available
rounding_radius = wall_thickness;
cylinder_faces  = 30;

logo           = true;
// Logo configuration
logo_thickness     =  2.5;
logo_size          = 30;
logo_corner_radius =  6;
logo_hole_radius   =  2;
logo_fn            = 30;
logo_origin        = [ 30, 20 ]; //mm

// Compute the expensive, albeit elegant Minkowski Sum 
// to generate the rounded box corners
use_minkowski = false;

use <../../SoMakeIt-Keyring/logo.scad>

union() {
    
    // The PCB mounts
    if (pcb_mount_auto_centre) {
        pcb_mount_origin = [ (box_external_length - pcb_mount_pitch_length) / 2.0, (box_external_width - pcb_mount_pitch_width) / 2.0];
         translate (pcb_mount_origin) { 
            pcb_mount(pcb_mount_pitch_length,
                        pcb_mount_pitch_width,
                        pcb_mount_radius,
                        pcb_mount_height);
         }
    } else {
        translate (pcb_mount_origin) { 
            pcb_mount(pcb_mount_pitch_length,
                        pcb_mount_pitch_width,
                        pcb_mount_radius,
                        pcb_mount_height);
        }
    }
                
    // The lid
    union() {
        translate ([wall_thickness + lid_tolerance,
                    wall_thickness + lid_tolerance,
                    box_external_height - 2.0 * wall_thickness]) {
            color("SeaGreen", a = 0.5) {
                %rounded_box(box_external_length - 2.0 * wall_thickness - 2.0 * lid_tolerance,
                            box_external_width - 2.0 * wall_thickness - 2.0 * lid_tolerance,
                            wall_thickness, rounding_radius);
            }
        }
        
        translate([0, 0, box_external_height - wall_thickness]) {
            %rounded_box(box_external_length,
                    box_external_width,
                    wall_thickness, rounding_radius);
        }
        
        if (logo == true) {
            translate ([logo_origin[0], logo_origin[1], box_external_height]) {
                somakeit_logo(logo_thickness, logo_size,
                                logo_corner_radius, logo_hole_radius,
                                logo_fn);
            }
        }
    }
    
    // The main body of the box
    difference() {
        rounded_box(box_external_length,
                    box_external_width,
                    box_external_height - wall_thickness,
                    rounding_radius);
    
        translate ([wall_thickness, wall_thickness, wall_thickness]) {
            rounded_box(box_external_length - 2.0 * wall_thickness,
                        box_external_width - 2.0 * wall_thickness,
                        box_external_height - 2.0 * wall_thickness,
                        rounding_radius);
            }
        // Mains socket cutout
        if (mains_socket) {
            union() {
                translate([wall_thickness / 2.0 - 1.0, box_external_width / 2.0, box_external_height / 2.0]) {
                    cube([wall_thickness + 2.0, mains_socket_width, mains_socket_height], center=true);
                    translate ([-wall_thickness / 2.0 - 1.0, -mains_socket_mount_pitch / 2.0, 0]) rotate([0,90,0]) polyhole(d = mains_socket_mount_d, h = wall_thickness + 2.0);
                    translate ([-wall_thickness / 2.0 - 1.0, mains_socket_mount_pitch / 2.0, 0]) rotate([0,90,0]) polyhole(d = mains_socket_mount_d, h = wall_thickness + 2.0);
                }
            }
        }
        
        if (grommet) {
            if (grommet_type == "rectangular") {
                translate([box_external_length - wall_thickness / 2.0 + 1.0, box_external_width / 2.0, wall_thickness + 12.0]) {
                    cube([wall_thickness + 2.0, grommet_width, grommet_height], center=true);
                }
            }
        }

    }
}


module rounded_box(length, width, height, r) {

    if (use_minkowski) {
        
        minkowski() {

            cylinder(r = wall_thickness, h = 1);

            cube(size=[ length - wall_thickness,
                        width - wall_thickness,
                        height ], center = false);

        }
        
    } else {
        
        hull() {
            translate([r,r,0]) cylinder(r = r, h = height, $fn = cylinder_faces);
            translate([length-r,r,0]) cylinder(r = r, h = height, $fn = cylinder_faces);
            translate([length-r,width-r,0]) cylinder(r = r, h = height, $fn = cylinder_faces);
            translate([r,width-r,0]) cylinder(r = r, h = height, $fn = cylinder_faces);
        }
    }

}

module pcb_mount_hole(radius, height) {

    width = 2.0; // mm

    difference() {
        cylinder(r = radius + width, h = height, center = true, $fn = cylinder_faces);
        cylinder(r = radius, h = height, center = true, $fn = cylinder_faces);
    }

}

module pcb_mount(pitch_length, pitch_width, radius, height) {
 
    translate([0, 0, height / 2.0 + wall_thickness]) {
        union() {
            for (i = [0:1]) {
                for (j = [0:1]) {
                    translate([j * pitch_length, i * pitch_width, 0]) {
                        pcb_mount_hole(radius, height);
                    }
                }
            }
        }
    }
    
}
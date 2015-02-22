
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


box_external_length = 150; // mm
box_external_width  =  90; // mm
box_external_height =  45; // mm
wall_thickness      =   7; // mm


union() {
    
    rounded_box(box_external_length - 2.0 * wall_thickness,,
                box_external_width - 2.0 * wall_thickness,
                box_external_height);
    
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

        cylinder(r=10, h=1);

        cube(size=[ length, width, height ], center=false);

    }

}

module pcb_mount_hole() {

    cylinder(r=)

}

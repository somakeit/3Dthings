/*
* (c) Copyright 2016 So Make It Limited
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

module wheel(h = 15, r = 30, cr = 10, rr = 1.5) {
  minkowski() {
    difference() {
      translate([0,0,rr]) cylinder(h=h-rr*2, r = r - rr*2);
      for (i = [0:4]) {
        rotate([0,0,i*360/5]) translate([0, r/2 + cr, 0]) {
          cylinder(r = cr, h = h*2);
        }
      }
    }
    sphere(r=rr);
  }
}

tolerance = 0.2;
h=16.5;
rr = 2;
knob_r = 20;
hex_r = 11.1/2+tolerance;
round_r = 11.7/2+tolerance;
difference() {
  wheel(r = knob_r, h = h, rr=2);
  cylinder(r = hex_r, h = h, $fn = 6);
  translate([0,0,h-3]) cylinder(r = round_r, h = 4, $fn = 32);
}


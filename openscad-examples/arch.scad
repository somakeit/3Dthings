inner_rad   = 10;
outer_rad   = 12;
basic_angle = 10;
gap_factor  = 1;

for(angle = [basic_angle : basic_angle : 180] ) {
  translate(v = [0 - cos(angle - basic_angle / 2) * gap_factor, sin(angle - basic_angle / 2) * gap_factor, 1]) {
    polygon(points = [[0 - cos(angle - basic_angle) * outer_rad, sin(angle - basic_angle) * outer_rad],
                     [0 - cos(angle) * outer_rad, sin(angle) * outer_rad],
                     [0 - cos(angle) * inner_rad, sin(angle) * inner_rad],
                     [0 - cos(angle - basic_angle) * inner_rad, sin(angle - basic_angle) * inner_rad]],
            paths = [[0,1,2,3]]);
  }
}
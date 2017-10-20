// waveshare 4-0 lcd.scad
//bezel and mount for waveshare 4.0" 800x480 IPS HDMI LCD

echo(version=version());

box_size = 10;
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


TrapezoidPoints = [
  [  -bezel_thickness,  -bezel_thickness,  0 ],  //0
  [ VIEWABLE_width+bezel_thickness,  -bezel_thickness,  0 ],  //1
  [ VIEWABLE_width+bezel_thickness,  VIEWABLE_height+bezel_thickness,  0 ],  //2
  [  -bezel_thickness,  VIEWABLE_height+bezel_thickness,  0 ],  //3
  [  0,  0,  bezel_thickness ],  //4
  [ VIEWABLE_width,  0,  bezel_thickness ],  //5
  [ VIEWABLE_width,  VIEWABLE_height,  bezel_thickness ],  //6
  [  0,  VIEWABLE_height,  bezel_thickness ]]; //7
  
TrapezoidFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
union(){
    difference() {
        color("gray") cube([PCB_width + (2*wall_thickness)+ (2*shim),PCB_height  + (2*wall_thickness)+ (2*shim),box_size], center = true);

        translate([0,0,SCREEN_thickness+bezel_thickness])cube([PCB_width,PCB_height,box_size], center = true);
        translate([0,0,bezel_thickness])cube([SCREEN_width + shim, SCREEN_height + shim, box_size], center=true);
        translate([(VIEWABLE_offset-2)/2, 0, -0.1])cube([VIEWABLE_width, VIEWABLE_height, box_size],center=true);
        translate([-VIEWABLE_width/2+(VIEWABLE_offset-2)/2,-VIEWABLE_height/2,-box_size/2-0.05])polyhedron( TrapezoidPoints, TrapezoidFaces );    
        translate([0,0,-(box_size/2)+SCREEN_thickness]){
            translate([PCB_hole_width/2, PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
            translate([-PCB_hole_width/2, -PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
            translate([-PCB_hole_width/2, PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
            translate([PCB_hole_width/2, -PCB_hole_height/2])cylinder(h=5, r=1.5,$fn=20, center=true);
        }
        //TODO: add cutout for HDMI socket and thing
    }

}


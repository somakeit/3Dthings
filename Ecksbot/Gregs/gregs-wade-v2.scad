// Greg's Wade Extruder. 
// It is licensed under the Creative Commons - GNU GPL license. 
// © 2010 by GregFrost
// Extruder based on prusa git repo.
// http://www.thingiverse.com/thing:6713

include<configuration.scad>

// Define the hotend_mounting style you want by specifying hotend_mount=style1+style2 etc.
malcolm_hotend_mount=1;
groovemount=2;
peek_reprapsource_mount=4;
arcol_hotend_mount=8;//not yet supported.

//Set the hotend_mount to the sum of the hotends that you want the extruder to support:
//e.g. wade(hotend_mount=groovemount+peek_reprapsource_mount);

wade(hotend_mount=malcolm_hotend_mount);

translate([-15,34])
rotate([0,0,90])
wadeidler(); 

//===================================================
// Parameters defining the wade body:
wade_block_height=55;
wade_block_width=24;
wade_block_depth=28;

block_bevel_r=8;

base_thickness=7;
base_length=70;
base_leadout=25;

nema17_hole_spacing=1.2*25.4; 
nema17_width=1.7*25.4;
nema17_support_d=nema17_width-nema17_hole_spacing;

screw_head_recess_diameter=7.2;
screw_head_recess_depth=3;

motor_mount_rotation=25;
motor_mount_translation=[50.5,34,0];
motor_mount_thickness=12;

m8_clearance_hole=8.8;
hole_for_608=22.6;

block_top_right=[wade_block_width,wade_block_height];

filament_feed_hole_d=4;
filament_feed_hole_offset=3.5;
idler_nut_trap_depth=3;
idler_nut_thickness=4;

function motor_hole(hole)=
[motor_mount_translation[0],motor_mount_translation[1]]+
rotated(45+motor_mount_rotation+hole*90)*nema17_hole_spacing/sqrt(2);

gear_separation=7.4444+32.0111 +0.25;

module wade (hotend_mount=0)
{
	difference ()
	{
		union()
		{
			// The wade block.
			cube([wade_block_width,wade_block_height,wade_block_depth]);

			// Filler between wade block and motor mount.
			translate([10,motor_mount_translation[1]-hole_for_608/2,0])
			cube([wade_block_width,
				wade_block_height-motor_mount_translation[1]+hole_for_608/2,
				motor_mount_thickness]);

			// Connect block to top of motor mount.
			linear_extrude(height=motor_mount_thickness)
			barbell (block_top_right-[0,5],motor_hole(0),5,nema17_support_d/2,100,60);

			//Connect motor mount to base.
			linear_extrude(height=motor_mount_thickness)
			barbell ([base_length-base_leadout,
				base_thickness/2],motor_hole(2),base_thickness/2,
				nema17_support_d/2,100,60);

			// Round the ends of the base
			translate([base_length-base_leadout,base_thickness/2,0])
			cylinder(r=base_thickness/2,h=wade_block_depth,$fn=20);

			translate([-base_leadout,base_thickness/2,0])
			cylinder(r=base_thickness/2,h=wade_block_depth,$fn=20);

			//Provide the bevel betweeen the base and the wade block.
			render()
			difference()
			{
				translate([-block_bevel_r,0,0])
				cube([block_bevel_r*2+wade_block_width,
					base_thickness+block_bevel_r,wade_block_depth]);				
				translate([-block_bevel_r,block_bevel_r+base_thickness])
				cylinder(r=block_bevel_r,h=wade_block_depth);
				translate([wade_block_width+block_bevel_r,
					block_bevel_r+base_thickness])
				cylinder(r=block_bevel_r,h=wade_block_depth);
			}

			//The base.
			translate([-base_leadout,0,0])
			cube([base_length,base_thickness,wade_block_depth]);

			motor_mount ();

		}

		block_holes();
		motor_mount_holes ();

		translate([motor_mount_translation[0]-gear_separation-filament_feed_hole_offset,
			0,wade_block_depth/2])
		rotate([-90,0,0])
		{
			if (in_mask (hotend_mount,malcolm_hotend_mount))
				malcolm_hotend_holes ();
			if (in_mask (hotend_mount,groovemount))
				groovemount_holes ();
			if (in_mask (hotend_mount,peek_reprapsource_mount))
				peek_reprapsource_holes ();
		}
	}
}

function in_mask (mask,value) = (mask % (value*2)) > (value-1); 

module block_holes()
{
	//Round off the top of the block. 
	translate([0,wade_block_height-block_bevel_r,-1])
	render()
	difference()
	{
		translate([-1,0,0])
		cube([block_bevel_r+1,block_bevel_r+1,wade_block_depth+2]);
		translate([block_bevel_r,0,0])
		cylinder(r=block_bevel_r,h=wade_block_depth+2);
	}

	// Round the top front corner.
	translate ([-base_leadout-base_thickness/2,-1,wade_block_depth-block_bevel_r])
	render()
	difference() 
	{
		translate([-1,0,0])
		cube([block_bevel_r+1,base_thickness+2,block_bevel_r+1]);
		rotate([-90,0,0])
		translate([block_bevel_r,0,-1])
		cylinder(r=block_bevel_r,h=base_thickness+4);
	}

	// Round the top back corner.
	translate ([base_length-base_leadout+base_thickness/2-block_bevel_r,
		-1,wade_block_depth-block_bevel_r])
	render()
	difference() 
	{
		translate([0,0,0])
		cube([block_bevel_r+1,base_thickness+2,block_bevel_r+1]);
		rotate([-90,0,0])
		translate([0,0,-1])
		cylinder(r=block_bevel_r,h=base_thickness+4);
	}

	// Round the bottom front corner.
	translate ([-base_leadout-base_thickness/2,-1,-2])
	render()
	difference() 
	{
		translate([-1,0,-1])
		cube([block_bevel_r+1,base_thickness+2,block_bevel_r+1]);
		rotate([-90,0,0])
		translate([block_bevel_r,-block_bevel_r,-1])
		cylinder(r=block_bevel_r,h=base_thickness+4);
	}

	translate(motor_mount_translation)
	{
		translate([-gear_separation,0,0])
		{
%			rotate([0,180,0])
			translate([0,0,1])
			import_stl("wade-large.stl");

			// Open the top to remove overhangs and to provide access to the hobbing.
			translate([-wade_block_width+2,0,9.5])
			cube([wade_block_width,
				wade_block_height-motor_mount_translation[1]+1,
				wade_block_depth]);
		
			translate([0,0,-1])
			b608(h=9);
		
			translate([0,0,20])
			b608(h=9);
		
			translate([-13,0,9.5])
			b608(h=wade_block_depth);
		
			translate([0,0,9])
			cylinder(r=m8_clearance_hole/2,h=wade_block_depth-9+2);	

			// Filament feed.
			translate([-filament_feed_hole_offset,0,wade_block_depth/2])
			rotate([90,0,0])
			cylinder(r=filament_feed_hole_d/2,h=wade_block_depth*3,center=true);	

			// Mounting holes on the base.
			for (mount=[0:1])
			{
				translate([-filament_feed_hole_offset+25*((mount<1)?1:-1),
					-motor_mount_translation[1]-1,wade_block_depth/2])
				rotate([-90,0,0])
				cylinder(r=m4_diameter/2,h=base_thickness+2);	
	
				translate([-filament_feed_hole_offset+25*((mount<1)?1:-1),
					-motor_mount_translation[1]+base_thickness/2,
					wade_block_depth/2])
				rotate([-90,0,0])
				cylinder(r=m4_nut_diameter/2,h=base_thickness,$fn=6);	
			}

		}
%		translate([0,0,-8])
		import_stl("wade-small.stl");
	}


	// Idler mounting holes and nut traps.
	for (idle=[0:3])
	{
		translate([0,
			((idle<2)?-18:15)+motor_mount_translation[1],
			wade_block_depth/2+8*(((idle%2)==0)?1:-1)])
		rotate([0,90,0])
		{
			rotate([0,0,30])
			{
				translate([0,0,-1])
				cylinder(r=m4_diameter/2,h=wade_block_depth+6,$fn=6);	
				translate([0,0,wade_block_width+
					((idle>=2)?-7.5:-idler_nut_trap_depth)])
				cylinder(r=m4_nut_diameter/2,h=idler_nut_thickness,$fn=6);	
			}
			if (idle>=2)
			translate([0,10/2,wade_block_width-7.5+idler_nut_thickness/2])
			cube([m4_nut_diameter*cos(30),10,,idler_nut_thickness],center=true);
		}
	}
}

module motor_mount()
{
	linear_extrude(height=motor_mount_thickness)
	{
		barbell (motor_hole(0),motor_hole(1),nema17_support_d/2,
			nema17_support_d/2,20,160);
		barbell (motor_hole(1),motor_hole(2),nema17_support_d/2,
			nema17_support_d/2,20,160);
	}
}

module motor_mount_holes()
{
	radius=4/2;
	slot_left=1;
	slot_right=2;

	{
		translate([0,0,screw_head_recess_depth+0.5])
		for (hole=[0:2])
		{
			translate([motor_hole(hole)[0]-slot_left,motor_hole(hole)[1],0])
			cylinder(h=motor_mount_thickness-screw_head_recess_depth,r=radius,$fn=16);
			translate([motor_hole(hole)[0]+slot_right,motor_hole(hole)[1],0])
			cylinder(h=motor_mount_thickness-screw_head_recess_depth,r=radius,$fn=16);

			translate([motor_hole(hole)[0]-slot_left,motor_hole(hole)[1]-radius,0])
			cube([slot_left+slot_right,radius*2,motor_mount_thickness-screw_head_recess_depth]);
		}

		translate([0,0,-1])
		for (hole=[0:2])
		{
			translate([motor_hole(hole)[0]-slot_left,motor_hole(hole)[1],0])
			cylinder(h=screw_head_recess_depth+1,
				r=screw_head_recess_diameter/2,$fn=16);
			translate([motor_hole(hole)[0]+slot_right,motor_hole(hole)[1],0])
			cylinder(h=screw_head_recess_depth+1,
				r=screw_head_recess_diameter/2,$fn=16);

			translate([motor_hole(hole)[0]-slot_left,
				motor_hole(hole)[1]-screw_head_recess_diameter/2,0])
			cube([slot_left+slot_right,
				screw_head_recess_diameter,
				screw_head_recess_depth+1]);
		}
	}
}

// Parameters defining the idler.

corners_diameter = 3; 
corn_fn = corners_diameter*5;
height= 12;
608_dia = 12;
608_height = 9;
mounting_dist_short = 8;
mounting_dist_top = 18;
mounting_dist_bottom = 15;
mounting_dia = m4_diameter/2;
asym=mounting_dist_top-mounting_dist_bottom;
long_side = mounting_dist_top+mounting_dist_bottom+9;
short_side = 2*mounting_dist_short+9;

module wadeidler() 
{
	difference()
	{
		// Main block
		translate([-asym/2,0,0])
		union()
		{
			translate(v=[0,0,height/2]) 
			cube(size = [long_side,short_side-2*corners_diameter,height], center = true);
			translate(v=[0,0,height/2]) 
			cube(size = [long_side-2*corners_diameter,short_side,height], center = true);
			translate(v=[(long_side/2-corners_diameter),
				(short_side/2-corners_diameter),0]) 
			cylinder(h = height, r=corners_diameter, $fn = corn_fn);
			translate(v=[-(long_side/2-corners_diameter),
				(short_side/2-corners_diameter),0]) 
			cylinder(h = height, r=corners_diameter, $fn = corn_fn);
			translate(v=[(long_side/2-corners_diameter),
				-(short_side/2-corners_diameter),0]) 
			cylinder(h = height, r=corners_diameter, $fn = corn_fn);
			translate(v=[-(long_side/2-corners_diameter),
				-(short_side/2-corners_diameter),0]) 
			cylinder(h = height, r=corners_diameter, $fn = corn_fn);
		}
		// bearing cutout
		translate(v=[0,0,height-2])
		{
			rotate(a=[90,0,0]) cylinder(h = 608_height, r=608_dia, center=true);
			rotate(a=[90,0,0]) cylinder(h = short_side-2, r=m8_diameter/2, center=true);
		}
		//mounting holes
		translate(v=[-mounting_dist_top,mounting_dist_short,0]) 
		cylinder(h = height*2.1, r=mounting_dia, center=true,$fn = corn_fn);
		
		translate(v=[mounting_dist_bottom,mounting_dist_short,0]) 
		cylinder(h = height*2.1, r=mounting_dia, center=true,$fn = corn_fn);
		
		translate(v=[-mounting_dist_top,-mounting_dist_short,0]) 
		cylinder(h = height*2.1, r=mounting_dia, center=true,$fn = corn_fn);
		translate(v=[mounting_dist_bottom,-mounting_dist_short,0]) 
		cylinder(h = height*2.1, r=mounting_dia, center=true,$fn = corn_fn);
	}
}

module b608(h=8)
{
	translate([0,0,h/2]) cylinder(r=hole_for_608/2,h=h,center=true,$fn=60);
}

module barbell (x1,x2,r1,r2,r3,r4) 
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference ()
	{
		union()
		{
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}
		
		translate(x3)
		circle(r=r3,$fa=5);
		translate(x4)
		circle(r=r4,$fa=5);
	}
}

function triangulate (point1, point2, length1, length2) = 
point1 + 
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b)); 

function rotated(a)=[cos(a),sin(a),0];

//========================================================
// Modules for defining holes for hotend mounts:
// These assume the extruder is verical with the bottom filament exit hole at [0,0,0].

module malcolm_hotend_holes ()
{
	extruder_recess_d=16; 
	extruder_recess_h=3.5;

	// Recess in base
	translate([0,0,-1])
	cylinder(r=extruder_recess_d/2,h=extruder_recess_h+1);	
}

module groovemount_holes ()
{
	extruder_recess_d=16; 
	extruder_recess_h=5.5;

	// Recess in base
	translate([0,0,-1])
	cylinder(r=extruder_recess_d/2,h=extruder_recess_h+1);	
}

module peek_reprapsource_holes ()
{
	extruder_recess_d=11;
	extruder_recess_h=19; 

	// Recess in base
	translate([0,0,-1])
	cylinder(r=extruder_recess_d/2,h=extruder_recess_h+1);	

	// Mounting holes to affix the extruder into the recess.
	translate([0,0,min(extruder_recess_h/2, base_thickness)])
	rotate([-90,0,0])
	cylinder(r=m4_diameter/2-0.5/* tight */,h=wade_block_depth+2,center=true); 
}
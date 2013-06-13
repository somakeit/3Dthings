// Parabolic Arch Wall
// Created by Antony Furneaux
// 13/06/2013


// example where:
//  width of an arch = 8
//  depth of an arch = 10
//  hieght of the striaght verticle section = 7
//  hieght of the curved section = 6
//  thinkness of the wall = 1.4
//  max width of the arch wall = 30 (wall will be less than this unless exact fit)
//  max hieght of the arch wall = 44 (wall will be less than this unless exact fit)
//  add half an arch at each alternate line end = true
ArchWall(8,10,7,6,1.4, 30, 44, true);


module ArchWall(w, d, h1, h2, t, wall_width, wall_hieght, half_ends=false)
{  	
	link_h= (h1+h2)*0.9;
	link_w= (w-t);

	// Odd rows
	for ( b = [ 0 : (link_h*2) : wall_hieght-link_h ] )
	{
		for ( a = [ 0 : link_w : wall_width ] )
		{
			translate([a,0,b])
			Arch10(w, d, h1, h2, t);
		}
		if ( half_ends==true) {
			//echo( str("a_delta=", (floor(wall_width/link_w) * link_w) ));
			translate([(floor(wall_width/link_w) * link_w)+link_w,0,b+h1])
			scale([-1,1,1])
			halfArch10((w/2), d, h2, t);
		}
	}

	// Even rows
	for ( b2 = [ link_h : (link_h*2) : wall_hieght-link_h ] )
	{
		for ( a2 = [ (link_w/2) : link_w : wall_width ] )
		{
			translate([a2,0,b2])
			Arch10(w, d, h1, h2, t);
		}
		if ( half_ends==true) {
			translate([-link_w/2,0,b2+h1])
			halfArch10((w/2), d, h2, t);
		}
	}
}

module Arch10(w, d, h1, h2, t)
{
	hW= w/2;

	render(convexity = 2)
	{
		translate([hW-t,0,0])
		cube([t,d,h1]);
		translate([-hW,0,0])
		cube([t,d,h1]);
	
		translate([0,0,h1])
		halfArch10(hW, d, h2, t);
		translate([0,0,h1])
		scale([-1,1,1])
		halfArch10(hW, d, h2, t);
	}
}


module halfArch10(w, d, h, t)
{

 	for ( i = [0 : 1 : 8] )
	{
		//echo( str("                   i=",i ));
		render(convexity = 2)
		arch10Seg(w, d, h, t, step_n=i);
	}

};


module arch10Seg(w, d, h, t, step_n)
{
// outside step hieght
osh=h/10;
// inside step hieght
ish=(h-t)/10;

// outside width
osw=w;

// inside width
isw=w-t;

//sort out step values
step_nx=step_n+1;
invStep=10-step_n;
invStep_nx=10-step_nx;

//echo( str("step="),step_n,str("step_nx="),step_nx);
//echo( str("invStep="),invStep,str("invStep_nx="),invStep_nx );
//echo( str("norStep="),norStep,str("nxnorStep="),nxnorStep);

// Get log value of the step number (assuming 10)
//lstep = log(norStep);
//nlstep = log(nxnorStep);
lstep = log(invStep);
nlstep = log(invStep_nx);

//echo( str(" lstep="),lstep,str(" nlstep="),nlstep);

xows = osw * lstep;
xowns = osw * nlstep;

//echo( str(" xows="),xows,str(" xowns="),xowns);

xiws = isw * lstep;
xiwns = isw * nlstep;

//echo( str(" xiws="),xiws,str(" xiwns="),xiwns);



polyhedron(
  points=[  // the four points at this level step
          [xows,0,osh*step_n],[xows,d,osh*step_n],[xiws,d,ish*step_n],[xiws,0,ish*step_n],
				// the four points next at level step
          [xowns,0,osh*step_nx],[xowns,d,osh*step_nx],[xiwns,d,ish*step_nx],[xiwns,0,ish*step_nx],
			],
  triangles=[ [0,1,3],[3,1,2],             // two triangles for square base

              [0,7,4],[0,3,7],             // two triangles for front side
              [3,6,7],[3,2,6],             // two triangles for left side
              [0,5,1],[0,4,5],             // two triangles for right side
              [1,6,2],[1,5,6],             // two triangles for back side

					[4,7,5],[5,7,6],             // two triangles for square top
            ]
  );
};

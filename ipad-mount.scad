// Wall Mount for iPad (or other tablets)
//
// Current version sized for an OG iPad Air, see below
// 
// Fairly easy to customize but note there's some decent 
// amount of hacks especially around the screw holes depending
// on the overall frame thickness.

// ipad air (https://support.apple.com/kb/SP692)
ipad_w = 240; // landscape orientation
ipad_h = 169.5;
ipad_d = 7.5;

// wiggle room
wig_w = 1.5; 
wig_h = 4;
wig_d = 1.0; 

// frame thickness
ft_h = 4;
ft_w = 2;
ft_d = 2.5;

// distance case extends over ipad face
inset = 8;

// case height as fraction of width (landscape mode)
h_frac = 0.4;
h = ipad_h * h_frac;

// inset for wall mount screw locations
mount_w = 50;

// inside radius
rad_o = 3.0;


module wall_screw_hole() {
  // #6 Imperial Wood Screw
  screw_width = 4;
  screw_width2 = 11;
  screw_width3 = 6;
  screw_height = ft_d+.5;

  translate([0,0,0]) union() {
    // screw shaft
    cylinder(h=screw_height, d=screw_width, $fn=12);
    // countersink screw head space
    translate([0,0,screw_height/2-.7]) cylinder(h=screw_height/2+1.4, d1=screw_width3, d2=screw_width2, $fn=15);
  }
}

module wall_screw_holes() {
    // make a slot to allow for leveling
    for(i=[-5:2:05]) {
      translate([0,0,i]) rotate([-90,0,0]) wall_screw_hole();
    }
}

module case() {
  translate([0,0,ipad_h/2+ft_h])
    difference() {
      difference() { // main body
    
        // hacked a bit to allow for eased side edges
        d = ipad_d + ft_d*2 + wig_d;
        w = ipad_w + ft_w*2 + wig_w;
        h2 = ipad_h +ft_h*2 + wig_h;
        rotate([0,0,0]) translate([0,0,0-h2/2])
          linear_extrude(h2) {
            offset(r=rad_o, $fn=20)
            square([w-rad_o*2,d-rad_o*2], center = true);
        }
        
        // slot - TODO: maybe round this off as well w/offset?
        cube([ipad_w+ wig_w, ipad_d+wig_d, ipad_h+wig_h], center = true); 

        // front knockout
        translate([0,ipad_d/2+wig_d,0])
        cube([ipad_w - inset*2, ipad_d+wig_d+ft_d*1, ipad_h-inset*2], center = true); 

        // back knockout
        translate([0,-ipad_d/2-wig_d,0])
        cube([ipad_w - inset*2 - mount_w, ipad_d+wig_d+ft_d*3, ipad_h-inset*2], center = true);
        
        // top cutoff
        translate([0,0,h]) cube([ipad_w + ft_w*+10, ipad_d + wig_d + ft_d*2+1, ipad_h +ft_h*2], center = true);

      }
  
    // screw slots
    translate([ipad_w/2-mount_w/2+ft_w*3, -ipad_d/2-ft_d -wig_d, -35]) wall_screw_holes();
    translate([-ipad_w/2+mount_w/2-ft_w-8,  -ipad_d/2-ft_d -wig_d, -35]) rotate([0,90,0]) wall_screw_holes();
  }
}

case();

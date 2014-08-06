terminal_h = 1.5;
outer_slot_d = 17.75;
inner_slot_d = 14;
inner_slot_l = 103-terminal_h;
outer_slot_l = 130;
wired_d = 0.7;

module inner_slot() {
  translate([-1,0,0]) rotate(a=90, v=[0,1,0]) cylinder(d=inner_slot_d, h=inner_slot_l);
}
module outer_slot() {
  rotate(a=90, v=[0,1,0]) cylinder(d=outer_slot_d, h=outer_slot_l, $fn=50);
}
module terminal() {
  color("White") translate([inner_slot_l,0,0]) rotate(a=90, v=[0,1,0]) cylinder(d=6, h=terminal_h, $fn=50);
}
module slot() {
  difference() {
    outer_slot();
		inner_slot();
  }
	terminal();
}
//%slot();
//#terminal();

board_w = 11;
board_l = 63;
board_top_h = 5;
board_thickness = 1.5;
board_bottom_h = 3.5;
board_h = board_top_h + board_thickness + board_bottom_h;
module board() {
  translate([30,-board_w/2,-board_h/2])
    color("Brown") cube([board_l, board_w, board_h]);
  translate([30,-board_w/2,-board_h/2+board_bottom_h])
	  color("Yellow") cube([board_l, board_w, board_thickness]);
}
//board();

frame_h = 3 * board_thickness;
module frame_cutout_for_board() {
	translate([inner_slot_l*0.1/2, -board_w/2, -board_thickness])
		cube([inner_slot_l*0.9, board_w, frame_h]);
}
board_support_ratio = 0.85;
module frame_cutout_for_board_bottom() {
	translate([
		26+board_l*(1-board_support_ratio),
		-board_w/2+board_w*(1-board_support_ratio)/2,
		-board_h/2-board_h*0.1
	])
		cube([board_l*board_support_ratio, board_w*board_support_ratio, board_h*1.1]);
}

module frame() {
  difference() {
    union() {
	    translate([0,-inner_slot_d/2,-frame_h/2])
        cube([inner_slot_l, inner_slot_d, frame_h]);
		};
    frame_cutout_for_board();
frame_cutout_for_board_bottom();
		spring_cutout();
	  slot();
	}
}

module frame_teeth(side) {
  rotate(a=180*side, v=[0,0,1])
  translate([0,-inner_slot_d*1.1/2,-frame_h/2]) cube([1, inner_slot_d*1.1/2, frame_h]);
}
frame_teeth_cutout_w = inner_slot_d/2*1.3;
frame_teeth_cutout_h = inner_slot_d/2;
module frame_teeth_cutout() {
  translate([-1.1,-frame_teeth_cutout_w/2,-frame_teeth_cutout_h/2]) cube([10,frame_teeth_cutout_w,frame_teeth_cutout_h]);
}
module safety_tab() {
  translate([-8,-3/2,-frame_h/2]) cube([20,3,0.75]);
}
module the_whole_frame() {
union() {
	  difference() {
	  union() {
      frame();
      frame_teeth(1);
      frame_teeth(0);
    }
    frame_teeth_cutout();
	}
	safety_tab();
	}
}
the_whole_frame();

usb_cable_width = 3.75;
strain_relief_thickness = 4;
strain_relief_offset = 15;
strain_relief_width = inner_slot_d*3/4;
module strain_relief() {
  difference() {
	  union() {
      translate([strain_relief_offset,-strain_relief_width/2,-2])
	      cube([strain_relief_thickness,strain_relief_width,inner_slot_d/2+2]);
		}
	  slot();
		translate([strain_relief_offset-0.5,-usb_cable_width/2,-1])
   		cube([strain_relief_offset+1,usb_cable_width,inner_slot_d/2+1]);
  }
}
strain_relief();


spring_d = 1.25;
spring_cutout_w = 10;
spring_cutout_h = inner_slot_d/2;
module spring_cutout() {
  translate([inner_slot_l-10,-spring_d/2,0]) cube([spring_cutout_w,spring_d,spring_cutout_h]);
}

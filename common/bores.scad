include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

// use it with difference() function to 'bore' a whole into an object / plate
module bore(diameter = 4, depth = 10) {
    // protrude from surface to work around OpenSCAD quick render issue
    workaround_quick_render_issue_depth_offset = 0.01;

    union() {
        translate([0, 0, workaround_quick_render_issue_depth_offset]) cylinder(d = diameter, h = depth);
    }
}

// use it with difference() function to 'bore' a whole into an object / plate
module bore_sunk_head_screw(diameter = 4, depth = 10, sink_diameter = 8, sink_depth = 2, outer_sink_depth = 0) {
    
    // protrude from surface to work around OpenSCAD quick render issue
    workaround_quick_render_issue_depth_offset = 0.01;    
    outer_sink_depth = outer_sink_depth - workaround_quick_render_issue_depth_offset;
    sink_depth = sink_depth + workaround_quick_render_issue_depth_offset;
    
    union() {
        cylinder(d = diameter, h = depth);
        translate([0, 0, outer_sink_depth]) cylinder(d1 = sink_diameter, d2 = diameter, h = sink_depth);
    }
}

// use it with difference() function to 'bore' a whole into an object / plate
module bore_sunk_hex_nut_screw(
    diameter = 4,
    depth = 10,
    nut_size = 4, // M4 - actual outside diameter of an M4 nut is ~7mm
    sink_depth = 2 // Nuts come in different thicknesses. To get 'usual' thickness: https://github.com/revarbat/BOSL/wiki/metric_screws.scad#get_metric_nut_thickness
) {
    sink_depth = - get_metric_nut_thickness(size = nut_size) + sink_depth;

    union() {
        cylinder(d = diameter, h = depth);
        translate([0, 0, sink_depth]) metric_nut(size = nut_size, hole = false);
    }
}

translate([-20, 0, 0]) bore_sunk_head_screw();
translate([20, 0, 0]) bore_sunk_hex_nut_screw();

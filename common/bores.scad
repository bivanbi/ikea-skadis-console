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

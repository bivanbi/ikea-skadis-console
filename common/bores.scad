module bore_sunk_head_screw(diameter = 4, depth = 10, sink_diameter = 8, sink_depth = 2) {
    union() {
        cylinder(d = diameter, h = depth);
        cylinder(d1 = sink_diameter, d2 = diameter, h = sink_depth);
    }
}

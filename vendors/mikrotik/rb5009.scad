use <../../common/bores.scad>;
use <../ikea/skadis.scad>;

module rb5009_sunk_head_screw_bore() {
    bore_sunk_head_screw(diameter=5, sink_diameter=9, sink_depth=2);
}

module rb5009_plate_with_sunk_head_bores(thickness=5, height=50) {
    minimum_height = 50;
    hole_distance_x = 206;
    hole_distance_y = 22;

    hole_z_offset = -thickness / 2;
    height = max(minimum_height, height);
    plate_offset = height / 2 - minimum_height / 2;
    
    hole_offset_x = hole_distance_x / 2;
    hole_offset_y = hole_distance_y / 2;
    
    difference() {
        translate([0,plate_offset,0]) cube([220,height,thickness], center = true);

        translate([-hole_offset_x, -hole_offset_y, hole_z_offset]) rb5009_sunk_head_screw_bore();
        translate([-hole_offset_x, hole_offset_y, hole_z_offset]) rb5009_sunk_head_screw_bore();

        translate([hole_offset_x, -hole_offset_y, hole_z_offset]) rb5009_sunk_head_screw_bore();
        translate([hole_offset_x, hole_offset_y, hole_z_offset]) rb5009_sunk_head_screw_bore();
    }
}

module rb5009_skadis_hook_rotated_upside_down(thickness=5) {
    translate([0,0,-thickness/2])
    rotate([0,180,180])
        skadis_reinforced_hook_with_pin(reinforcement_granularity = 0.2);
}

module rb5009_plate_with_sunk_head_bores_skadis_hook(thickness=5, height=125) {
    hook_height = height - 35;
    
    union() {
        rb5009_plate_with_sunk_head_bores(thickness=thickness, height=height);
        
        translate([40,hook_height,0]) rb5009_skadis_hook_rotated_upside_down(thickness=thickness);
        translate([80,hook_height,0]) rb5009_skadis_hook_rotated_upside_down(thickness=thickness);
        translate([-40,hook_height,0]) rb5009_skadis_hook_rotated_upside_down(thickness=thickness);
        translate([-80,hook_height,0]) rb5009_skadis_hook_rotated_upside_down(thickness=thickness);
    }
}

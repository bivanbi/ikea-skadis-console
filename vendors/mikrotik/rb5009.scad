use <../../common/bores.scad>;
use <../ikea/skadis.scad>;

module rb5009_sunk_head_screw_bore(thickness=0) {
    translate([0, 0, thickness])
        rotate([180, 0, 0])
            bore_sunk_head_screw(diameter = 5, sink_diameter = 9, sink_depth = 2);
}

module rb5009_plate_with_sunk_head_bores(thickness = 5, height = 125, width = 220) {
    minimum_height = 50;
    bore_distance_x = 206;
    bore_distance_y = 22;
    
    bore_z_offset = 0;
    height = max(minimum_height, height);
    
    plate_center_x = width / 2;
    plate_minimum_center_y = minimum_height / 2;
    
    plate_offset_y = height / 2 - minimum_height / 2;
    
    bore_offset_x = bore_distance_x / 2;
    bore_offset_y = bore_distance_y / 2;

    bore_left_x = plate_center_x - bore_offset_x;
    bore_right_x = plate_center_x + bore_offset_x;
    
    bore_bottom_y = plate_minimum_center_y - bore_offset_y;
    bore_top_y = plate_minimum_center_y + bore_offset_y;

    
    difference() {
        translate([0,0,0]) cube([width,height,thickness]);

        translate([bore_left_x, bore_bottom_y, thickness]) rb5009_sunk_head_screw_bore();
        translate([bore_left_x, bore_top_y, thickness]) rb5009_sunk_head_screw_bore();

        translate([bore_right_x, bore_bottom_y, thickness]) rb5009_sunk_head_screw_bore();
        translate([bore_right_x, bore_top_y, thickness]) rb5009_sunk_head_screw_bore();
    }
}

module rb5009_plate_with_sunk_head_bores_skadis_hook(thickness = 5, height = 125, width = 220) {
    hook_offset_y = 15;
    
    skadis_hole_x_distance = 20;
    skadis_hole_y_distance = 20;
    
    plate_center_x = width / 2;

    outer_hook_offset_x = 5 * skadis_hole_x_distance;
    outer_hook_y = height - hook_offset_y;
    
    inner_hook_offset_x = 4 * skadis_hole_x_distance;
    inner_hook_y = outer_hook_y - skadis_hole_y_distance;
    
    outer_hook_left_x = plate_center_x - outer_hook_offset_x;
    inner_hook_left_x = outer_hook_left_x + skadis_hole_x_distance;
    
    outer_hook_right_x = plate_center_x + outer_hook_offset_x;
    inner_hook_right_x = outer_hook_right_x - skadis_hole_x_distance;
    

    union() {
        rb5009_plate_with_sunk_head_bores(thickness=thickness, height=height, width=width);
    
        translate([outer_hook_left_x, outer_hook_y, thickness]) skadis_reinforced_hook_with_pin(reinforcement_granularity = 0.2);
        translate([inner_hook_left_x, inner_hook_y, thickness]) skadis_reinforced_hook_with_pin(reinforcement_granularity = 0.2);

        translate([inner_hook_right_x, inner_hook_y, thickness]) skadis_reinforced_hook_with_pin(reinforcement_granularity = 0.2);
        translate([outer_hook_right_x, outer_hook_y, thickness]) skadis_reinforced_hook_with_pin(reinforcement_granularity = 0.2);
    }
}

rb5009_sunk_head_screw_bore();
translate([10, 0, 0]) rb5009_plate_with_sunk_head_bores();
translate([10, -150, 0]) rb5009_plate_with_sunk_head_bores_skadis_hook();

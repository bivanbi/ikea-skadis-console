use <../../common/bores.scad>;
use <../../common/plates.scad>;
use <../ikea/skadis.scad>;

function rb5009_width() = 220;
function rb5009_height() = 125;

function rb5009_bore_diameter() = 5;
function rb5009_bore_distance_x() = 206;
function rb5009_bore_distance_y() = 22;
function rb5009_bore_row1_y() = 14;
function rb5009_bore_row2_y() = rb5009_bore_row1_y() + rb5009_bore_distance_y(); 

plate_default_thickness = 5;
plate_minimum_height = 50;

module rb5009_sunk_head_screw_bore() {
        rotate([180, 0, 0])
            bore_sunk_head_screw(diameter = rb5009_bore_diameter(), sink_diameter = 9, sink_depth = 2);
}

module rb5009_plate_with_sunk_head_bores(thickness = plate_default_thickness, height = rb5009_height(), width = rb5009_width()) {
    height = max(plate_minimum_height, height);
    
    plate_center_x = width / 2;
    bore_offset_x = rb5009_bore_distance_x() / 2;
    bore_left_x = plate_center_x - bore_offset_x;
    bore_right_x = plate_center_x + bore_offset_x;
        
    difference() {
        plate_rounded_corners(w = width, h = height, t = thickness);

        translate([bore_left_x, rb5009_bore_row1_y(), thickness]) rb5009_sunk_head_screw_bore();
        translate([bore_left_x, rb5009_bore_row2_y(), thickness]) rb5009_sunk_head_screw_bore();

        translate([bore_right_x, rb5009_bore_row1_y(), thickness]) rb5009_sunk_head_screw_bore();
        translate([bore_right_x, rb5009_bore_row2_y(), thickness]) rb5009_sunk_head_screw_bore();
    }
}

module rb5009_plate_with_sunk_head_bores_skadis_hook(thickness = plate_default_thickness, height = rb5009_height(), width = rb5009_width()) {
    hook_offset_y = 15;
    
    plate_center_x = width / 2;

    outer_hook_offset_x = 5 * skadis_hole_x_distance();
    outer_hook_y = height - hook_offset_y;
    
    inner_hook_offset_x = 4 * skadis_hole_x_distance();
    inner_hook_y = outer_hook_y - skadis_hole_y_distance();
    
    outer_hook_left_x = plate_center_x - outer_hook_offset_x;
    inner_hook_left_x = outer_hook_left_x + skadis_hole_x_distance();
    
    outer_hook_right_x = plate_center_x + outer_hook_offset_x;
    inner_hook_right_x = outer_hook_right_x - skadis_hole_x_distance();

    union() {
        rb5009_plate_with_sunk_head_bores(thickness=thickness, height=height, width=width);
    
        translate([outer_hook_left_x, outer_hook_y, thickness]) skadis_reinforced_hook_with_pin();
        translate([inner_hook_left_x, inner_hook_y, thickness]) skadis_reinforced_hook_with_pin();

        translate([inner_hook_right_x, inner_hook_y, thickness]) skadis_reinforced_hook_with_pin();
        translate([outer_hook_right_x, outer_hook_y, thickness]) skadis_reinforced_hook_with_pin();
    }
}

rb5009_sunk_head_screw_bore();
translate([10, 0, 0]) rb5009_plate_with_sunk_head_bores();
translate([10, -150, 0]) rb5009_plate_with_sunk_head_bores_skadis_hook();

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


plate_center_x = rb5009_width() / 2;
bore_offset_x = rb5009_bore_distance_x() / 2;
bore_left_x = plate_center_x - bore_offset_x;
bore_right_x = plate_center_x + bore_offset_x;

hook_offset_from_top = 15;
outer_hook_offset_x = 5 * skadis_hole_x_distance();
inner_hook_offset_x = 4 * skadis_hole_x_distance();
outer_hook_left_x = plate_center_x - outer_hook_offset_x;
inner_hook_left_x = outer_hook_left_x + skadis_hole_x_distance();

module rb5009_sunk_head_screw_bore() {
        rotate([180, 0, 0])
            bore_sunk_head_screw(diameter = rb5009_bore_diameter(), sink_diameter = 9, sink_depth = 2);
}

module rb5009_plate_with_sunk_head_bores(t = plate_default_thickness, h = rb5009_height()) {
    height = max(plate_minimum_height, h);
    
    difference() {
        plate_rounded_corners(w = rb5009_width(), h = height, t = t);

        translate([bore_left_x, rb5009_bore_row1_y(), t]) rb5009_sunk_head_screw_bore();
        translate([bore_left_x, rb5009_bore_row2_y(), t]) rb5009_sunk_head_screw_bore();

        translate([bore_right_x, rb5009_bore_row1_y(), t]) rb5009_sunk_head_screw_bore();
        translate([bore_right_x, rb5009_bore_row2_y(), t]) rb5009_sunk_head_screw_bore();
    }
}

module rb5009_skadis_hooks(t = plate_default_thickness, h = rb5009_height()) {
    outer_hook_y = h - hook_offset_from_top;
    
    inner_hook_y = outer_hook_y - skadis_hole_y_distance();
    
    outer_hook_right_x = plate_center_x + outer_hook_offset_x;
    inner_hook_right_x = outer_hook_right_x - skadis_hole_x_distance();

    translate([outer_hook_left_x, outer_hook_y, t]) skadis_reinforced_hook_with_pin();
    translate([inner_hook_left_x, inner_hook_y, t]) skadis_reinforced_hook_with_pin();

    translate([inner_hook_right_x, inner_hook_y, t]) skadis_reinforced_hook_with_pin();
    translate([outer_hook_right_x, outer_hook_y, t]) skadis_reinforced_hook_with_pin();
}

module rb5009_lightweight_plate_holes(t, h, w) {
    hollow_distance_from_edge = 15;
    openscad_quickrender_bug_workaround_factor = 1;
    
    hollow_outer_offset_x = inner_hook_offset_x - hollow_distance_from_edge / 2;
    hollow_inner_offset_x = hollow_distance_from_edge / 2;

    hollow_bottom_y = hollow_distance_from_edge;
    hollow_height = h - 2 * hollow_distance_from_edge;
    
    t = t + 2 * openscad_quickrender_bug_workaround_factor;
    z = -openscad_quickrender_bug_workaround_factor;
    
    hollow_left_x = plate_center_x - hollow_outer_offset_x;
    hollow_right_x = plate_center_x + hollow_distance_from_edge / 2;

    hollow_width = plate_center_x - hollow_left_x - hollow_distance_from_edge / 2;
    
    translate([hollow_left_x, hollow_bottom_y, z]) plate_rounded_corners(w = hollow_width, h = hollow_height, t = t);
    
    translate([hollow_right_x, hollow_bottom_y, z]) plate_rounded_corners(w = hollow_width, h = hollow_height, t = t);
}

module rb5009_plate_with_sunk_head_bores_skadis_hook(t = plate_default_thickness, h = rb5009_height(), w = rb5009_width()) {
        
    union() {
        rb5009_plate_with_sunk_head_bores(t = t, h = h);
        rb5009_skadis_hooks(h = h, t = t);
    }
}

module rb5009_lightweight_plate_with_sunk_head_bores_skadis_hook(t = plate_default_thickness, h = rb5009_height(), w = rb5009_width()) {
    difference() {
        rb5009_plate_with_sunk_head_bores_skadis_hook(t = t, h = h, w = w);
        rb5009_lightweight_plate_holes(t = t, h = h, w = w);
    }
}

module rb5009_halfplate_for_skadis_hook_left(t = plate_default_thickness, h = rb5009_height()) {
    width = inner_hook_left_x + outer_hook_left_x;
    r = 3;
    corner_diameter = r * 2;
    
    top_right_x = outer_hook_left_x * 2 - r;
    outer_hook_y = h - hook_offset_from_top;
    inner_hook_y = h - skadis_hole_y_distance();
    inner_hook_upper_x = inner_hook_left_x + outer_hook_left_x - r;
    pin_y = inner_hook_y - hook_offset_from_top - skadis_hole_y_distance() * 2;
    
    bottom_right_x = 15 - r;

    hull() {
        translate([0 + r, 0 + r, 0]) cylinder(h = t, r = r);
        translate([0 + r, h - r, 0]) cylinder(h = t, r = r);
        translate([top_right_x, h - r, 0]) cylinder(h = t, r = r);
        translate([inner_hook_upper_x, inner_hook_y - r, 0]) cylinder(h = t, r = r);
        translate([inner_hook_upper_x, pin_y - r, 0]) cylinder(h = t, r = r);
        
        translate([bottom_right_x, 0 + r, 0]) cylinder(h = t, r = r);
    }
}

module rb5009_halfplate_with_sunk_head_bores_skadis_hook_left(t = plate_default_thickness, h = rb5009_height()) {
    outer_hook_y = h - hook_offset_from_top;
    inner_hook_y = outer_hook_y - skadis_hole_y_distance();

    width = inner_hook_left_x + outer_hook_left_x;

    union() {
        difference() {
            rb5009_halfplate_for_skadis_hook_left(h = h, t = t);
           
            translate([bore_left_x, rb5009_bore_row1_y(), t]) rb5009_sunk_head_screw_bore();
            translate([bore_left_x, rb5009_bore_row2_y(), t]) rb5009_sunk_head_screw_bore();
        }
        
        translate([outer_hook_left_x, outer_hook_y, t]) skadis_reinforced_hook_with_pin();
        translate([inner_hook_left_x, inner_hook_y, t]) skadis_reinforced_hook_with_pin();
    }
}

module rb5009_halfplate_with_sunk_head_bores_skadis_hook_right(t = plate_default_thickness, h = rb5009_height()) {
    outer_hook_left_x = plate_center_x - outer_hook_offset_x;
    inner_hook_left_x = outer_hook_left_x + skadis_hole_x_distance();
    width = inner_hook_left_x + outer_hook_left_x;

    translate([width, 0,0]) mirror([1, 0, 0]) rb5009_halfplate_with_sunk_head_bores_skadis_hook_left(t = t, h = h);
}

color("lightblue") translate([0, 0, 0]) rb5009_plate_with_sunk_head_bores();
color("lightgreen") translate([0, -150, 0]) rb5009_plate_with_sunk_head_bores_skadis_hook();
color("orange") translate([0, -300, 0]) rb5009_lightweight_plate_with_sunk_head_bores_skadis_hook();

color("lightgray") translate([0, -450, 0]) rb5009_halfplate_with_sunk_head_bores_skadis_hook_left();
color("white") translate([60, -450, 0]) rb5009_halfplate_with_sunk_head_bores_skadis_hook_right();

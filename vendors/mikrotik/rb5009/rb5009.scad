use <../../../common/bores.scad>;
use <../../../common/plates.scad>;
use <../../../common/text.scad>;
use <../../ikea/skadis.scad>;

function rb5009_width() = 220;
function rb5009_height() = 125;
function rb5009_height_without_heatsink() = 102;

function rb5009_bore_diameter() = 5;
function rb5009_hex_nut_size() = 4; // M4
function rb5009_hex_nut_thickness() = 3;

function rb5009_bore_distance_x() = 206;
function rb5009_bore_distance_y() = 22;
function rb5009_bore_row1_y() = 14;
function rb5009_bore_row2_y() = rb5009_bore_row1_y() + rb5009_bore_distance_y(); 

plate_default_thickness = 6;
plate_minimum_height = 50;

plate_center_x = rb5009_width() / 2;
bore_offset_x = rb5009_bore_distance_x() / 2;
bore_left_x = plate_center_x - bore_offset_x;
bore_right_x = plate_center_x + bore_offset_x;

hook_offset_from_top = 15;
outer_hook_offset_x = 5 * skadis_hole_x_distance();
inner_hook_offset_x = 3 * skadis_hole_x_distance();
outer_hook_left_x = plate_center_x - outer_hook_offset_x;
inner_hook_left_x = plate_center_x - inner_hook_offset_x;

openscad_quickrender_bug_workaround_factor = 1;

default_font_size = 6;
default_font = "Arial:style=Bold";

function hook_y(h) = h - hook_offset_from_top;
function pin_y(h) = hook_y(h) - skadis_hook_pin_distance();

module rb5009_sunk_head_screw_bore() {
        rotate([180, 0, 0])
            bore_sunk_head_screw(diameter = rb5009_bore_diameter(), sink_diameter = 9, sink_depth = 2);
}

module rb5009_sink_hex_nut_screw_bore() {
        rotate([180, 0, 30])
            bore_sunk_hex_nut_screw(diameter = rb5009_bore_diameter(), nut_size = rb5009_hex_nut_size(), sink_depth = rb5009_hex_nut_thickness());
}

module rb5009_carved_text(t = plate_default_thickness, s = default_font_size, f = default_font, text = "rb5009") {
    text_carved(text = text, z = t, s = s, f = f);
}

module rb5009_plate_with_sunk_head_bores(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {
    height = max(plate_minimum_height, h);
    
    text_x = bore_left_x + 10;
    text_y = 10;
    
    difference() {
        plate_rounded_corners(w = rb5009_width(), h = height, t = t);

        translate([bore_left_x, rb5009_bore_row1_y(), t]) rb5009_sink_hex_nut_screw_bore();
        translate([bore_left_x, rb5009_bore_row2_y(), t]) rb5009_sink_hex_nut_screw_bore();

        translate([bore_right_x, rb5009_bore_row1_y(), t]) rb5009_sink_hex_nut_screw_bore();
        translate([bore_right_x, rb5009_bore_row2_y(), t]) rb5009_sink_hex_nut_screw_bore();
        
        translate([text_x, text_y, 0]) rb5009_carved_text(t = t);
    }
}

module rb5009_skadis_hooks(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {
    
    outer_hook_right_x = plate_center_x + outer_hook_offset_x;
    inner_hook_right_x = plate_center_x + inner_hook_offset_x;

    translate([outer_hook_left_x, hook_y(h), t]) skadis_reinforced_hook_with_pin();
    translate([inner_hook_left_x, hook_y(h), t]) skadis_reinforced_hook_with_pin();

    translate([inner_hook_right_x, hook_y(h), t]) skadis_reinforced_hook_with_pin();
    translate([outer_hook_right_x, hook_y(h), t]) skadis_reinforced_hook_with_pin();
}

module rb5009_lightweight_plate_holes(t, h, w) {
    hollow_distance_from_edge = 15;
    
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

module rb5009_plate_with_sunk_head_bores_skadis_hook(t = plate_default_thickness, h = rb5009_height_without_heatsink(), w = rb5009_width()) {
        
    union() {
        rb5009_plate_with_sunk_head_bores(t = t, h = h);
        rb5009_skadis_hooks(h = h, t = t);
    }
}

module rb5009_lightweight_plate_with_sunk_head_bores_skadis_hook(t = plate_default_thickness, h = rb5009_height_without_heatsink(), w = rb5009_width()) {
    difference() {
        rb5009_plate_with_sunk_head_bores_skadis_hook(t = t, h = h, w = w);
        rb5009_lightweight_plate_holes(t = t, h = h, w = w);
    }
}

module rb5009_halfplate_for_skadis_hook_left(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {
    width = inner_hook_left_x + outer_hook_left_x;
    r = 9;
    
    top_right_x = inner_hook_left_x;
    inner_hook_x = inner_hook_left_x;
    inner_edge_x = inner_hook_x;
    
    bottom_right_x = 15 - r;

    hull() { // corners from bottom left clockwise
        translate([0 + r, 0 + r, 0]) cylinder(h = t, r = r); // bottom left corner        
        translate([0 + r, h - r, 0]) cylinder(h = t, r = r); // top left corner
        translate([inner_edge_x, h - r, 0]) cylinder(h = t, r = r); // top right corner
        translate([inner_edge_x, pin_y(h) - r, 0]) cylinder(h = t, r = r); // right pin corner
    }
}

module rb5009_halfplate_square_hollow_left(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {
    w = skadis_hole_x_distance();
    x = outer_hook_left_x + w / 2;
    y = pin_y(h);

    t = t + 2 * openscad_quickrender_bug_workaround_factor;
    z = -openscad_quickrender_bug_workaround_factor;

    translate([x, y, z]) plate_rounded_corners(w = w, h = skadis_hook_pin_distance(), t = t);

}

module rb5009_halfplate_with_sunk_head_bores_skadis_hook_left_notext(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {

    width = inner_hook_left_x + outer_hook_left_x;
    
    hollow_width = skadis_hole_x_distance();
    hollow_x = outer_hook_left_x + hollow_width / 2;
    hollow_y = pin_y(h);
    quick_render_bug_workaround = 0.1;

    union() {
        difference() {
            rb5009_halfplate_for_skadis_hook_left(h = h, t = t);
           
            translate([bore_left_x, rb5009_bore_row1_y(), t]) rb5009_sink_hex_nut_screw_bore();
            translate([bore_left_x, rb5009_bore_row2_y(), t]) rb5009_sink_hex_nut_screw_bore();
            
            rb5009_halfplate_square_hollow_left();
        }
        
        translate([outer_hook_left_x, hook_y(h), t]) skadis_reinforced_hook_with_pin();
        translate([inner_hook_left_x, hook_y(h), t]) skadis_reinforced_hook_with_pin();
    }
}

module rb5009_halfplate_with_sunk_head_bores_skadis_hook_left(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {
    
    rb5009_text_x = bore_left_x + 10;
    rb5009_text_y = pin_y(h) - 10;
    
    side_text_hook_distance = 3;
    outside_text_x = outer_hook_left_x - side_text_hook_distance;
    outside_text_y = pin_y(h);
    inside_text_x = inner_hook_left_x + side_text_hook_distance;
    inside_text_y = hook_y(h);
    inside_text = "↑inside↑";
    outside_text = "↑outside↑";
    side_text_size = 5;
    
    difference() {
        rb5009_halfplate_with_sunk_head_bores_skadis_hook_left_notext(t = t, h = h);
        translate([rb5009_text_x, rb5009_text_y, 0]) rb5009_carved_text(t = t);
        translate([outside_text_x, outside_text_y, 0]) rotate([0, 0, 90]) rb5009_carved_text(t = t, text = outside_text, s = side_text_size);
        translate([inside_text_x, inside_text_y, 0]) rotate([0, 0, -90]) rb5009_carved_text(t = t, text = inside_text, s = side_text_size);

    }
}

module rb5009_halfplate_with_sunk_head_bores_skadis_hook_right(t = plate_default_thickness, h = rb5009_height_without_heatsink()) {
    inner_hook_left_x = plate_center_x - outer_hook_offset_x;
    outer_hook_left_x = inner_hook_left_x + skadis_hole_x_distance() * 2;
    width = inner_hook_left_x + outer_hook_left_x;
 
    side_text_hook_distance = 3;
    outside_text_x = outer_hook_left_x + side_text_hook_distance;
    outside_text_y = hook_y(h);
    inside_text_x = inner_hook_left_x - side_text_hook_distance;
    inside_text_y = pin_y(h);
    inside_text = "↑inside↑";
    outside_text = "↑outside↑";
    side_text_size = 5;

    rb5009_text_x = bore_left_x + 10;
    rb5009_text_y = pin_y(h) - 10;

    difference() {
        translate([width, 0, 0]) mirror([1, 0, 0]) rb5009_halfplate_with_sunk_head_bores_skadis_hook_left_notext(t = t, h = h);
        translate([rb5009_text_x, rb5009_text_y, 0]) rb5009_carved_text(t = t);
        translate([outside_text_x, outside_text_y, 0]) rotate([0, 0, -90]) rb5009_carved_text(t = t, text = outside_text, s = side_text_size);
        translate([inside_text_x, inside_text_y, 0]) rotate([0, 0, 90]) rb5009_carved_text(t = t, text = inside_text, s = side_text_size);

    }
}

color("lightblue") translate([0, 0, 0]) rb5009_plate_with_sunk_head_bores();
color("lightgreen") translate([0, -150, 0]) rb5009_plate_with_sunk_head_bores_skadis_hook();
color("orange") translate([0, -300, 0]) rb5009_lightweight_plate_with_sunk_head_bores_skadis_hook();

color("lightgray") translate([0, -450, 0]) rb5009_halfplate_with_sunk_head_bores_skadis_hook_left();
color("white") translate([160, -450, 0]) rb5009_halfplate_with_sunk_head_bores_skadis_hook_right();

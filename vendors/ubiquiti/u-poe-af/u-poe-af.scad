use <../../../common/plates.scad>;
use <../../../common/bores.scad>;
use <../../../common/text.scad>;
use <../../ikea/skadis.scad>;

function u_poe_af_length() = 86.5; // mm
function u_poe_af_width() = 46.5;

function u_poe_af_screw_bore_diameter() = 3;
function u_poe_af_screw_bore_depth() = 15;
function u_poe_af_screw_bore_distance() = 74;

function u_poe_af_baseplate_thickness() = 5;
function u_poe_af_baseplate_rounded_corner_r() = 3;

module ubiquiti_u_poe_af_baseplate_bores() {
    bump_depth = u_poe_af_screw_bore_depth() - u_poe_af_baseplate_thickness() + 1; // safety
    depth = u_poe_af_screw_bore_depth() * 3;
    offset_y = u_poe_af_width() / 2;
    left_offset_x = u_poe_af_length() / 2 - u_poe_af_screw_bore_distance() / 2;
    right_offset_x = u_poe_af_length() / 2 + u_poe_af_screw_bore_distance() / 2;

    offset_z = - bump_depth - 3;

    translate([left_offset_x, offset_y, offset_z])
        bore(diameter = u_poe_af_screw_bore_diameter(), depth = depth );
    translate([right_offset_x, offset_y, offset_z])
        bore(diameter = u_poe_af_screw_bore_diameter(), depth = depth);
}

module ubiquiti_u_poe_af_baseplate() {
    bore_offset_y = u_poe_af_width() / 2;
    bore_left_offset_x = u_poe_af_length() / 2 - u_poe_af_screw_bore_distance() / 2;
    bore_right_offset_x = u_poe_af_length() / 2 + u_poe_af_screw_bore_distance() / 2;
    union() {
        plate_rounded_corners(w = u_poe_af_length(), h = u_poe_af_width(), r = u_poe_af_baseplate_rounded_corner_r());
        ubiquiti_u_poe_af_baseplate_bump();
    }
}

module ubiquiti_u_poe_af_baseplate_bump() {
    bump_depth = u_poe_af_screw_bore_depth() - u_poe_af_baseplate_thickness() + 1; // safety

    bump_width = u_poe_af_width() - 2 * u_poe_af_baseplate_rounded_corner_r();
    bump_length = 10;
    bump_offset_y = u_poe_af_width() / 2 - bump_width / 2;
    bump_left_offset_x = u_poe_af_length() / 2 - u_poe_af_screw_bore_distance() / 2 - bump_length / 2;
    bump_right_offset_x = u_poe_af_length() / 2 + u_poe_af_screw_bore_distance() / 2 - bump_length / 2;
    bump_offset_z = - bump_depth;

    color("red")
    translate([bump_left_offset_x, bump_offset_y, bump_offset_z])
        cube([bump_length, bump_width, bump_depth]);
    color("red")
    translate([bump_right_offset_x, bump_offset_y, bump_offset_z])
        cube([bump_length, bump_width, bump_depth]);
}

module ubiquiti_u_poe_af_console() {
    left_skadis_hook_offset_x = u_poe_af_length() / 2 - 2 * skadis_hole_x_distance();
    right_skadis_hook_offset_x = u_poe_af_length() / 2 + 2 * skadis_hole_x_distance();
    skadis_hook_offset_y = u_poe_af_width() / 2 + skadis_hook_pin_distance() / 2;

    union() {
        difference() {
            ubiquiti_u_poe_af_baseplate();
            ubiquiti_u_poe_af_baseplate_bores();
    }

        // skadis hooks
        translate([left_skadis_hook_offset_x, skadis_hook_offset_y, u_poe_af_baseplate_thickness()])
            skadis_reinforced_hook_with_pin();
        translate([right_skadis_hook_offset_x, skadis_hook_offset_y, u_poe_af_baseplate_thickness()])
            skadis_reinforced_hook_with_pin();
    }
}

ubiquiti_u_poe_af_console();

use <../../../common/plates.scad>;
use <../../../common/text.scad>;
use <../../ikea/skadis.scad>;

function vigor165_width() = 181; // mm
function vigor165_height() = 125;
function vigor165_width_at_feet() = 170;
function vigor165_height_at_feet() = 94;

function vigor165_mount_hole_distance_x() = 139;
function vigor165_mount_hole_distance_y() = 54;
function vigor165_mount_screw_cutaway_vs_hole_distance_y() = 63.3; // When screw is slid into its slot on one side, the distance to the other mount hole
function vigor165_mount_hole_diameter() = 9;
function vigor165_mount_hole_diameter_clearance() = 0.3;
function vigor165_mount_screw_diameter() = 4;
function vigor165_mount_screw_diameter_clearance() = 0.2;

function vigor165_mount_hole_depth_from_foot() = 11;
function vigor165_mount_hole_depth() = 4.5;
function vigor165_mount_hole_wall_thickness() = 2;
function vigor165_mount_hook_head_thickness_clearance() = 0.3;

function vigor165_mount_hook_head_diameter() = vigor165_mount_hole_diameter() - vigor165_mount_hole_diameter_clearance();
function vigor165_mount_hook_head_thickness() = vigor165_mount_hole_depth() - vigor165_mount_hole_wall_thickness() - vigor165_mount_hook_head_thickness_clearance();
function vigor165_mount_hook_neck_diameter() = vigor165_mount_screw_diameter() - vigor165_mount_screw_diameter_clearance();
function vigor165_mount_hook_neck_length() = vigor165_mount_hole_depth_from_foot() - vigor165_mount_hook_head_thickness() + vigor165_mount_screw_diameter_clearance() / 2;

function vigor165_plate_thickness() = 5;

function vigor165_text_font_size() = 6; // points
function vigor165_text_font_face() = "Arial:style=Bold";
function vigor165_text() = "Vigor165";

module vigor165_mount_hook() {
    hook_neck_reinforcement_offset_y = - vigor165_mount_hook_head_diameter() / 2 + vigor165_mount_hook_neck_diameter() / 2;
    hook_neck_base_offset_z = vigor165_mount_hook_head_thickness() + vigor165_mount_hole_wall_thickness() + 3;
    hook_neck_base_length = vigor165_mount_hook_neck_length() - hook_neck_base_offset_z;
    union() {
        translate([0, 0, hook_neck_base_offset_z]) linear_extrude(5) circle(d = vigor165_mount_hook_head_diameter());
        linear_extrude(vigor165_mount_hook_head_thickness()) circle(d = vigor165_mount_hook_head_diameter());
        translate([0, 0, vigor165_mount_hook_head_thickness()]) linear_extrude(vigor165_mount_hook_neck_length()) hull() {
            circle(d = vigor165_mount_hook_neck_diameter());
            translate([0, hook_neck_reinforcement_offset_y, 0]) circle(d = vigor165_mount_hook_neck_diameter());
        }
    }
}

module vigor165_mount_stopper() {
    linear_extrude(vigor165_mount_hook_head_thickness() + vigor165_mount_hook_neck_length()) circle(d = vigor165_mount_hook_head_diameter());
}

module vigor165_carved_text() {
    text_carved(text = vigor165_text(), z = vigor165_plate_thickness(), s = vigor165_text_font_size(), f = vigor165_text_font_face(), halign = "center", valign = "center");
}

module vigor165_x_frame() {
    horizontal_frame_edge_width = 20;
    vertical_frame_edge_width = 30;
    frame_h = vigor165_mount_screw_cutaway_vs_hole_distance_y() + horizontal_frame_edge_width;

    mount_stopper_offset_y = horizontal_frame_edge_width / 2;
    mount_hole_offset_y = mount_stopper_offset_y + vigor165_mount_screw_cutaway_vs_hole_distance_y();
    mount_hole_distance_from_edge_x = (vigor165_width_at_feet() - vigor165_mount_hole_distance_x()) / 2;
    vigor165_mount_offset_z = - vigor165_mount_hole_depth_from_foot();
    mount_right_offset_x = vigor165_width_at_feet() - mount_hole_distance_from_edge_x;

    left_mount_stopper = [mount_hole_distance_from_edge_x, mount_stopper_offset_y, vigor165_mount_offset_z];
    left_mount_hole = [mount_hole_distance_from_edge_x, mount_hole_offset_y, vigor165_mount_offset_z];

    right_mount_stopper = [mount_right_offset_x, mount_stopper_offset_y, vigor165_mount_offset_z];
    right_mount_hole = [mount_right_offset_x, mount_hole_offset_y, vigor165_mount_offset_z];

    left_skadis_hook_offset_x = vigor165_width_at_feet() / 2 - 3 * skadis_hole_x_distance();
    right_skadis_hook_offset_x = vigor165_width_at_feet() / 2 + 3 * skadis_hole_x_distance();
    skadis_hook_offset_y = frame_h - 10;

    text_offset_x = vigor165_width_at_feet() / 2;
    text_offset_y = frame_h - horizontal_frame_edge_width / 2;

    difference() {
        union() {
            frame_x_rounded_corners(h = frame_h, w = vigor165_width_at_feet(), t = vigor165_plate_thickness(), lew = vertical_frame_edge_width, tew = horizontal_frame_edge_width, bew = horizontal_frame_edge_width, rew = vertical_frame_edge_width);

            // Vigor mount hooks / stoppers
            translate(left_mount_stopper) vigor165_mount_stopper();
            translate(left_mount_hole) vigor165_mount_hook();
            translate(right_mount_stopper) vigor165_mount_stopper();
            translate(right_mount_hole) vigor165_mount_hook();

            // skadis hooks
            translate([left_skadis_hook_offset_x, skadis_hook_offset_y, vigor165_plate_thickness()])
                skadis_reinforced_hook_with_pin();
            translate([right_skadis_hook_offset_x, skadis_hook_offset_y, vigor165_plate_thickness()])
                skadis_reinforced_hook_with_pin();
        }
        translate([text_offset_x, text_offset_y, 0]) vigor165_carved_text();
    }
}
vigor165_x_frame();

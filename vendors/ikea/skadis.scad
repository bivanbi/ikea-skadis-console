// holes are 'diagonal' on the board; adjacent columns / rows are offset by 
function skadis_hole_x_distance() = 20;
function skadis_hole_y_distance() = 20;
function skadis_hole_diameter() = 5;
function skadis_board_thickness() = 5;

function skadis_hook_diameter_clearance() = 0.1; // clearance for easier mounting
function skadis_hook_loose_fit() = 0.5; // too tight fit might lead to chopped hook
function skadis_hook_pin_distance() = 33; // allow a little play for easier mounting

module skadis_pin(height = skadis_board_thickness(), diameter = skadis_hole_diameter()) {
    radius = diameter / 2;
    union() {
        cylinder(r = radius, h = height - radius);
        translate([0, 0, height - radius]) sphere(r = radius);
    }
}

module skadis_hook_curve(pin_diameter = skadis_hole_diameter(), hook_curve_radius = 3) {
    translate([0,-hook_curve_radius,0])
    rotate([0,-90,0])
        rotate_extrude(angle=90)
            translate([hook_curve_radius,0,0])
                circle(d = pin_diameter);
}

module skadis_basic_hook(
    board_thickness = skadis_board_thickness(),
    hook_loose_fit = skadis_hook_loose_fit(),
    diameter = skadis_hole_diameter(),
    hook_curve_radius = 4,
    hook_pin_length = 6
) {
    diameter = diameter - skadis_hook_diameter_clearance();
    pin_radius = diameter / 2;
    
    hook_curve_offset = board_thickness + pin_radius + hook_loose_fit - hook_curve_radius;
    hook_pin_body_length = hook_pin_length - hook_curve_radius;

    pin_body_offset_z = board_thickness + pin_radius + hook_loose_fit;
    ball_end_offset_z = board_thickness + pin_radius + hook_loose_fit;

    union() {        
        // hook - backplate body
        cylinder(r = pin_radius, h = hook_curve_offset);

        // hook pin curve
        translate([0,0,hook_curve_offset])
            skadis_hook_curve(pin_diameter=diameter, hook_curve_radius = hook_curve_radius);

        // hook pin body
        translate([0, - hook_curve_radius, pin_body_offset_z])
            rotate([-90,0,180])
                cylinder(r = pin_radius, h = hook_pin_body_length);

        // ball end
        translate([0, - hook_pin_length, ball_end_offset_z])
            sphere(r = pin_radius);
    }
}

module skadis_hook(
    board_thickness = skadis_board_thickness(),
    hook_loose_fit = skadis_hook_loose_fit(),
    diameter = skadis_hole_diameter(),
    hook_curve_radius = 4,
    hook_pin_length = 6,
    reinforcement_factor = 0,
    reinforcement_granularity = 1
) {
    number_of_steps = reinforcement_factor / reinforcement_granularity;
    
    union() {
        for(step = [0:1:number_of_steps]) {
            offset = step * reinforcement_granularity;
            translate([0, offset, 0]) skadis_basic_hook(board_thickness = board_thickness, hook_loose_fit = hook_loose_fit, diameter = diameter, hook_curve_radius = hook_curve_radius, hook_pin_length = hook_pin_length);
        }
    }
}

// Shorthad with default values for easy usage in other modules
module skadis_reinforced_hook(f = 2, g = 0.2) {
    skadis_hook(reinforcement_factor = f, reinforcement_granularity = g);
}

module skadis_hook_with_pin(pin_displacement=skadis_hook_pin_distance(), reinforcement_factor = 0, reinforcement_granularity = 1) {
    union() {
        skadis_hook(reinforcement_factor = reinforcement_factor, reinforcement_granularity = reinforcement_granularity);
        translate([0,-pin_displacement,0]) skadis_pin();
    }
}

// Shorthad with default values for easy usage in other modules
module skadis_reinforced_hook_with_pin(d = skadis_hook_pin_distance(), f = 2, g = 0.2) {   
    skadis_hook_with_pin(pin_displacement = d, reinforcement_factor = f, reinforcement_granularity = g);
}


skadis_pin();
color("lightblue") translate([20, 0, 0]) skadis_basic_hook();
color("lightgreen") translate([40, 0, 0]) skadis_hook(); // result is the same as basic hook without reinforcement factor
color("orange") translate([60, 0, 0]) skadis_hook(reinforcement_factor = 2, reinforcement_granularity = 1);
color("lightgrey") translate([80, 0, 0]) skadis_reinforced_hook(); // shorthand with default values

color("grey") translate([0, -80, 0]) skadis_hook_with_pin();
color("brown") translate([20, -80, 0]) skadis_hook_with_pin(reinforcement_factor = 2, reinforcement_granularity = 1);
color("yellow") translate([40, -80, 0]) skadis_reinforced_hook_with_pin(); // shorthand with default values
color("red") translate([60, -80, 0]) skadis_reinforced_hook_with_pin(g = 1); // shorthand with overridden value

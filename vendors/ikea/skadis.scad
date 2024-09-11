// holes are 'diagonal' on the board; adjacent columns / rows are offset by 
function skadis_hole_x_distance() = 20;
function skadis_hole_y_distance() = 20;
function skadis_hole_diameter() = 5;
function skadis_board_thickness() = 5;

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

module skadis_basic_hook(board_thickness = skadis_board_thickness(), diameter = skadis_hole_diameter(), hook_curve_radius = 4, hook_pin_length = 6) {
    pin_radius = diameter / 2;
    
    hook_curve_offset = board_thickness + pin_radius - hook_curve_radius;
    hook_pin_body_length = hook_pin_length - hook_curve_radius;

    union() {        
        // hook - backplate body
        cylinder(r = pin_radius, h = hook_curve_offset);

        // hook pin curve
        translate([0,0,hook_curve_offset])
            skadis_hook_curve(pin_diameter=diameter, hook_curve_radius = hook_curve_radius);

        // hook pin body
        translate([0, - hook_curve_radius, board_thickness + pin_radius]) 
            rotate([-90,0,180])
                cylinder(r = pin_radius, h = hook_pin_body_length);

        // ball end
        translate([0, -hook_pin_length, board_thickness + pin_radius])
            sphere(r = pin_radius);
    }
}

module skadis_hook(board_thickness = skadis_board_thickness(), diameter = skadis_hole_diameter(), hook_curve_radius = 4, hook_pin_length = 6, reinforcement_factor = 0, reinforcement_granularity = 1) {
    number_of_steps = reinforcement_factor / reinforcement_granularity;
    
    union() {
        for(step = [0:1:number_of_steps]) {
            offset = step * reinforcement_granularity;
            translate([0, offset, 0]) skadis_basic_hook(board_thickness = board_thickness, diameter = diameter, hook_curve_radius = hook_curve_radius, hook_pin_length = hook_pin_length);
        }
    }
}

// Shorthad with default values for easy usage in other modules
module skadis_reinforced_hook(f = 2, g = 0.2) {
    skadis_hook(reinforcement_factor = f, reinforcement_granularity = g);
}

module skadis_hook_with_pin(pin_displacement=35, reinforcement_factor = 0, reinforcement_granularity = 1) {
    union() {
        skadis_hook(reinforcement_factor = reinforcement_factor, reinforcement_granularity = reinforcement_granularity);
        translate([0,-pin_displacement,0]) skadis_pin();
    }
}

// Shorthad with default values for easy usage in other modules
module skadis_reinforced_hook_with_pin(d = 35, f = 2, g = 0.2) {   
    skadis_hook_with_pin(pin_displacement = 35, reinforcement_factor = f, reinforcement_granularity = g);
}


skadis_pin();
translate([20, 0, 0]) skadis_basic_hook();
translate([40, 0, 0]) skadis_hook(); // result is the same as basic hook without reinforcement factor
translate([60, 0, 0]) skadis_hook(reinforcement_factor = 2, reinforcement_granularity = 1);
translate([80, 0, 0]) skadis_reinforced_hook(); // shorthand with default values

translate([100, 0, 0]) skadis_hook_with_pin();
translate([120, 0, 0]) skadis_hook_with_pin(reinforcement_factor = 2, reinforcement_granularity = 1);
translate([140, 0, 0]) skadis_reinforced_hook_with_pin(); // shorthand with default values
translate([160, 0, 0]) skadis_reinforced_hook_with_pin(g = 1); // shorthand with overridden value

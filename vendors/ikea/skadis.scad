module skadis_pin(height = 5, diameter = 5) {
    radius = diameter / 2;
    union() {
        cylinder(r = radius, h = height - radius);
        translate([0, 0, height - radius]) sphere(r = radius);
    }
}

module skadis_hook_curve(pin_diameter = 5, hook_curve_radius = 3) {
    translate([0,hook_curve_radius,0])
    rotate([90,0,-90])
        rotate_extrude(angle=90)
            translate([hook_curve_radius,0,0])
                circle(d = pin_diameter);
}

module skadis_hook(board_thickness = 5, diameter = 5, hook_curve_radius = 4, hook_pin_length = 6) {
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
        translate([0, hook_curve_radius, board_thickness + pin_radius]) 
            rotate([-90,0,0])
                cylinder(r = pin_radius, h = hook_pin_body_length);

        // ball end
        translate([0,hook_pin_length, board_thickness + pin_radius])
            sphere(r = pin_radius);
    }
}

module skadis_reinforced_hook(board_thickness = 5, diameter = 5, hook_curve_radius = 4, hook_pin_length = 6, reinforcement_factor = 2, reinforcement_granularity = 1) {
    
    number_of_steps = reinforcement_factor / reinforcement_granularity;
    
    union() {
        for(step = [0:1:number_of_steps]) {
            offset = step * reinforcement_granularity;
            translate([0, - offset, 0]) skadis_hook(board_thickness = board_thickness, diameter = diameter, hook_curve_radius = hook_curve_radius, hook_pin_length = hook_pin_length);
        }
    }
}

module skadis_hook_with_pin(hole_displacement=35) {
    union() {
        skadis_hook();
        translate([0,hole_displacement,0]) skadis_pin();
    }
}

module skadis_reinforced_hook_with_pin(hole_displacement=35, reinforcement_factor = 2, reinforcement_granularity = 1) {
    union() {
        skadis_reinforced_hook(reinforcement_factor = reinforcement_factor, reinforcement_granularity = reinforcement_granularity);
        translate([0,hole_displacement,0]) skadis_pin();
    }
}

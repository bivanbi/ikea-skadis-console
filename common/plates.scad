module plate_rounded_corners(h = 50, w = 100, t = 5, r = 3) {
    corner_diameter = r * 2;
    
    hull() {
        for (x = [0, w - corner_diameter],
             y = [0, h - corner_diameter]) {
            translate([x + r, y + r, 0])
                cylinder(h = t, r = r);
        }
    }
}

plate_rounded_corners();
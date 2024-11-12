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

module frame_rounded_corners(
    h = 50, // height
    w = 100, // width
    t = 5, // thickness
    r = 3, // corner round radius
    lew = 10, // left edge width
    tew = 10, // top edge width
    rew = 10, // right edge width
    bew = 10, // bottom edge width
) {
    pixel_size = 1;

    union() {
        hull() {// left vertical edge
            r = max([r, lew]) / 2;
            translate([r, r, 0])  cylinder(h = t, r = r);
            translate([r, h - r, 0]) cylinder(h = t, r = r);
            translate([lew - pixel_size, h - pixel_size, 0]) cube([pixel_size, pixel_size, t]);
            translate([lew - pixel_size, 0, 0]) cube([pixel_size, pixel_size, t]);
        }

        hull() {// top horizontal edge
            r = max([r, tew]) / 2;
            translate([r, h - r, 0])  cylinder(h = t, r = r);
            translate([w - r, h - r, 0]) cylinder(h = t, r = r);
            translate([w - pixel_size, h - tew, 0]) cube([pixel_size, pixel_size, t]);
            translate([0, h - tew, 0]) cube([pixel_size, pixel_size, t]);
        }

        hull() {// right vertical edge
            r = max([r, rew]) / 2;
            translate([w - r, h - r, 0])  cylinder(h = t, r = r);
            translate([w - r, r, 0]) cylinder(h = t, r = r);
            translate([w - rew, 0, 0]) cube([pixel_size, pixel_size, t]);
            translate([w - rew, h - pixel_size, 0]) cube([pixel_size, pixel_size, t]);
        }

        hull() {// bottom horizontal edge
            r = max([r, bew]) / 2;
            translate([r, r, 0])  cylinder(h = t, r = r);
            translate([w - r, r, 0]) cylinder(h = t, r = r);
            translate([0, bew - pixel_size, 0]) cube([pixel_size, pixel_size, t]);
            translate([w - pixel_size, bew - pixel_size, 0]) cube([pixel_size, pixel_size, t]);
        }

    }
}
module frame_x_rounded_corners(
    h = 50, // height
    w = 100, // width
    t = 5, // thickness
    r = 3, // corner round radius
    lew = 10, // left edge width
    tew = 10, // top edge width
    rew = 10, // right edge width
    bew = 10, // bottom edge width
    xw = 5, // crosslink width
) {
    pixel_size = 1;
    xr = xw / 2;

    union() {
        frame_rounded_corners(h = h, w = w, t = t, r = r, lew = lew, tew = tew, rew = rew, bew = bew);
        hull() { // crossling bottomleft to topright
            translate([lew, bew, 0]) cylinder(h = t, r = xr);
            translate([w - rew, h - tew, 0])  cylinder(h = t, r = xr);
        }

        hull() { // crossling topleft to bottomright
            translate([lew, h - tew, 0]) cylinder(h = t, r = xr);
            translate([w - rew, bew, 0])  cylinder(h = t, r = xr);
        }
    }
}

$fn=100;
plate_rounded_corners();
translate([0, 60, 0]) frame_rounded_corners();
translate([0, 120, 0]) frame_x_rounded_corners();
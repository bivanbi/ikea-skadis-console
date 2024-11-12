function text_default_extrude() = 1;
function text_default_font_size() = 10;
function text_default_font() = "Arial:style=Bold";
function text_carved_quickrender_workaround_factor() = 1;
function text_carved_default_depth() = 1;

module text_extruded(text, e = text_default_extrude(), s = text_default_font_size(), f = text_default_font(), halign = "left", valign = "baseline") {
    linear_extrude(e)
        text(text, size = s, font = f, halign = halign, valign = valign);
}

module text_carved(z, text, d = text_carved_default_depth(), s = text_default_font_size(), f = text_default_font(), halign = "left", valign = "baseline") {
    z = z - d;
    extrude = d + text_carved_quickrender_workaround_factor();
    
    translate([0, 0, z]) text_extruded(text = text, e = extrude, s = s, f = f, halign = halign, valign = valign);
}

text_extruded(text = "Hello World!");

translate([0, -20, 0])
    difference() {
        cube([82, 12, 2]);
        translate([1, 1, 0]) text_carved(z = 2, text = "Hello World!");
    }

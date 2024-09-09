# IKEA Skadis Console
An OpenSCAD project to create console for various equipments to be mounted on IKEA Skadis pegboards.

# Example
RB5009 Mikrotik Routerboard 5009 console with ports facing downwards, reduced thickness and sunk head bores for screws.
```
use <vendors/mikrotik/rb5009.scad>;
use <vendors/ikea/skadis.scad>;

$fn = 50;
rotate([0,180,0]) // convenience - make hooks face upwards when imported into slicer
rb5009_plate_with_sunk_head_bores_skadis_hook(thickness=3);
```
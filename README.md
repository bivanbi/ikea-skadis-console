# IKEA Skadis Console
An [OpenSCAD](https://openscad.org/) project to create console for various equipments to be mounted on IKEA Skadis pegboards.

## Howto
1. [Download and Install OpenSCAD](https://openscad.org/downloads.html)
2. Clone this repository
3. Create an OpenSCAD file and use the provided modules from the repo as needed
4. Render the scenery with F6
5. Export as STL or other formats supported by your slicer software 
   (e.g. [PrusaSlicer](https://www.prusa3d.com/prusaslicer/))

When slicing, use proper filling and / or outer wall thickness to
ensure the console is strong enough to hold the equipment.

## Example
[Mikrotik RB5009](https://mikrotik.com/product/rb5009ug_s_in) console with ports facing downwards, reduced thickness and sunk head bores for screws.
```
use <vendors/mikrotik/rb5009.scad>;

$fn = 50; // high resolution for smoother curves. Lower it for faster rendering.
rotate([0,180,0]) // convenience - make hooks face upwards on the hotbed when imported into slicer
rb5009_plate_with_sunk_head_bores_skadis_hook(thickness=3);
```
# IKEA Skadis Console
An [OpenSCAD](https://openscad.org/) project to create console for various equipments
to be mounted on [IKEA Skadis boards](https://www.ikea.com/us/en/cat/skadis-series-37813).

## Dependencies
### OpenSCAD (required)
Required to render the `.scad` files into STL or other model file format.
Download OpenSCAD from [OpenSCAD](https://www.openscad.org/downloads.html)

### Gotask (optional)
Optional tool to render multiple `.scad` files with ease.

## Howto
1. Clone this repository
2. Render an existing scad file or create your custom version
3Export as STL or other formats supported by your slicer software 
   (e.g. [PrusaSlicer](https://www.prusa3d.com/prusaslicer/))

When slicing, use proper filling and / or outer wall thickness to
ensure the console is strong enough to hold the equipment.

## Render into STL or other model file format

### OpenSCAD - GUI
1. Start OpenSCAD
2. Open the `.scad` file of your choice or create one to customize arrangement
3. Adjust render resolution by setting the `$fn` variable within the `.scad` file.
   A resolution of at least 50 is recommended, e.g.: `$fn = 50;`
4. Do render (keyboard shortcut: `F6`)
5. Export to STL (keyboard shortcut: `F7`) or other format understood by your slicer software

### OpenSCAD - Command line
1. Open a terminal
2. Run OpenSCAD with the `.scad` file of your choice, e.g.:
   ```bash
   openscad -o output.stl -D '$fn=<render resolution>' input.scad
   ```
   You can use any [export format supported by OpenSCAD](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Export).
   
A render resolution of 50 is recommended, e.g.:
```bash
openscad -o output.stl -D '$fn=50' input.scad
```

### Render all `.scad` files in a directory from command line with Gotask
1. Open a terminal
2. Run Gotask with the directory containing the `.scad` files, e.g.:
   ```bash
   cd vendors/mikrotik/rb5009
   task all
   # or simply
   task
   ```
    
### Render a single `.scad` file from command line with Gotask
1. Open a terminal
2. Run Gotask with the directory containing the `.scad` files, e.g.:
   ```bash
   cd vendors/mikrotik
   task render -- <SCAD filename>
   ```
   
#### Override format and render resolution
##### On commandline:
Invoke Gotask with environment variables set, e.g.:
```bash
FORMAT=stl RESOLUTION=50 task

# or
export FORMAT=stl
export RESOLUTION=50
task
```

##### Using .env file
**Note**: This is a global setting that cannot be overridden on commandline.

2. Copy the `env.example` file to `.env`:
   ```bash
   cp env.example .env
   ```
2. Edit as needed
3. Run Gotask like normal

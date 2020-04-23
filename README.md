# Lsim - Lighting Simulation software
Created by Oliver Steigauf

---
### Feel free to contribute - Thanks for contributing!
---

### Overview

##### Technological Purpose
Simulation of lighting equipment (conventional and LED fixtures, moving lights, pixel matrices) controlled by ArtNet input

##### Educational Purpose
Submission for "Effizient Programmieren I+II"

##### Software Design Guidelines (Things you should stick to while coding)
* Code style in compliance with Processing 3.5.4 Autoformat
* Naming convention:
    * Classes: First letter Caps ("Vehicles")
    * Acronyms: First letter Caps ("Madrid")
    * Functions and variables: camelCase ("showProperties")
    * Function parameters:
        * In: "iXxxx"
        * Out: "oXxxx"
* Documentation via descriptive variable names, comments in code and Doxygen-specific comments
* Version control via Git (duh)

##### Additional Mechanisms (Things that are automatically done for you)
* Generation of Doxygen documentation, available here: http://193.196.52.193/doxygen/index.html
* Automated build check (see badges below)
* <del>(ToDo) Automated testing upon push</del> Not working, maybe due to missing OpenGL capabilities on CI server
* <del>(ToDo) Generation of executables upon merge to master branch</del> Not working, maybe due to launch4j incompatibility on CI server

[![pipeline status](https://gitlab.fsmach.uni-stuttgart.de/lsim/lsim/badges/ciConfig/pipeline.svg)](https://gitlab.fsmach.uni-stuttgart.de/lsim/lsim/-/commits/ciConfig)

##### Mid-Term goals
* (ToDo) Add ArtNet output for real-world fixture control via Lsim
* (ToDo) Add camera inputs and 2D->3D coordinate mapping
* (ToDo) Add Kinect input



### Usage

##### Setup
* Download Processing 3 from https://processing.org/download/
* Open Processing IDE, go to _Tools->Add Tool->Libraries Tab_ and install _UDP_ library by Stephane Cousot
* Open _Lsim.pde_ from src/Lsim/ and click _Run_ button in the IDE
* If you experience problems, check if your Java Runtime Environment version is 8. Newer versions might work, but haven't yet been tested.
* If it still doesn't work as expected, please report the issue at https://gitlab.fsmach.uni-stuttgart.de/lsim/lsim/-/issues or via E-Mail to lsim@aerotrax.de

##### Key bindings
* DELETE: Clear spin box
* BACKSPACE: Delete rightmost spin box digit
* '-', '0'-'9', '.': Change spin box value
* ENTER: Apply value

##### Mouse control
* Mousewheel (menu): Increment/Decrement box values
* CONTROL + Mousewheel: Incrementation speed x10
* SHIFT + Mousewheel: Incrementation speed x100
* Mousewheel (3D space): Zoom in/out
* Hold right mouse button: Orbit around point of interest
* Hold middle mouse button: Move point of interest

##### General
* Scale is 1cm/px
* Backups are automatically created in save/autobackups/ upon program start, so if you (or a bug) messed something up, check older versions there

##### Environment format generation
* CAD (e.g. CATIA): Model should be roughly centered around vertical axis
* Tesselate CAD model with 0.5 Millimeters allowed deviation
* Converter (e.g. Cinema4D): Import .stl with scale 1 Millimeter
* Export as .obj with scale 10 Millimeters and inverted Y-axis
* Place file in data/ subdirectory of sketch, name starting with "env_"

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
* (ToDo) Automated testing upon push
* (ToDo) Generation of Doxygen documentation and executables upon merge to master branch

##### Mid-Term goals
* (ToDo) Add ArtNet output for real-world fixture control via Lsim
* (ToDo) Add camera inputs and 2D->3D coordinate mapping
* (ToDo) Add Kinect input



### Usage

##### Setup
* Download Processing 3 from https://processing.org/download/
* Open Processing IDE, go to _Tools->Add Tool->Libraries Tab_ and install _UDP_ library by Stephane Cousot
* Open _Lsim.pde_ from src/Lsim/ and click _Run_ button in the IDE
* If you experience problems, try updating your Java Runtime Environment
* If it still doesn't work as expected, please report the issue at https://gitlab.fsmach.uni-stuttgart.de/lsim/lsim/-/issues or via E-Mail to lsim@aerotrax.de

##### Key bindings
* Mousewheel / 0-9: Edit spin box values
* Hold CONTROL: Incrementation speed x10
* Hold SHIFT: Incrementation speed x100
* BACKSPACE: Delete rightmost spin box digit
* DELETE: Clear spin box

##### Mouse control
* Mousewheel: Zoom in/out
* Hold right mouse button: Orbit around point of interest
* Hold middle mouse button: Move point of interest

##### General
* Scale is 1cm/px
* Backups are automatically created in save/autobackups/ upon program start, so if you (or a bug) messed something up, check older versions there

##### Environment format generation
* CAD (e.g. CATIA): Model should be roughly centered around vertical axis
* Tesselate CAD model with 0.5 Millimeters allowed deviation
* Converter (e.g. Cinema4D): Import .stl with scale 1 Millimeter
* Export as .obj with scale 10 Millimeters amd inverted Y-axis
* Place file in data/ subdirectory of sketch, name starting with "env_"

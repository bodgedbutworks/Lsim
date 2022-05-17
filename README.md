# Lsim - Lighting Simulation software
<img src="https://user-images.githubusercontent.com/66431086/164988059-c8370333-f8d5-40fc-87e7-f6fdca0f9d66.PNG" width="70%">
Created by bodgedbutworks
<br>
<br>
<br>

### Feel free to contribute - Thanks for contributing!
<br>

### Overview
---

#### Technological Purpose
Simulation of lighting equipment (conventional and LED fixtures, moving lights, pixel matrices) controlled by ArtNet input

#### Educational Purpose
Submission for lecture "Effizient Programmieren I+II", attempts were made to pursue a clean code style

#### Software Design Guidelines (Things you should stick to while coding)
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

<br>
<br>
<img src="https://user-images.githubusercontent.com/66431086/164988061-98f43070-5dcf-4330-b943-b1793b9be01f.PNG" width="70%">
<br>


### Mid-Term goals
---
* (ToDo) Add ArtNet output for real-world fixture control via Lsim
* (ToDo) Add camera inputs and 2D->3D coordinate mapping
* (ToDo) Add Kinect input

<br>

### Usage
---
#### Option A: Download executable for you system [here](https://github.com/bodgedbutworks/Lsim/releases)
> **Note for mac users**: \
> If you download the prebuilt releases, they are considered suspicious and receive a quarantine flag. This results in errors such as `The application is corrupted and should be removed` and the application not starting.
> This can be prevented either by installing [Processing 3](https://processing.org/download/) yourself and running the program from source OR (quicker) by removing the quarantine flag from the app.
> To remove the flag open a terminal window (Spotlight search [CMD+Space], type "Term...") and execute the following commands: \
> __Navigate to where Lsim was downloaded. You can partially type the directory names (e.g. "Lsi...") and press TAB multiple times to autocomplete:__ \
> ```cd ~/Downloads/Lsim_v1.0.1_macos-x86_64``` \
> __Remove quarantine flag:__ \
> ```sudo xattr -d -r com.apple.quarantine Lsim.app```



#### Option B: Build from source code yourself using Processing 3
* Download Processing 3 from https://processing.org/download/
* Open Processing IDE, go to _Tools->Add Tool->Libraries Tab_ and install _UDP_ library by Stephane Cousot
* Download the latest Lsim release (Source Code) from [here](https://github.com/bodgedbutworks/Lsim/releases)
* Open _Lsim.pde_ from src/Lsim/ and click _Run_ button in the IDE
* If you experience problems, check if your Java Runtime Environment version is 8. Newer versions might work, but haven't yet been tested.
* Starting Lsim _before_ opening your lighting control software is usually a good idea.
* If it still doesn't work as expected, please [report the issue here](https://github.com/bodgedbutworks/Lsim/issues) or via E-Mail to lsim@aerotrax.de

#### Key bindings
* DELETE: Clear spin box
* BACKSPACE: Delete rightmost spin box digit
* '-', '0'-'9', '.': Change spin box value
* ENTER: Apply value

#### Mouse control
* Mousewheel (menu): Increment/Decrement box values
* CONTROL + Mousewheel: Incrementation speed x10
* SHIFT + Mousewheel: Incrementation speed x100
* Mousewheel (3D space): Zoom in/out
* Hold right mouse button: Orbit around point of interest
* Hold middle mouse button: Move point of interest

#### General
* Scale is 1cm/px
* Backups are automatically created in save/autobackups/ upon program start, so if you (or a bug) messed something up, check for older versions there

#### Environment models generation
* CAD (e.g. CATIA): Model should roughly be centered around the vertical axis
* Tesselate CAD model with 0.5 Millimeters allowed deviation
* Converter/mesh editor (e.g. Cinema 4D): Import .stl with standard settings
* Scale and position model accordingly, +Y axis is the upwards direction
* Export as .obj (for Meshroom models: Select "Flip X Axis" and "Flip Y Axis")
* Place file in data/ subdirectory of sketch, name starting with "env_"

<br>

### Code Documentation
---
Available [here](https://github.com/bodgedbutworks/Lsim/releases) (Download _Documentation.zip_, open _Documentation/doc/html/index.html_ with your browser)


<br>
<br>
<img src="https://user-images.githubusercontent.com/66431086/164988063-a54b053c-011b-4e3c-9b3c-36f2e7d86421.PNG" width="70%">

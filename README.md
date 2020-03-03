# Lsim - Lighting Simulation software
Created by Oliver Steigauf

---
### Feel free to contribute - Thanks for contributing!
---

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
        * Modifyable: "cXxxx"
* Documentation via descriptive variable names, comments in code and Doxygen-specific comments
* Version control via Git (duh)

##### Additional Mechanisms (Things that are automatically done for you)
* Automated testing upon push
* Generation of Doxygen documentation and executables upon merge to master branch

##### Mid-Term goals
* Add ArtNet output for real-world fixture control via Lsim
* Add camera inputs and 2D->3D coordinate mapping
* Add Kinect input

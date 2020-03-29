/* 3D Coordinate System:
      ___________________ +X
     /|
    / |
   /  |
  /   |
+Z    |
      |
     +Y
*/

/** \mainpage Documentation for the Lsim lighting simulation software
    Created in 2020 by Oliver Steigauf

    Git repository and README available at https://gitlab.fsmach.uni-stuttgart.de/lsim/lsim

    Key bindings:
        - Mousewheel / 0-9: Edit spin box values
        - Hold CONTROL: Incrementation speed x10
        - Hold SHIFT: Incrementation speed x100
        - BACKSPACE: Delete rightmost spin box digit
        - DELETE: Clear spin box

    Mouse control:
        - Mousewheel: Zoom in/out
        - Hold right mouse button: Orbit around point of interest
        - Hold middle mouse button: Move point of interest

    General:
        - Scale is 1cm/px

    Environment format generation:
        - CAD (e.g. CATIA): Model should be roughly centered around vertical axis
        - Tesselate CAD model with 0.5 Millimeters allowed deviation
        - Converter (e.g. Cinema4D): Import .stl with scale 1 Millimeter
        - Export as .obj with scale 10 Millimeters amd inverted Y-axis
        - Place file in data/ subdirectory of sketch, name starting with "env_"

**/

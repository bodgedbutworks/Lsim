/// @brief Class for all 3D Cuboid Objects
class Cuboid extends ScreenObject {
  PVector size3d;

  Cuboid() {
    super(new PVector(int(random(-100, 100)), int(random(-250, -50)), int(random(-100, 100))), new PVector(0, 0, 0));
    size3d = new PVector(40, 40, 40);
  }

  /// @brief Display the Cuboid and handle mouse over/clicked events
  void display() {
    checkMouseOver();

    PVector dummy = new PVector(0, 500, 0);
    dummy = rotateVector(dummy, 0, 0, -rot.z);  // Sequence of rotations makes a difference!
    dummy = rotateVector(dummy, 0, -rot.y, 0);
    dummy = rotateVector(dummy, -rot.x, 0, 0);
    dummy.add(new PVector(pos3d.x, pos3d.y, pos3d.z));

    pushMatrix();
    translate(pos3d.x, pos3d.y, pos3d.z);
    rotateX(radians(rot.x));
    rotateY(radians(rot.y));
    rotateZ(radians(rot.z));
    stroke(0);
    strokeWeight(1);
    fill(clr);
    box(size3d.x, size3d.y, size3d.z);
    popMatrix();

    updatePos2d();
  }

  /// @brief Load this Cuboid's GUI Elements (inside an Expandable) into the menu sidebar list
  void loadGui() {
    Expandable tempCubExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Cuboid", true, true, CLR_MENU_LV1);
    tempCubExp.put(new NameBox(new PVector(0, 0), new PVector(120, 25), this, "name", "Name", name));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.x", "pos3d.x", pos3d.x, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.y", "pos3d.y", pos3d.y, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.z", "pos3d.z", pos3d.z, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.x", "rot.x", rot.x, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.y", "rot.y", rot.y, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.z", "rot.z", rot.z, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "size3d.x", "size3d.x", size3d.x, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "size3d.y", "size3d.y", size3d.y, 1.0));
    tempCubExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "size3d.z", "size3d.z", size3d.z, 1.0));
    tempCubExp.put(new Button(new PVector(0, 0), new PVector(60, 30), this, "Copy Cuboid", "Copy", CLR_MENU_LV1));
    tempCubExp.put(new Button(new PVector(60+SIZE_GUTTER, 0-30-SIZE_GUTTER), new PVector(60, 30), this, "Delete Cuboid", "Delete", CLR_MENU_LV1));
    menuExpRight.put(tempCubExp);
  }

  /// @brief Pack relevant attributes into a JSON and return it
  /// @return JSON data with this object's saved attributes
  JSONObject save() {
    JSONObject oJson = super.save();
    oJson.setFloat("size3d.x", size3d.x);
    oJson.setFloat("size3d.y", size3d.y);
    oJson.setFloat("size3d.z", size3d.z);
    return(oJson);
  }

  /// @brief Load object attributes from provided JSON Data
  /// @param iJson JSON Dataset including this object's attributes to load
  void load(JSONObject iJson) {
    super.load(iJson);
    size3d.x = iJson.getFloat("size3d.x");
    size3d.y = iJson.getFloat("size3d.y");
    size3d.z = iJson.getFloat("size3d.z");
    println("Loaded Cuboid " + name);
  }
}

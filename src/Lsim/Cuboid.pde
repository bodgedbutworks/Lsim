class Cuboid extends ScreenObject {
  PVector size3d;

  Cuboid() {
    super(new PVector(0, 0, 0), new PVector(0, 0, 0));
    size3d = new PVector(40, 40, 40);
  }

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
    fill(#555555);
    box(size3d.x, size3d.y, size3d.z);
    popMatrix();

    updatePos2d();
  }

  void loadGui() {
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.x", pos3d.x, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.y", pos3d.y, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.z", pos3d.z, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.x", rot.x, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.y", rot.y, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.z", rot.z, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "size3d.x", size3d.x, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "size3d.y", size3d.y, 1.0));
    menuExpRight.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "size3d.z", size3d.z, 1.0));
  }

  String getSaveString() {
    return(
      name + ";" +
      str(pos3d.x) + ";" +
      str(pos3d.y) + ";" +
      str(pos3d.z) + ";" +
      str(rot.x) + ";" +
      str(rot.y) + ";" +
      str(rot.z) + ";" +
      str(size3d.x) + ";" +
      str(size3d.y) + ";" +
      str(size3d.z)
      );
  }

  void setLoadString(String iLine) {
    String[] props = split(iLine, ';');
    if (props.length == 10) {
      name = props[0];
      pos3d = new PVector(float(props[1]), float(props[2]), float(props[3]));
      rot = new PVector(float(props[4]), float(props[5]), float(props[6]));
      size3d = new PVector(float(props[7]), float(props[8]), float(props[9]));
      println("Loaded Cuboid " + name);
    } else {
      println("!Error while loading a Cuboid: Number of properties in line not as expected!");
      return;
    }
  }
}

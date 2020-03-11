class Cuboid extends ScreenObject {
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
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "pos3d.x", pos3d.x, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "pos3d.y", pos3d.y, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "pos3d.z", pos3d.z, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "rot.x", rot.x, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "rot.y", rot.y, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "rot.z", rot.z, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "size3d.x", size3d.x, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "size3d.y", size3d.y, 1.0));
    guiList.add(new SpinBox<Cuboid>(new PVector(0, 0), new PVector(80, 25), this, "size3d.z", size3d.z, 1.0));
  }
}

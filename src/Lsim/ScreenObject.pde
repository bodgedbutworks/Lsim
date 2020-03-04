class ScreenObject {
  int id;
  PVector pos3d;
  PVector pos2d;
  PVector rot;
  color clr = color(50);

  ScreenObject(PVector iPos, PVector iRot) {
    pos3d = iPos;
    rot = iRot;
  }

  void display() {
    println("Display function not defined!");
  }

  void checkMouseOver() {
    if (dist(screenX(pos3d.x, pos3d.y, pos3d.z), screenY(pos3d.x, pos3d.y, pos3d.z), mouseX, mouseY) < 40) {
      clr = color(190, 0, 0);
      if (flag  &&  mousePressed) {
        flag = false;
        selectedFixture = fixtureList.indexOf(this);
        //updateGUIelements();
      }
    } else {
      if (fixtureList.indexOf(this) == selectedFixture) {
        clr = color(245+10*sin(millis()/100.0), 0, 0);
      } else {
        clr = color(80);
      }
    }
  }
}

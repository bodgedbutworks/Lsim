class ScreenObject {
  //int id;
  String name = "Object " + str(floor(random(0, 999999)));
  PVector pos3d;
  PVector pos2d;
  PVector rot;
  color clr = color(50);

  ScreenObject(PVector iPos, PVector iRot) {
    pos3d = iPos;
    pos2d = new PVector(0, 0);
    rot = iRot;
  }

  void display() {
    println("Display function not defined!");
  }

  void loadGui() {
    println("Gui load function not defined!");
  }

  String getSaveString(){
    println("Object save function not defined!");
    return("Object save function not defined!");
  }

  void setLoadString(String iLine) {
    println("Object load function not defined!");
  }

  void checkMouseOver() {
    if (dist(screenX(pos3d.x, pos3d.y, pos3d.z), screenY(pos3d.x, pos3d.y, pos3d.z), mouseX, mouseY) < 40) {
      clr = color(190, 0, 0);
      if (flag  &&  mousePressed) {
        flag = false;
        updateSelectedFixture(fixtureList.indexOf(this));
        loadGui();
        if (menuState == 0) {
          menuState = 1;
        }
      }
    } else {
      if (fixtureList.indexOf(this) == selectedFixture) {
        clr = color(245+10*sin(millis()/100.0), 0, 0);
      } else {
        clr = color(80);
      }
    }
  }

  void updatePos2d(){
    pos2d.x = screenX(pos3d.x, pos3d.y, pos3d.z);
    pos2d.y = screenY(pos3d.x, pos3d.y, pos3d.z);
  }
}

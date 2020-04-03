class ScreenObject {
  //int id;
  String name = "Object" + str(floor(random(0, 999999)));
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

  // Show name and Center Of Mass symbol; Has to be called in main after resetting camera() for correct 2D display
  void draw2d() {
    fill(255);
    textSize(height/50);
    textAlign(CENTER, CENTER);
    text(name, pos2d.x, pos2d.y-80);
    image(comImg, pos2d.x-7, pos2d.y-7, 14, 14);
  }

  void loadGui() {
    println("Gui load function not defined!");
  }

  String getSaveString() {
    return(
      name + ";" +
      str(pos3d.x) + ";" +
      str(pos3d.y) + ";" +
      str(pos3d.z) + ";" +
      str(rot.x) + ";" +
      str(rot.y) + ";" +
      str(rot.z)
      );
  }

  void setLoadArray(String[] iProps) {
    try {
      name = iProps[0];
      pos3d = new PVector(float(iProps[1]), float(iProps[2]), float(iProps[3]));
      rot = new PVector(float(iProps[4]), float(iProps[5]), float(iProps[6]));
      print("Loading ScreenObj..");
    }
    catch(Exception e) {
      println(e);
    }
  }

  void checkMouseOver() {
    if (dist(screenX(pos3d.x, pos3d.y, pos3d.z), screenY(pos3d.x, pos3d.y, pos3d.z), mouseX, mouseY) < 30) {
      clr = color(190, 0, 0);
      if (flag  &&  mousePressed) {
        flag = false;
        selectedScreenObject = this;
        menuExpRight.subElementsList.clear();
        menuScroll = 0;
        loadGui();
        if (menuState == 0) {
          menuState = 1;
        }
      }
    } else {
      if (this == selectedScreenObject) {
        clr = color(245+10*sin(millis()/100.0), 0, 0);
      } else {
        clr = color(80);
      }
    }
  }

  void updatePos2d() {
    pos2d.x = screenX(pos3d.x, pos3d.y, pos3d.z);
    pos2d.y = screenY(pos3d.x, pos3d.y, pos3d.z);
  }
}

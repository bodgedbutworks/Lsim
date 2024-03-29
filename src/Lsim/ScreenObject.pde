/// @brief Parent class for all objects in 3D space (Fixture, Cuboid, ..)
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

  /// @brief Prototype function for ScreenObject display
  void display() {
    notific("Display function not defined!", CLR_NOTIF_DANGER, TTL_DANGER);
  }

  /// @brief Shows name and Center Of Mass symbol
  /// @details Called in main after resetting camera() for correct 2D display
  void draw2d() {
    fill(255);
    textSize(height/50);
    textAlign(CENTER, CENTER);
    text(name, pos2d.x, pos2d.y-80);
    image(comImg, pos2d.x-7, pos2d.y-7, 14, 14);
  }

  /// @brief Prototype function for loading of this Object's GUI elements
  void loadGui() {
    notific("Gui load function not defined!", CLR_NOTIF_DANGER, TTL_DANGER);
  }

  /// @brief Pack relevant attributes into a JSON and return it
  /// @return JSON data with this object's saved attributes
  JSONObject save() {
    JSONObject oJson = new JSONObject();
    oJson.setString("name", name);
    oJson.setFloat("pos3d.x", pos3d.x);
    oJson.setFloat("pos3d.y", pos3d.y);
    oJson.setFloat("pos3d.z", pos3d.z);
    oJson.setFloat("rot.x", rot.x);
    oJson.setFloat("rot.y", rot.y);
    oJson.setFloat("rot.z", rot.z);
    return(oJson);
  }

  /// @brief Load object attributes from provided JSON Data
  /// @param iJson JSON Dataset including this object's attributes to load
  void load(JSONObject iJson) {
    print("Loading ScreenObj..");
    name = iJson.getString("name");
    pos3d.x = iJson.getFloat("pos3d.x");
    pos3d.y = iJson.getFloat("pos3d.y");
    pos3d.z = iJson.getFloat("pos3d.z");
    rot.x = iJson.getFloat("rot.x");
    rot.y = iJson.getFloat("rot.y");
    rot.z = iJson.getFloat("rot.z");
  }

  /// @brief Checks for mouse over and click inside focused ScreenObject's (circular 2d) proximity
  /// @return true if mouse was clicked inside proximity radius, else false
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

  /// @brief Updates 2d (on-screen) position from 3d position
  void updatePos2d() {
    pos2d.x = screenX(pos3d.x, pos3d.y, pos3d.z);
    pos2d.y = screenY(pos3d.x, pos3d.y, pos3d.z);
  }
}

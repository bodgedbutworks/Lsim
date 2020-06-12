class ScreenObject implements IGuiObject{
  //int id;
  String name;
  private PositionUnit positionData;
  color clr; 

  ScreenObject(PVector iPos, PVector iRot) {
    this.name = "Object" + str(floor(random(0, 999999)));
    this.clr = color(50);
    PVector empty3D = new PVector(0,0,0);
    PVector empty2D = new PVector(0,0);
    this.positionData = new PositionUnit(iPos, iRot, empty3D, empty3D, empty2D, empty2D, empty2D, empty2D); // there schoul be some usefull vectors for the empty ones
  }

  void display() {
    notific("Display function not defined!", CLR_NOTIF_DANGER, TTL_DANGER);
  }

  // Show name and Center Of Mass symbol; Has to be called in main after resetting camera() for correct 2D display
  void draw2d() {
    fill(255);
    textSize(height/50);
    textAlign(CENTER, CENTER);
    text(name, this.positionData.getPosition2D().x, this.positionData.getPosition2D().y-80);
    image(comImg, this.positionData.getPosition2D().x-7, this.positionData.getPosition2D().y-7, 14, 14);
  }

  void loadGui() {
    notific("Gui load function not defined!", CLR_NOTIF_DANGER, TTL_DANGER);
  }

  JSONObject save() {
    JSONObject oJson = new JSONObject();
    oJson.setString("name", name);
    oJson.setFloat("pos3d.x", this.positionData.getPosition3D().x);
    oJson.setFloat("pos3d.y", this.positionData.getPosition3D().y);
    oJson.setFloat("pos3d.z", this.positionData.getPosition3D().z);
    oJson.setFloat("rot.x", this.positionData.getRotation3D().x);
    oJson.setFloat("rot.y", this.positionData.getRotation3D().y);
    oJson.setFloat("rot.z", this.positionData.getRotation3D().z);
    return(oJson);
  }

  void load(JSONObject iJson) {
    print("Loading ScreenObj..");
    name = iJson.getString("name");
    this.positionData.getPosition3D().x = iJson.getFloat("pos3d.x");
    this.positionData.getPosition3D().y = iJson.getFloat("pos3d.y");
    this.positionData.getPosition3D().z = iJson.getFloat("pos3d.z");
    this.positionData.getRotation3D().x = iJson.getFloat("rot.x");
    this.positionData.getRotation3D().y = iJson.getFloat("rot.y");
    this.positionData.getRotation3D().z = iJson.getFloat("rot.z");
  }

  void checkMouseOver() {
    if (dist(screenX(this.positionData.getPosition3D().x, this.positionData.getPosition3D().y, this.positionData.getPosition3D().z), screenY(this.positionData.getPosition3D().x, this.positionData.getPosition3D().y, this.positionData.getPosition3D().z), mouseX, mouseY) < 30) {
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
    this.positionData.getPosition2D().x = screenX(this.positionData.getPosition3D().x, this.positionData.getPosition3D().y, this.positionData.getPosition3D().z);
    this.positionData.getPosition2D().y = screenY(this.positionData.getPosition3D().x, this.positionData.getPosition3D().y, this.positionData.getPosition3D().z);
  }
  
  public PVector getPosition() {
    return this.positionData.getPosition3D();
  }
  public PVector getRotation() {
    return this.positionData.getRotation3D();
  }
  
  public void setPosition(PVector iNewPosition) {
    this.positionData.setPosition3D(iNewPosition);
  }
  public void setRotation(PVector iNewRotation) {
    this.positionData.setRotation3D(iNewRotation);
  }
}

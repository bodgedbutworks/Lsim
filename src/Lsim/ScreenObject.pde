/**
* @brief Parent class for all objects in 3D space
*/
class ScreenObject<T extends IGuiObject> extends IGuiObject{

  ScreenObject(PVector iPos, PVector iRot) {
    super();
    this.properName = "Object" + str(floor(random(0, 999999)));
    this.objectColor = color(50);
    PVector empty3D = new PVector(0,0,0);
    PVector empty2D = new PVector(0,0);
    this.positionData = new PositionUnit(iPos, iRot, empty3D, empty3D, empty2D, empty2D, empty2D, empty2D); // there schoul be some usefull vectors for the empty ones
  }

  /**
  * @brief 
  */
  void display() {
    notific("Display function not defined!", constantData.CLR_NOTIF_DANGER, constantData.TTL_DANGER);
  }

  /**
  * @brief Shows name and Center Of Mass symbol
  * @details Called in main after resetting camera() for correct 2D display
  */
  void draw2d() {
    fill(255);
    textSize(height/50);
    textAlign(CENTER, CENTER);
    text(this.properName, this.positionData.getPosition2D().x, this.positionData.getPosition2D().y-80);
    image(comImg, this.positionData.getPosition2D().x-7, this.positionData.getPosition2D().y-7, 14, 14);
  }

  /**
  * @brief function for loading of this Object's GUI elements
  */
  void loadGui() {
    notific("Gui load function not defined!", constantData.CLR_NOTIF_DANGER, constantData.TTL_DANGER);
  }

  /**
  * @brief Pack relevant attributes into a JSON and return it
  * @return JSON data with this object's saved attributes
  */
  JSONObject save() {
    JSONObject oJson = new JSONObject();
    oJson.setString("name", this.properName);
    oJson.setFloat("pos3d.x", this.positionData.getPosition3D().x);
    oJson.setFloat("pos3d.y", this.positionData.getPosition3D().y);
    oJson.setFloat("pos3d.z", this.positionData.getPosition3D().z);
    oJson.setFloat("rot.x", this.positionData.getRotation3D().x);
    oJson.setFloat("rot.y", this.positionData.getRotation3D().y);
    oJson.setFloat("rot.z", this.positionData.getRotation3D().z);
    return(oJson);
  }

  /**
  * @brief Load object attributes from provided JSON Data
  * @param iJson JSON Dataset including this object's attributes to load
  */
  void load(JSONObject iJson) {
    print("Loading ScreenObj..");
    this.properName = iJson.getString("name");
    this.positionData.getPosition3D().x = iJson.getFloat("pos3d.x");
    this.positionData.getPosition3D().y = iJson.getFloat("pos3d.y");
    this.positionData.getPosition3D().z = iJson.getFloat("pos3d.z");
    this.positionData.getRotation3D().x = iJson.getFloat("rot.x");
    this.positionData.getRotation3D().y = iJson.getFloat("rot.y");
    this.positionData.getRotation3D().z = iJson.getFloat("rot.z");
  }

  /**
  * @brief Checks for mouse over and click inside focused ScreenObject's as circular 2d proximity
  * @return true if mouse was clicked inside proximity radius
  */
  void checkMouseOver() {
    if (dist(screenX(this.positionData.getPosition3D().x, this.positionData.getPosition3D().y, this.positionData.getPosition3D().z), screenY(this.positionData.getPosition3D().x, this.positionData.getPosition3D().y, this.positionData.getPosition3D().z), mouseX, mouseY) < 30) {
      this.objectColor = color(190, 0, 0);
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
        this.objectColor = color(245+10*sin(millis()/100.0), 0, 0);
      } else {
        this.objectColor = color(80);
      }
    }
  }

  /**
  * @brief Updates 2d on-screen position from 3d position
  */
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
  
  public PVector getSize() {
    return this.positionData.getSize3D(); 
  }
  
  public void setSize(PVector iSize) {
    this.positionData.setSize3D(iSize); 
  }
  
}

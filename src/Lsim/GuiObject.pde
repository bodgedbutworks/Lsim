class GuiObject {
  private PositionUnit positionData;
  //PVector offset;     // Position offset, added to temporary position before saving to pos
  //PVector pos;        // Actual element pos, used for mouseover/displaying, set by "parent" Expandable //not in use anymore insted positionData

  Fixture fixObjRef;
  Cuboid cubObjRef;
  Pixel pixObjRef;
  Dynamics dynObjRef;
  Expandable expObjRef;
  String objType = "";

  String propName = "";
  String displayName = "";
  String valStr = "42.0";
  String utilStr = "0";                                                         // Used while editing via keyboard, later applied to valStr
  byte keyEditState = 0;                                                        // 0=idle, 1=editing
  float stepSize = 1.0;
  color clr = color(255, 0, 255);

  // Overloaded constructor for every object type reference
  GuiObject(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    objType = "None";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);  // Initialize object type independent properties
  }
  GuiObject(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    fixObjRef = iObjRef;
    objType = "Fixture";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    cubObjRef = iObjRef;
    objType = "Cuboid";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    pixObjRef = iObjRef;
    objType = "Pixel";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Dynamics iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    dynObjRef = iObjRef;
    objType = "Dynamics";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    expObjRef = iObjRef;
    objType = "Expandable";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  void init(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    PVector empty = new PVector(0, 0);
    propName = iPropName;
    displayName = iDisplayName;
    valStr = iInitialVal;
    stepSize = iStepSize;
    this.positionData = new PositionUnit(empty, empty, iSize, iOffset, false);
  }

  void editValMouse(float iEventGetCount) {
    iEventGetCount *= stepSize;
    if (keyPressed  &&  key==CODED  &&  keyCode==CONTROL) {
      iEventGetCount *= 10;
    } else if (keyPressed  &&  key==CODED  &&  keyCode==SHIFT) {
      iEventGetCount *= 100;
    }
    valStr = str(float(valStr)-iEventGetCount);
  }

  void editValKey() {
  }

  void display() {
  }

  // Returns true if mouse was clicked inside hitbox. Setting of selectedGuiObject moved
  // to child classes because some of them (f.ex. Button) arent't supposed to be a selectedGuiObject
  boolean checkMouseOver() {
    if (mouseX > getPosition().x  &&  mouseX < (getPosition().x+this.positionData.getSize2D().x)  &&  mouseY > getPosition().y  &&  mouseY < (getPosition().y+this.positionData.getSize2D().y)) {
      if (flag  &&  mousePressed) {
        flag = false;
        return(true);
      }
    }
    return(false);
  }
  
  public PVector getPosition() {
    return this.positionData.getPosition2D(); 
  }
  
  public void setPosition(PVector iPosition) {
    this.positionData.setPosition2D(iPosition); 
  }
  
  private PVector getRotation() {
    return this.positionData.getRotation2D(); 
  }
  
  private void setRotation(PVector iRotation) {
    this.positionData.setRotation2D(iRotation); 
  }
  
  public PVector getSize() {
    return this.positionData.getSize2D(); 
  }
  
  public void setSize(PVector iSize) {
    this.positionData.setSize2D(iSize); 
  }
  
  public PVector getOffset() {
    return this.positionData.getDirection2D(); 
  }
  
  private void setOffset(PVector iOffset) {
    this.positionData.setDirection2D(iOffset); 
  }
}

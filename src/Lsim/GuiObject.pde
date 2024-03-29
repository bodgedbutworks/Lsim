/// @brief Parent class for all GUI Objects (Button, NameBox, ..)
class GuiObject {
  PVector offset;     // Position offset, added to temporary position before saving to pos
  PVector pos;        // Actual element pos, used for mouseover/displaying, set by "parent" Expandable
  PVector size;

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
    offset = iOffset;
    pos = new PVector(0, 0);
    size = iSize;
    propName = iPropName;
    displayName = iDisplayName;
    valStr = iInitialVal;
    stepSize = iStepSize;
  }

  /// @brief Run when mouse wheel is scrollen and this GuiObject is focused
  /// @param iEventGetCount Number of mousewheel scroll ticks
  void editValMouse(float iEventGetCount) {
    iEventGetCount *= stepSize;
    if (keyPressed  &&  key==CODED  &&  keyCode==CONTROL) {
      iEventGetCount *= 10;
    } else if (keyPressed  &&  key==CODED  &&  keyCode==SHIFT) {
      iEventGetCount *= 100;
    }
    valStr = str(float(valStr)-iEventGetCount);
  }

  /// @brief Prototype function for value edit via keyboard
  void editValKey() {
  }

  /// @brief Prototype function for GuiObject display
  void display() {
  }

  /// @brief Checks for mouse over and click inside focused GuiObject's hitbox
  /// @return true if mouse was clicked inside focused GuiObject's hitbox, else false
  boolean checkMouseOver() {
    if (mouseX > pos.x  &&  mouseX < (pos.x+size.x)  &&  mouseY > pos.y  &&  mouseY < (pos.y+size.y)) {
      if (flag  &&  mousePressed) {
        flag = false;
        // Setting of selectedGuiObject moved to child classes because some of them (f.ex. Button) arent't supposed to be a selectedGuiObject
        return(true);
      }
    }
    return(false);
  }
}

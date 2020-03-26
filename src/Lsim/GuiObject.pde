class GuiObject {
  PVector offset;     // Position offset, added to temporary position before saving to pos
  PVector pos;        // Actual element pos, used for mouseover/displaying, set by "parent" Expandable
  PVector size;

  Fixture fixObjRef;
  Cuboid cubObjRef;
  Pixel pixObjRef;
  Expandable expObjRef;
  String objType = "";

  String propName = "";
  String valStr = "42.0";
  float stepSize = 1.0;
  color clr = color(255, 0, 255);

  // Overloaded constructor for every object type reference
  GuiObject(PVector iOffset, PVector iSize, String iPropName, float iInitialVal, float iStepSize) {
    objType = "None";
    init(iOffset, iSize, iPropName, iInitialVal, iStepSize);  // Initialize object type independent properties
  }
  GuiObject(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    fixObjRef = iObjRef;
    objType = "Fixture";
    init(iOffset, iSize, iPropName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    cubObjRef = iObjRef;
    objType = "Cuboid";
    init(iOffset, iSize, iPropName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    pixObjRef = iObjRef;
    objType = "Pixel";
    init(iOffset, iSize, iPropName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    expObjRef = iObjRef;
    objType = "Expandable";
    init(iOffset, iSize, iPropName, iInitialVal, iStepSize);
  }
  void init(PVector iOffset, PVector iSize, String iPropName, float iInitialVal, float iStepSize) {
    offset = iOffset;
    pos = new PVector(0, 0);
    size = iSize;
    propName = iPropName;
    valStr = str(iInitialVal);
    stepSize = iStepSize;
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

  boolean checkMouseOver() {  	 // returns true if mouse was clicked inside box
    if (mouseX > pos.x  &&  mouseX < (pos.x+size.x)  &&  mouseY > pos.y  &&  mouseY < (pos.y+size.y)) {
      if (flag  &&  mousePressed) {
        flag = false;
        selectedGuiObject = this;
        return(true);
      }
    }
    return(false);
  }
}

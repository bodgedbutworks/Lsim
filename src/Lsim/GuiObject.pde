class GuiObject {
  PVector pos;    // Modified automatically in draw() to align objects
  PVector size;

  Fixture fixObjRef;
  Cuboid cubObjRef;
  Pixel pixObjRef;
  String objType = "";

  String propName = "";
  String valStr = "42.0";
  float stepSize = 1.0;
  color clr = color(255, 0, 255);

  // Overloaded constructor for every object type reference
  GuiObject(PVector iPos, PVector iSize, String iPropName, float iInitialVal, float iStepSize) {
    objType = "None";
    init(iPos, iSize, iPropName, iInitialVal, iStepSize);  // Initialize object type independent properties
  }
  GuiObject(PVector iPos, PVector iSize, Fixture iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    fixObjRef = iObjRef;
    objType = "Fixture";
    init(iPos, iSize, iPropName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iPos, PVector iSize, Cuboid iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    cubObjRef = iObjRef;
    objType = "Cuboid";
    init(iPos, iSize, iPropName, iInitialVal, iStepSize);
  }
  GuiObject(PVector iPos, PVector iSize, Pixel iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    pixObjRef = iObjRef;
    objType = "Pixel";
    init(iPos, iSize, iPropName, iInitialVal, iStepSize);
  }
  void init(PVector iPos, PVector iSize, String iPropName, float iInitialVal, float iStepSize) {
    pos = iPos;
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

  boolean checkMouseOver() {
    if (mouseX > pos.x  &&  mouseX < (pos.x+size.x)  &&  mouseY > pos.y  &&  mouseY < (pos.y+size.y)) {
      if (flag  &&  mousePressed) {
        flag = false;
        selectedGuiObject = guiList.indexOf(this);
        return(true);
      }
    }
    return(false);
  }
}

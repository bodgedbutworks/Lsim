/// Similar to SpinBox, but for integer values and with constraints
class IntBox<T extends Fixture> extends GuiObject {
  T objRef;
  int valMin = 1;
  int valMax = 512;

  IntBox(PVector iPos, PVector iSize, T iObjRef, String iPropName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iPos, iSize, iPropName, float(iInitialVal), float(iStepSize));
    objRef = iObjRef;
    valMin = iMin;
    valMax = iMax;
    valStr = str(int(valStr));
  }

  void editValKey() {
    if ((key >= '0'  &&  key <= '9')  ||  (key == '-'  &&  valStr.length() == 0)) {
      valStr += key;
    } else if (key == BACKSPACE  &&  valStr.length() > 0) {
      valStr = valStr.substring(0, valStr.length()-1);
    } else if (key == DELETE) {
      valStr = str(valMin);
    } else if (key == ENTER) {
      print("Print valStr: " + valStr);
    }
  }

  void display() {
    checkMouseOver();
    noStroke();
    fill((selectedGuiObject==guiList.indexOf(this)) ? 220+35*sin(millis()/75.0) : 255);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y);
    fill(0);
    textSize(size.y/2);
    textAlign(LEFT, TOP);
    text(valStr, pos.x, pos.y, pos.x+size.x, pos.y+size.y);
    fill(50, 255, 50);
    text(propName, pos.x+size.x+SIZE_GUTTER, pos.y);

    valStr = str(constrain(int(valStr), valMin, valMax));

    // ToDo: Is there a smarter way to do this??
    if (propName.equals("Channel Pan")) {
      objRef.chanPan = int(valStr);
    } else if (propName.equals("Channel Tilt")) {
      objRef.chanTilt = int(valStr);
    } else if (propName.equals("Channel Dimmer")) {
      objRef.chanDimmer = int(valStr);
    } else if (propName.equals("Universe")) {
      objRef.universe = int(valStr);
    } else if (propName.equals("Address")) {
      objRef.address = int(valStr);
    } else if (propName.equals("Pan Angle")) {
      objRef.panAngle = int(valStr);
    } else if (propName.equals("Tilt Angle")) {
      objRef.tiltAngle = int(valStr);
    }
  }
}

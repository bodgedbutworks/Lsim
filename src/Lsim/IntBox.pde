class IntBox<T extends Fixture> extends GuiObject {
  T objRef;
  int valMin = 1;
  int valMax = 512;

  IntBox(PVector iPos, PVector iSize, T iObjRef, String iPropName, int iInitialVal, int iMin, int iMax) {
    super(iPos, iSize, iPropName, float(iInitialVal));
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
    textSize(size.y/1.5);
    textAlign(LEFT, TOP);
    text(valStr, pos.x, pos.y, pos.x+size.x, pos.y+size.y);
    fill(50, 255, 50);
    text(propName, pos.x+size.x+SIZE_GUTTER, pos.y);

    valStr = str(constrain(int(valStr), valMin, valMax));

    // ToDo: Is there a smarter way to do this??
    if (propName.equals("Channel Pan")) {
      objRef.chanPan = int(valStr);
    }
  }
}

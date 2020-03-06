class SpinBox<T extends ScreenObject> extends GuiObject {
  T objRef;

  SpinBox(PVector iPos, PVector iSize, T iObjRef, String iPropName, float iInitialVal) {
    super(iPos, iSize, iPropName, iInitialVal);
    objRef = iObjRef;
  }

  void editValKey() {
    if ((key >= '0'  &&  key <= '9')  ||  (key == '.'  &&  valStr.indexOf('.') == -1)  ||  (key == '-'  &&  valStr.length() == 0)) {
      valStr += key;
    } else if (key == BACKSPACE  &&  valStr.length() > 0) {
      valStr = valStr.substring(0, valStr.length()-1);
    } else if (key == DELETE) {
      valStr = "";
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

    // ToDo: Is there a smarter way to do this??
    if (propName.equals("pos3d.x")) {
      objRef.pos3d.x = float(valStr);
    } else if (propName.equals("pos3d.y")) {
      objRef.pos3d.y = float(valStr);
    } else if (propName.equals("pos3d.z")) {
      objRef.pos3d.z = float(valStr);
    } else if (propName.equals("rot.x")) {
      objRef.rot.x = float(valStr);
    } else if (propName.equals("rot.y")) {
      objRef.rot.y = float(valStr);
    } else if (propName.equals("rot.z")) {
      objRef.rot.z = float(valStr);
    }
  }
}

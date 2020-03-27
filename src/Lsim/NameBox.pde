class NameBox extends GuiObject {
  NameBox(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }
  NameBox(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }
  NameBox(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }

  void editValKey() {
    if ((key >= 'a'  &&  key <= 'z')  ||  (key >= 'A'  &&  key <= 'Z')  ||  (key >= '0'  &&  key <= '9')) {
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
    if (checkMouseOver()) {
      selectedGuiObject = this;
    }
    //valStr = str(float(int(float(valStr)*100)/100));
    noStroke();
    fill((selectedGuiObject==this) ? 220+35*sin(millis()/75.0) : 255);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y);
    fill(0);
    textSize(size.y/2);
    textAlign(LEFT, TOP);
    text(valStr, pos.x, pos.y, pos.x+size.x, pos.y+size.y);
    fill(50, 255, 50);
    text(propName, pos.x+size.x+SIZE_GUTTER, pos.y);

    // ToDo: Is there a smarter way to do this??
    if (objType.equals("Fixture")) {
      if (propName.equals("name")) {
        fixObjRef.name = valStr;
      }
    } else if (objType.equals("Cuboid")) {
      if (propName.equals("name")) {
        cubObjRef.name = valStr;
      }
    } else if (objType.equals("Pixel")) {
      if (propName.equals("name")) {
        pixObjRef.name = valStr;
      }
    }
  }
}

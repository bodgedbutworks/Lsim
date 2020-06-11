class NameBox extends GuiObject {
  NameBox(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }
  NameBox(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }
  NameBox(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }
  NameBox(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, String iInitialVal) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, 1.0/*stepSize*/);
  }

  void editValMouse(float iEventGetCount) {
    /* Ovverride parent class function to prevent string edit on scroll */
  }

  void editValKey() {
    if ((key >= 'a'  &&  key <= 'z')  ||  (key >= 'A'  &&  key <= 'Z')  ||  (key >= '0'  &&  key <= '9')  ||  key == ' ') {
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
    fill((selectedGuiObject==this) ? 220+25*sin(millis()/100.0) : 255);
    rect(getPosition().x, getPosition().y, getPosition().x+getSize().x, getPosition().y+getSize().y, 3);
    fill(0);
    textSize(getSize().y/2);
    textAlign(LEFT, TOP);
    text(valStr, getPosition().x+2, getPosition().y+4, getPosition().x+getSize().x-2, getPosition().y+getSize().y-4);
    fill(50, 255, 50);
    text(displayName, getPosition().x+getSize().x+SIZE_GUTTER, getPosition().y);

    // ToDo: Is there a smarter way to do this??
    if (objType.equals("Fixture")) {
      if (propName.equals("name")) {
        getObjektRefFixture().name = valStr;
      }
    } else if (objType.equals("Cuboid")) {
      if (propName.equals("name")) {
        getObjektRefCuboud().name = valStr;
      }
    } else if (objType.equals("Pixel")) {
      if (propName.equals("name")) {
        getObjektRefPixel().name = valStr;
      }
    } else if (objType.equals("None")) {
      if (propName.equals("projectName")) {
        projectName = valStr;
      }
    }
  }
}

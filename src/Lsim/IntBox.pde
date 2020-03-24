/// Similar to SpinBox, but for integer values and with constraints
class IntBox extends GuiObject {
  int valMin = 1;   // ToDo: Move min and max constraints to GuiObject class, relevant for SpinBox as well
  int valMax = 512;

  IntBox(PVector iPos, PVector iSize, Fixture iObjRef, String iPropName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iPos, iSize, iObjRef, iPropName, float(iInitialVal), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valStr = str(int(valStr));
  }
  IntBox(PVector iPos, PVector iSize, Cuboid iObjRef, String iPropName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iPos, iSize, iObjRef, iPropName, float(iInitialVal), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valStr = str(int(valStr));
  }
  IntBox(PVector iPos, PVector iSize, Pixel iObjRef, String iPropName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iPos, iSize, iObjRef, iPropName, float(iInitialVal), float(iStepSize));
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
    valStr = str(int(valStr));
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
    if (objType.equals("Fixture")) {
      if (propName.equals("Universe")) {
        fixObjRef.universe = int(valStr);
      } else if (propName.equals("Address")) {
        fixObjRef.address = int(valStr);
      } else if (propName.equals("Pan Angle")) {
        fixObjRef.panAngle = int(valStr);
      } else if (propName.equals("Tilt Angle")) {
        fixObjRef.tiltAngle = int(valStr);
      } else if (propName.equals("Channel Pan")) {
        fixObjRef.chanPan = int(valStr);
      } else if (propName.equals("Channel Tilt")) {
        fixObjRef.chanTilt = int(valStr);
      }
    } else if (objType.equals("Cuboid")) {
      /* Cuboid stuff here */
    } else if (objType.equals("Pixel")) {
      if (propName.equals("Zoom Angle Min")) {
        pixObjRef.zoomAngleMin = int(valStr);
      } else if (propName.equals("Zoom Angle Max")) {
        pixObjRef.zoomAngleMax = int(valStr);
      } else if (propName.equals("Lens Size")) {
        pixObjRef.lensSize = int(valStr);
      } else if (propName.equals("Channel Dimmer")) {
        pixObjRef.chanDimmer = int(valStr);
      } else if (propName.equals("Channel Zoom")) {
        pixObjRef.chanZoom = int(valStr);
      } else if (propName.equals("Channel Red")) {
        pixObjRef.chanClrR = int(valStr);
      } else if (propName.equals("Channel Green")) {
        pixObjRef.chanClrG = int(valStr);
      } else if (propName.equals("Channel Blue")) {
        pixObjRef.chanClrB = int(valStr);
      } else if (propName.equals("Channel White")) {
        pixObjRef.chanClrW = int(valStr);
      }
    }
  }
}

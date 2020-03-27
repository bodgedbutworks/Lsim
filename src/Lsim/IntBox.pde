/// Similar to SpinBox, but for integer values and with constraints
class IntBox extends GuiObject {
  int valMin = 1;   // ToDo: Move min and max constraints to GuiObject class, relevant for SpinBox as well
  int valMax = 512;

  IntBox(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, float(iInitialVal), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valStr = str(int(valStr));
  }
  IntBox(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, float(iInitialVal), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valStr = str(int(valStr));
  }
  IntBox(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, float(iInitialVal), float(iStepSize));
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
    fill((selectedGuiObject==this) ? 220+35*sin(millis()/75.0) : 255);
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
      } else if (propName.equals("Pan Size LR")) {
        fixObjRef.sizePan.x = int(valStr);
      } else if (propName.equals("Pan Size UD")) {
        fixObjRef.sizePan.y = int(valStr);
      } else if (propName.equals("Pan Size FB")) {
        fixObjRef.sizePan.z = int(valStr);
      } else if (propName.equals("Tilt Size LR")) {
        fixObjRef.sizeTilt.x = int(valStr);
      } else if (propName.equals("Tilt Size FB")) {
        fixObjRef.sizeTilt.y = int(valStr);
      } else if (propName.equals("Tilt Size UD")) {
        fixObjRef.sizeTilt.z = int(valStr);
      }
    } else if (objType.equals("Cuboid")) {
      /* Cuboid stuff here */
    } else if (objType.equals("Pixel")) {
      if (propName.equals("Pixel Width")) {
        pixObjRef.faceSize.x = int(valStr);
        pixObjRef.updateBeam();
      } else if (propName.equals("Pixel Height")) {
        pixObjRef.faceSize.y = int(valStr);
        pixObjRef.updateBeam();
      } else if (propName.equals("Zoom Angle Min")) {
        pixObjRef.zoomAngleMin = int(valStr);
        pixObjRef.updateBeam();
      } else if (propName.equals("Zoom Angle Max")) {
        pixObjRef.zoomAngleMax = int(valStr);
        pixObjRef.updateBeam();
      } else if (propName.equals("Rel. Channel Dimmer")) {
        pixObjRef.chanDimmer = int(valStr);
      } else if (propName.equals("Rel. Channel Zoom")) {
        pixObjRef.chanZoom = int(valStr);
      } else if (propName.equals("Rel. Channel Red")) {
        pixObjRef.chanClrR = int(valStr);
      } else if (propName.equals("Rel. Channel Green")) {
        pixObjRef.chanClrG = int(valStr);
      } else if (propName.equals("Rel. Channel Blue")) {
        pixObjRef.chanClrB = int(valStr);
      } else if (propName.equals("Rel. Channel White")) {
        pixObjRef.chanClrW = int(valStr);
      }
    }
  }
}

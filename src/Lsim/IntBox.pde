/// @brief Class similar to SpinBox, but for integer values and with constraints
class IntBox extends GuiObject {
  int valMin = 1;   // ToDo: Move min and max constraints to GuiObject class, relevant for SpinBox as well
  int valMax = 512;
  int valDeac = -99999;    // Deactivation value, changes IntBox color

  IntBox(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax, int ivalDeac) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(float(iInitialVal)), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valDeac = ivalDeac;
    valStr = str(int(valStr));
  }
  IntBox(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax, int ivalDeac) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(float(iInitialVal)), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valDeac = ivalDeac;
    valStr = str(int(valStr));
  }
  IntBox(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax, int ivalDeac) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(float(iInitialVal)), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valDeac = ivalDeac;
    valStr = str(int(valStr));
  }
  IntBox(PVector iOffset, PVector iSize, Dynamics iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax, int ivalDeac) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(float(iInitialVal)), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valDeac = ivalDeac;
    valStr = str(int(valStr));
  }

  /// @brief Handles value edit via keyboard
  void editValKey() {                                                           // run only when a key is pressed
    if ((key >= '0'  &&  key <= '9')  ||  (key == '-'  &&  utilStr.length() == 0)) {
      utilStr += key;
      keyEditState = 1;
    } else if (key == BACKSPACE  &&  utilStr.length() > 0) {
      utilStr = utilStr.substring(0, utilStr.length()-1);
      keyEditState = 1;
    } else if (key == DELETE) {
      utilStr = "";
      keyEditState = 1;
    }

    if (keyEditState == 1) {
      if (key == ENTER) {
        valStr = utilStr;
        keyEditState = 0;
      }
    }
  }

  /// @brief Displays Object, handles mouse over/pressed, decides what to do if the value changes
  void display() {
    if (checkMouseOver()) {
      selectedGuiObject = this;
      utilStr = new String(valStr);
    }
    if (selectedGuiObject != this) {
      keyEditState = 0;
    }
    valStr = str(constrain(int(valStr), valMin, valMax));
    noStroke();
    if (int(valStr) != valDeac) {
      fill((selectedGuiObject==this) ? 220+25*sin(millis()/100.0) : 255);       // Flash background while selected
    } else {
      fill((selectedGuiObject==this) ? 110+20*sin(millis()/100.0) : 127);
    }
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, 3);
    fill((keyEditState==1) ? 70+70*sin(millis()/50.0) : 0);                     // Flash text while editing via
    textSize(size.y/2);
    textAlign(LEFT, TOP);
    text(((keyEditState==0) ? valStr : utilStr), pos.x+2, pos.y+4, pos.x+size.x-2, pos.y+size.y-4);
    fill(50, 255, 50);
    text(displayName, pos.x+size.x+SIZE_GUTTER, pos.y);

    // ToDo: Is there a smarter way to do this??
    if (objType.equals("Fixture")) {
      if (propName.equals("Universe")) {
        fixObjRef.universe = int(valStr);
      } else if (propName.equals("Address")) {
        fixObjRef.address = int(valStr);
      } else if (propName.equals("Base Size LR")) {
        fixObjRef.sizeBase.x = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Base Size UD")) {
        fixObjRef.sizeBase.y = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Base Size FB")) {
        fixObjRef.sizeBase.z = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Pan Size LR")) {
        fixObjRef.sizePan.x = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Pan Size UD")) {
        fixObjRef.sizePan.y = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Pan Size FB")) {
        fixObjRef.sizePan.z = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Tilt Size LR")) {
        fixObjRef.sizeTilt.x = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Tilt Size FB")) {
        fixObjRef.sizeTilt.y = int(valStr);
        fixObjRef.rescaleModels();
      } else if (propName.equals("Tilt Size UD")) {
        fixObjRef.sizeTilt.z = int(valStr);
        fixObjRef.rescaleModels();
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
    } else if (objType.equals("Dynamics")) {
      if (propName.equals("Channel Coarse")) {
        dynObjRef.chanCoarse = int(valStr);
      } else if (propName.equals("Channel Fine")) {
        dynObjRef.chanFine = int(valStr);
      } else if (propName.equals("Angle")) {
        dynObjRef.angle = int(valStr);
      } else if (propName.equals("Offset")) {
        dynObjRef.offset = int(valStr);
      }
    }
  }
}

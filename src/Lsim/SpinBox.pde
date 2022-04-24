/// @brief Class for all float number SpinBoxes
class SpinBox extends GuiObject {
  SpinBox(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(iInitialVal), iStepSize);
  }
  SpinBox(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(iInitialVal), iStepSize);
  }
  SpinBox(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(iInitialVal), iStepSize);
  }
  SpinBox(PVector iOffset, PVector iSize, Dynamics iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(iInitialVal), iStepSize);
  }

  /// @brief Handles value edit via keyboard
  void editValKey() {                                                           // run only when a key is pressed
    if ((key >= '0'  &&  key <= '9')  ||  (key == '.'  &&  utilStr.indexOf('.') == -1)  ||  (key == '-'  &&  utilStr.length() == 0)) {
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
    //valStr = str(float(int(float(valStr)*100)/100));
    noStroke();
    fill((selectedGuiObject==this) ? 220+25*sin(millis()/100.0) : 255);         // Flash background while selected
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, 3);
    fill((keyEditState==1) ? 70+70*sin(millis()/50.0) : 0);                     // Flash text while editing via keyboard
    textSize(size.y/2);
    textAlign(LEFT, TOP);
    text(((keyEditState==0) ? valStr : utilStr), pos.x+2, pos.y+4, pos.x+size.x-2, pos.y+size.y-4);
    fill(50, 255, 50);
    text(displayName, pos.x+size.x+SIZE_GUTTER, pos.y);

    // ToDo: Is there a smarter way to do this??
    if (objType.equals("Fixture")) {
      if (propName.equals("pos3d.x")) {
        fixObjRef.pos3d.x = float(valStr);
      } else if (propName.equals("pos3d.y")) {
        fixObjRef.pos3d.y = float(valStr);
      } else if (propName.equals("pos3d.z")) {
        fixObjRef.pos3d.z = float(valStr);
      } else if (propName.equals("rot.x")) {
        fixObjRef.rot.x = float(valStr);
      } else if (propName.equals("rot.y")) {
        fixObjRef.rot.y = float(valStr);
      } else if (propName.equals("rot.z")) {
        fixObjRef.rot.z = float(valStr);
      }
    } else if (objType.equals("Cuboid")) {
      if (propName.equals("pos3d.x")) {
        cubObjRef.pos3d.x = float(valStr);
      } else if (propName.equals("pos3d.y")) {
        cubObjRef.pos3d.y = float(valStr);
      } else if (propName.equals("pos3d.z")) {
        cubObjRef.pos3d.z = float(valStr);
      } else if (propName.equals("rot.x")) {
        cubObjRef.rot.x = float(valStr);
      } else if (propName.equals("rot.y")) {
        cubObjRef.rot.y = float(valStr);
      } else if (propName.equals("rot.z")) {
        cubObjRef.rot.z = float(valStr);
      } else if (propName.equals("size3d.x")) {
        cubObjRef.size3d.x = float(valStr);
      } else if (propName.equals("size3d.y")) {
        cubObjRef.size3d.y = float(valStr);
      } else if (propName.equals("size3d.z")) {
        cubObjRef.size3d.z = float(valStr);
      }
    } else if (objType.equals("Pixel")) {
      if (propName.equals("Pixel Pos LR")) {
        pixObjRef.pos3d.x = float(valStr);
      } else if (propName.equals("Pixel Pos UD")) {
        pixObjRef.pos3d.y = float(valStr);
      } else if (propName.equals("Pixel Pos FB")) {
        pixObjRef.pos3d.z = float(valStr);
      }
    } else if (objType.equals("Dynamics")) {
      if (propName.equals("Accel")) {
        dynObjRef.maxAcc = float(valStr);
      } else if (propName.equals("Speed")) {
        dynObjRef.maxSpd = float(valStr);
      } else if (propName.equals("Tweak")) {
        dynObjRef.maxSpdTweak = float(valStr);
      }
    }
  }
}

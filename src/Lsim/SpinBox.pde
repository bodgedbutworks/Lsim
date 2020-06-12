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
    rect(getPosition().x, getPosition().y, getPosition().x+getSize().x, getPosition().y+getSize().y, 3);
    fill((keyEditState==1) ? 70+70*sin(millis()/50.0) : 0);                     // Flash text while editing via keyboard
    textSize(getSize().y/2);
    textAlign(LEFT, TOP);
    text(((keyEditState==0) ? valStr : utilStr), getPosition().x+2, getPosition().y+4, getPosition().x+getSize().x-2, getPosition().y+getSize().y-4);
    fill(50, 255, 50);
    text(displayName, getPosition().x+getSize().x+SIZE_GUTTER, getPosition().y);

    // ToDo: Is there a smarter way to do this??
    if (getObjTyp().equals("Fixture")) {
      if (propName.equals("pos3d.x")) {
        getObjektRefFixture().getPosition().x = float(valStr);
      } else if (propName.equals("pos3d.y")) {
        getObjektRefFixture().getPosition().y = float(valStr);
      } else if (propName.equals("pos3d.z")) {
        getObjektRefFixture().getPosition().z = float(valStr);
      } else if (propName.equals("rot.x")) {
        getObjektRefFixture().getRotation().x = float(valStr);
      } else if (propName.equals("rot.y")) {
        getObjektRefFixture().getRotation().y = float(valStr);
      } else if (propName.equals("rot.z")) {
        getObjektRefFixture().getRotation().z = float(valStr);
      }
    } else if (getObjTyp().equals("Cuboid")) {
      if (propName.equals("pos3d.x")) {
        getObjektRefCuboud().getPosition().x = float(valStr);
      } else if (propName.equals("pos3d.y")) {
        getObjektRefCuboud().getPosition().y = float(valStr);
      } else if (propName.equals("pos3d.z")) {
        getObjektRefCuboud().getPosition().z = float(valStr);
      } else if (propName.equals("rot.x")) {
        getObjektRefCuboud().getRotation().x = float(valStr);
      } else if (propName.equals("rot.y")) {
        getObjektRefCuboud().getRotation().y = float(valStr);
      } else if (propName.equals("rot.z")) {
        getObjektRefCuboud().getRotation().z = float(valStr);
      } else if (propName.equals("size3d.x")) {
        getObjektRefCuboud().size3d.x = float(valStr);
      } else if (propName.equals("size3d.y")) {
        getObjektRefCuboud().size3d.y = float(valStr);
      } else if (propName.equals("size3d.z")) {
        getObjektRefCuboud().size3d.z = float(valStr);
      }
    } else if (getObjTyp().equals("Pixel")) {
      if (propName.equals("Pixel Pos LR")) {
        getObjektRefPixel().pos3d.x = float(valStr);
      } else if (propName.equals("Pixel Pos UD")) {
        getObjektRefPixel().pos3d.y = float(valStr);
      } else if (propName.equals("Pixel Pos FB")) {
        getObjektRefPixel().pos3d.z = float(valStr);
      }
    } else if (getObjTyp().equals("Dynamics")) {
      if (propName.equals("Accel")) {
        getObjektRefDynamix().maxAcc = float(valStr);
      } else if (propName.equals("Speed")) {
        getObjektRefDynamix().maxSpd = float(valStr);
      } else if (propName.equals("Tweak")) {
        getObjektRefDynamix().maxSpdTweak = float(valStr);
      }
    }
  }
}

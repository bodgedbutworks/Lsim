class SpinBox extends GuiObject {
  SpinBox(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iInitialVal, iStepSize);
  }
  SpinBox(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iInitialVal, iStepSize);
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
    //valStr = str(float(int(float(valStr)*100)/100));
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
      } else if (propName.equals("Pan Accel")) {
        fixObjRef.pan.maxAcc = float(valStr);
      } else if (propName.equals("Pan Speed")) {
        fixObjRef.pan.maxSpd = float(valStr);
      } else if (propName.equals("Pan Tweak")) {
        fixObjRef.pan.maxSpdTweak = float(valStr);
      } else if (propName.equals("Tilt Accel")) {
        fixObjRef.tilt.maxAcc = float(valStr);
      } else if (propName.equals("Tilt Speed")) {
        fixObjRef.tilt.maxSpd = float(valStr);
      } else if (propName.equals("Tilt Tweak")) {
        fixObjRef.tilt.maxSpdTweak = float(valStr);
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
    }
  }
}

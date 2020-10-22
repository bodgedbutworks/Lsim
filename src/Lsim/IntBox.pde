/**
* @brief spinBox with integer values and with constraints
* @see SpinBox
*/
/// Similar to SpinBox, but for integer values and with constraints
class IntBox<T extends IGuiObject> extends GuiObject {
  int valMin = 1;   // ToDo: Move min and max constraints to GuiObject class, relevant for SpinBox as well
  int valMax = 512;
  int valDeac = -99999;    // Deactivation value, changes IntBox color

  IntBox(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax, int ivalDeac) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, str(float(iInitialVal)), float(iStepSize));
    valMin = iMin;
    valMax = iMax;
    valDeac = ivalDeac;
    valStr = str(int(valStr));
  }

  /**
  * @brief Handles value edit via keyboard
  */
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

  /**
  * @brief Displays Object, handles mouse over/pressed, decides what to do if the value changes
  */
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
    rect(getPosition().x, getPosition().y, getPosition().x+getSize().x, getPosition().y+getSize().y, 3);
    fill((keyEditState==1) ? 70+70*sin(millis()/50.0) : 0);                     // Flash text while editing via
    textSize(getSize().y/2);
    textAlign(LEFT, TOP);
    text(((keyEditState==0) ? valStr : utilStr), getPosition().x+2, getPosition().y+4, getPosition().x+getSize().x-2, getPosition().y+getSize().y-4);
    fill(50, 255, 50);
    text(displayName, getPosition().x+getSize().x+SIZE_GUTTER, getPosition().y);

    // ToDo: Is there a smarter way to do this??
    if (getObjTyp().equals("Fixture")) {
      if (propName.equals("Universe")) {
        getObjektRefFixture().universe = int(valStr);
      } else if (propName.equals("Address")) {
        getObjektRefFixture().address = int(valStr);
      } else if (propName.equals("Base Size LR")) {
        getObjektRefFixture().sizeBase.x = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Base Size UD")) {
        getObjektRefFixture().sizeBase.y = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Base Size FB")) {
        getObjektRefFixture().sizeBase.z = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Pan Size LR")) {
        getObjektRefFixture().sizePan.x = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Pan Size UD")) {
        getObjektRefFixture().sizePan.y = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Pan Size FB")) {
        getObjektRefFixture().sizePan.z = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Tilt Size LR")) {
        getObjektRefFixture().sizeTilt.x = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Tilt Size FB")) {
        getObjektRefFixture().sizeTilt.y = int(valStr);
        getObjektRefFixture().rescaleModels();
      } else if (propName.equals("Tilt Size UD")) {
        getObjektRefFixture().sizeTilt.z = int(valStr);
        getObjektRefFixture().rescaleModels();
      }
    } else if (getObjTyp().equals("Cuboid")) {
      /* Cuboid stuff here */
    } else if (getObjTyp().equals("Pixel")) {
      if (propName.equals("Pixel Width")) {
        getObjektRefPixel().faceSize.x = int(valStr);
        getObjektRefPixel().updateBeam();
      } else if (propName.equals("Pixel Height")) {
        getObjektRefPixel().faceSize.y = int(valStr);
        getObjektRefPixel().updateBeam();
      } else if (propName.equals("Zoom Angle Min")) {
        getObjektRefPixel().zoomAngleMin = int(valStr);
        getObjektRefPixel().updateBeam();
      } else if (propName.equals("Zoom Angle Max")) {
        getObjektRefPixel().zoomAngleMax = int(valStr);
        getObjektRefPixel().updateBeam();
      } else if (propName.equals("Rel. Channel Dimmer")) {
        getObjektRefPixel().chanDimmer = int(valStr);
      } else if (propName.equals("Rel. Channel Zoom")) {
        getObjektRefPixel().chanZoom = int(valStr);
      } else if (propName.equals("Rel. Channel Red")) {
        getObjektRefPixel().chanClrR = int(valStr);
      } else if (propName.equals("Rel. Channel Green")) {
        getObjektRefPixel().chanClrG = int(valStr);
      } else if (propName.equals("Rel. Channel Blue")) {
        getObjektRefPixel().chanClrB = int(valStr);
      } else if (propName.equals("Rel. Channel White")) {
        getObjektRefPixel().chanClrW = int(valStr);
      }
    } else if (getObjTyp().equals("Dynamics")) {
      if (propName.equals("Channel Coarse")) {
        getObjektRefDynamix().chanCoarse = int(valStr);
      } else if (propName.equals("Channel Fine")) {
        getObjektRefDynamix().chanFine = int(valStr);
      } else if (propName.equals("Angle")) {
        getObjektRefDynamix().angle = int(valStr);
      } else if (propName.equals("Offset")) {
        getObjektRefDynamix().offset = int(valStr);
      }
    }
  }
}

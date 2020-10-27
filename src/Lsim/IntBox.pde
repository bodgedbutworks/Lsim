/**
* @brief spinBox with integer values and with constraints
* @see SpinBox
*/
/// Similar to SpinBox, but for integer values and with constraints
class IntBox<T extends IGuiObject> extends SpinBox {
  int valMin = 1;   // ToDo: Move min and max constraints to GuiObject class, relevant for SpinBox as well
  int valMax = 512;
  int valDeac = -99999;    // Deactivation value, changes IntBox color

  IntBox(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, int iInitialVal, int iStepSize, int iMin, int iMax, int ivalDeac) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, iStepSize);
    valMin = iMin;
    valMax = iMax;
    valDeac = ivalDeac;
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
        this.valNr = float(utilStr);
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
      utilStr = new String(this.valNr);
    }
    if (selectedGuiObject != this) {
      keyEditState = 0;
    }
    this.valNr = constrain(int(this.valNr), valMin, valMax);
    noStroke();
    if (int(this.valNr) != valDeac) {
      fill((selectedGuiObject==this) ? 220+25*sin(millis()/100.0) : 255);       // Flash background while selected
    } else {
      fill((selectedGuiObject==this) ? 110+20*sin(millis()/100.0) : 127);
    }
    rect(getPosition().x, getPosition().y, getPosition().x+getSize().x, getPosition().y+getSize().y, 3);
    fill((keyEditState==1) ? 70+70*sin(millis()/50.0) : 0);                     // Flash text while editing via
    textSize(getSize().y/2);
    textAlign(LEFT, TOP);
    text(((keyEditState==0) ? this.valNr : utilStr), getPosition().x+2, getPosition().y+4, getPosition().x+getSize().x-2, getPosition().y+getSize().y-4);
    fill(50, 255, 50);
    text(displayName, getPosition().x+getSize().x+SIZE_GUTTER, getPosition().y);

/*
    // ToDo: Is there a smarter way to do this??
    if (getObjTyp().equals("Fixture")) {
      if (this.properName.equals("Universe")) {
        getObjektRefFixture().universe = int(this.valNr);
      } else if (this.properName.equals("Address")) {
        getObjektRefFixture().address = int(this.valNr);
      } else if (this.properName.equals("Base Size LR")) {
        getObjektRefFixture().sizeBase.x = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Base Size UD")) {
        getObjektRefFixture().sizeBase.y = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Base Size FB")) {
        getObjektRefFixture().sizeBase.z = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Pan Size LR")) {
        getObjektRefFixture().sizePan.x = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Pan Size UD")) {
        getObjektRefFixture().sizePan.y = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Pan Size FB")) {
        getObjektRefFixture().sizePan.z = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Tilt Size LR")) {
        getObjektRefFixture().sizeTilt.x = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Tilt Size FB")) {
        getObjektRefFixture().sizeTilt.y = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      } else if (this.properName.equals("Tilt Size UD")) {
        getObjektRefFixture().sizeTilt.z = int(this.valNr);
        getObjektRefFixture().rescaleModels();
      }
    } else if (getObjTyp().equals("Cuboid")) {
      // Cuboid stuff here 
    } else if (getObjTyp().equals("Pixel")) {
      if (this.properName.equals("Pixel Width")) {
        getObjektRefPixel().faceSize.x = int(this.valNr);
        getObjektRefPixel().updateBeam();
      } else if (this.properName.equals("Pixel Height")) {
        getObjektRefPixel().faceSize.y = int(this.valNr);
        getObjektRefPixel().updateBeam();
      } else if (this.properName.equals("Zoom Angle Min")) {
        getObjektRefPixel().zoomAngleMin = int(this.valNr);
        getObjektRefPixel().updateBeam();
      } else if (this.properName.equals("Zoom Angle Max")) {
        getObjektRefPixel().zoomAngleMax = int(this.valNr);
        getObjektRefPixel().updateBeam();
      } else if (this.properName.equals("Rel. Channel Dimmer")) {
        getObjektRefPixel().chanDimmer = int(this.valNr);
      } else if (this.properName.equals("Rel. Channel Zoom")) {
        getObjektRefPixel().chanZoom = int(this.valNr);
      } else if (this.properName.equals("Rel. Channel Red")) {
        getObjektRefPixel().chanClrR = int(this.valNr);
      } else if (this.properName.equals("Rel. Channel Green")) {
        getObjektRefPixel().chanClrG = int(this.valNr);
      } else if (this.properName.equals("Rel. Channel Blue")) {
        getObjektRefPixel().chanClrB = int(this.valNr);
      } else if (this.properName.equals("Rel. Channel White")) {
        getObjektRefPixel().chanClrW = int(this.valNr);
      }
    } else if (getObjTyp().equals("Dynamics")) {
      if (this.properName.equals("Channel Coarse")) {
        getObjektRefDynamix().chanCoarse = int(this.valNr);
      } else if (this.properName.equals("Channel Fine")) {
        getObjektRefDynamix().chanFine = int(this.valNr);
      } else if (this.properName.equals("Angle")) {
        getObjektRefDynamix().angle = int(this.valNr);
      } else if (this.properName.equals("Offset")) {
        getObjektRefDynamix().offset = int(this.valNr);
      }
    }
*/
  }
}

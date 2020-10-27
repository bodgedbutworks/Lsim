/**
* @brief float number SpinBoxes
* @see SpinBoxes
*/
class SpinBox<T extends IGuiObject> extends GuiObject {

  private Consumer<Float>variableChanger;
  
  SpinBox(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  
  SpinBox(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize, Consumer<Float> iVariableChanger) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, iStepSize);
    this.variableChanger = iVariableChanger;
  }

  /**
  * @brief Handles value edit via keyboard
  */
  void editValKey() {                                                           // run only when a key is pressed
    if ((key >= '0'  &&  key <= '9')  ||  (key == '.'  &&  utilStr.indexOf('.') == -1)  ||  (key == '-'  &&  utilStr.length() == 0)) {
      utilStr += key;
      //this.faderValue = key;
      keyEditState = 1;
    } else if (key == BACKSPACE  &&  utilStr.length() > 0) {
      utilStr = utilStr.substring(0, utilStr.length()-1);
      //this.faderValue = getObjektRefFixture().getPosition().x / 10;
      keyEditState = 1;
    } else if (key == DELETE) {
      utilStr = "";
      //this.faderValue = 0;
      keyEditState = 1;
    }

    if (keyEditState == 1) {
      if (key == ENTER) {
        valStr = utilStr;
        this.variableChanger.accept(float (valStr));
        //this.faderValue = 0;
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

  }
}

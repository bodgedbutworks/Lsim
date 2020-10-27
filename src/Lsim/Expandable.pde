/**
* @brief Expandable GUI objects
* alows the folding in and out in the menu
*/
class Expandable<T extends IGuiObject> extends GuiObject {
  ArrayList<GuiObject> subElementsList = new ArrayList<GuiObject>();
  Button expandBtn;                                                             // 0=closed, 1=expanding, 2=expanded, 3=closing
  boolean hasButton = true;
  byte state = 0;

  Expandable(PVector iOffset, PVector iSize, String iDisplayName, boolean iHasButton, boolean iDefaultOpen, color iClr) {
     super(iOffset, iSize, ""/*propName*/     , iDisplayName, 0.0/*initialVal*/    , 1.0/*stepSize*/);
    hasButton = iHasButton;
    if (hasButton) {
      expandBtn = new Button(new PVector(0, 0), new PVector(120, 40), this, "state", iDisplayName, iClr);
    }
    if (iDefaultOpen) {
      state = 2;
    } else {
      state = 0;
    }
  }

  /**
  * @brief Adds another element to the expandable list
  *  @param iGuiObj : The Object to include
  */
  void put(GuiObject iGuiObj) {                                                  // For increased shortness when adding elements
    subElementsList.add(iGuiObj);
  }

  /**
  * @brief Displays the object in all states
  * The object can be in following states : closed, expanding, expanded
  */
  void display() {
    if (hasButton) {
      expandBtn.setPosition(getPosition().copy());
      expandBtn.display();
    }

    switch(state) {
    case 0:
      break;
    case 1:
      state = 2;
      break;
    case 2:
      break;
    case 3:
      state = 0;
      break;
    default:
      break;
    }

    PVector tempPos = getPosition().copy();                                                // get() -> clone tempPos instead of creating a reference
    if (hasButton) {
      tempPos.add(new PVector(0, expandBtn.getOffset().y));
      tempPos.add(new PVector(0, expandBtn.getSize().y));
      tempPos.add(new PVector(0, SIZE_GUTTER));
    }
    if (state != 0) {
      for (GuiObject g : subElementsList) {
        g.setPosition(PVector.add(tempPos, g.getOffset()));
        tempPos.add(new PVector(0, g.getOffset().y));
        tempPos.add(new PVector(0, g.getSize().y));
        tempPos.add(new PVector(0, SIZE_GUTTER));
        g.display();
      }
    } else {
      tempPos.y -= SIZE_GUTTER;                                                 // Remove Gutter offset afer Expandable open/clos button
    }
    setSize(PVector.sub(tempPos.get(), getPosition().get()));                               // determine Expandable size by summing subelement sizes
  }
}

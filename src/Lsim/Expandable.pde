/// @brief Class for all Expandable GUI Objects, allow their contained Buttons/SpinBoxes/.. to be folded in and out in menu
class Expandable extends GuiObject {
  ArrayList<GuiObject> subElementsList = new ArrayList<GuiObject>();
  Button expandBtn;                                                             // 0=closed, 1=expanding, 2=expanded, 3=closing
  boolean hasButton = true;
  byte state = 0;

  Expandable(PVector iOffset, PVector iSize, String iDisplayName, boolean iHasButton, boolean iDefaultOpen, color iClr) {
     super(iOffset, iSize, ""/*propName*/     , iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
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

  /// @brief Adds another GuiObject to this Expendable's container list
  /// @param iGuiObj The Object to include
  void put(GuiObject iGuiObj) {                                                  // For increased shortness when adding elements
    subElementsList.add(iGuiObj);
  }

  /// @brief Display the Expandable, handle state changes (closed, expanding, expanded, ..)
  void display() {
    if (hasButton) {
      expandBtn.pos = pos.copy();
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

    PVector tempPos = pos.copy();                                                // get() -> clone tempPos instead of creating a reference
    if (hasButton) {
      tempPos.add(new PVector(0, expandBtn.offset.y));
      tempPos.add(new PVector(0, expandBtn.size.y));
      tempPos.add(new PVector(0, SIZE_GUTTER));
    }
    if (state != 0) {
      for (GuiObject g : subElementsList) {
        g.pos = PVector.add(tempPos, g.offset);
        tempPos.add(new PVector(0, g.offset.y));
        tempPos.add(new PVector(0, g.size.y));
        tempPos.add(new PVector(0, SIZE_GUTTER));
        g.display();
      }
    } else {
      tempPos.y -= SIZE_GUTTER;                                                 // Remove Gutter offset afer Expandable open/clos button
    }
    size = PVector.sub(tempPos.get(), pos.get());                               // determine Expandable size by summing subelement sizes
  }
}

class Expandable extends GuiObject {
  ArrayList<GuiObject> subElementsList = new ArrayList<GuiObject>();
  Button expandBtn;                                                             // 0=closed, 1=expanding, 2=expanded, 3=closing
  boolean hasButton = true;
  byte state = 0;

  Expandable(PVector iOffset, PVector iSize, boolean iHasButton, boolean iDefaultOpen) {
     super(iOffset, iSize, ""/*propName*/    , 0.0/*initialVal*/, 1.0/*stepSize*/);
    hasButton = iHasButton;
    if (hasButton) {
      expandBtn = new Button(new PVector(0, 0), new PVector(160, 30), this, "state");
    }
    if (iDefaultOpen) {
      state = 2;
    } else {
      state = 0;
    }
  }

  void put(GuiObject iGuiObj) {                                                  // For increased shortness when adding elements
    subElementsList.add(iGuiObj);
  }

  void display() {
    hint(DISABLE_DEPTH_TEST);
    if (hasButton) {
      expandBtn.pos = pos.get();
      expandBtn.display();
    }
    println(state);

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

    if (state != 0) {
      PVector tempPos = pos.get();                                              // get() -> clone tempPos instead of creating a reference
      if (hasButton) {
        tempPos.add(new PVector(0, expandBtn.offset.y));
        tempPos.add(new PVector(0, expandBtn.size.y));
        tempPos.add(new PVector(0, SIZE_GUTTER));
      }
      for (GuiObject g : subElementsList) {
        g.pos = PVector.add(tempPos.get(), g.offset);
        tempPos.add(new PVector(0, g.offset.y));
        tempPos.add(new PVector(0, g.size.y));                        // Only vertical size
        tempPos.add(new PVector(0, SIZE_GUTTER));
        g.display();
      }
    }

    hint(ENABLE_DEPTH_TEST);
  }
}

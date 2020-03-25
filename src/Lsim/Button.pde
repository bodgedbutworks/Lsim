class Button extends GuiObject {
  Button(PVector iOffset, PVector iSize, String iPropName) {
    super(iOffset, iSize, iPropName, 0.0/*initialVal*/, 1.0/*stepSize*/);
  }
  Button(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName) {
    super(iOffset, iSize, iObjRef, iPropName, 0.0/*initialVal*/, 1.0/*stepSize*/);
  }

  void display() {
    if (checkMouseOver()) {
      if (objType.equals("Expandable")) {
        if (propName.equals("state")) {
          if (expObjRef.state == 0) {
            expObjRef.state = 1;
          } else if (expObjRef.state == 2) {
            expObjRef.state = 3;
          }
        }
      } else {
        if (propName.equals(">")) {
          if (menuState == 0) {
            menuState = 1;
          } else if (menuState == 2) {
            menuState = 3;
          }
        } else if (propName.equals("+")) {
          fixtureList.add(new Fixture());
        } else if (propName.equals("++")) {
          cuboidList.add(new Cuboid());
        } else if (propName.equals("S")) {
          saveAll();
        } else if (propName.equals("L")) {
          loadAll();
        } else if (propName.equals("*")) {
          lightsOff = !lightsOff;
        }
      }
    }
    noStroke();
    fill(clr);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, size.y/10);
    fill(0);
    textSize(size.y/map(propName.length(), 1, 5, 2, 4));
    textAlign(CENTER, CENTER);
    text(propName, pos.x+size.x/2, pos.y+size.y/2);
  }
}

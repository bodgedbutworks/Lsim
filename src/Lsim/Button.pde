class Button extends GuiObject {
  Button(PVector iOffset, PVector iSize, String iPropName, String iDisplayName) {
    super(iOffset, iSize, iPropName, iDisplayName, 0.0/*initialVal*/, 1.0/*stepSize*/);
  }
  Button(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, 0.0/*initialVal*/, 1.0/*stepSize*/);
  }
  Button(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, 0.0/*initialVal*/, 1.0/*stepSize*/);
  }
  Button(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, 0.0/*initialVal*/, 1.0/*stepSize*/);
  }

  void display() {
    if (checkMouseOver()) {
      if (objType.equals("Pixel")) {
        if (propName.equals("Ellipse")) {
          pixObjRef.faceType = "Ellipse";
        } else if (propName.equals("Rectangle")) {
          pixObjRef.faceType = "Rectangle";
        }
      } else if (objType.equals("Fixture")) {
        if (propName.equals("Fork Model")) {
          fixObjRef.panType = "Fork";
        } else if (propName.equals("Head Model")) {
          fixObjRef.tiltType = "Head";
        } else if (propName.equals("Cuboid Model")) {
          fixObjRef.tiltType = "Cuboid";
        }
      } else if (objType.equals("Expandable")) {
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
        } else if (propName.equals("loadfilename")) {
          Fixture tempFix = new Fixture();
          tempFix.setLoadArray(loadStrings(sketchPath() + PATH_FIXTURES + displayName)[0].split(";"));
          fixtureList.add(tempFix);
        }
      }
    }
    noStroke();
    fill(clr);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, size.y/10);
    fill(0);
    textSize(size.y/map(displayName.length(), 1, 5, 2, 4));
    textAlign(CENTER, CENTER);
    text(displayName, pos.x+size.x/2, pos.y+size.y/2);
  }
}

class Button extends GuiObject {
  color clr = color(255);

  Button(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    clr = iClr;
  }
  Button(PVector iOffset, PVector iSize, Fixture iObjRef, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iObjRef, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    clr = iClr;
  }
  Button(PVector iOffset, PVector iSize, Pixel iObjRef, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iObjRef, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    clr = iClr;
  }
  Button(PVector iOffset, PVector iSize, Cuboid iObjRef, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iObjRef, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    clr = iClr;
  }
  Button(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iObjRef, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    clr = iClr;
  }

  void display() {
    noStroke();
    fill(clr);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, size.y/10);
    fill(0);
    textSize(displayName.length()<3 ? width/45 : width/110);
    textAlign(CENTER, CENTER);
    text(displayName, pos.x+size.x/2, pos.y+size.y/2-3);

    if (checkMouseOver()) {
      if (objType.equals("Pixel")) {
        if (propName.equals("Ellipse")) {
          pixObjRef.faceType = "Ellipse";
        } else if (propName.equals("Rectangle")) {
          pixObjRef.faceType = "Rectangle";
        } else if (propName.equals("Copy Pixel")) {
          Pixel tempPix = new Pixel("Irrelevant", pixObjRef.parentFixRef);
          tempPix.setLoadArray(pixObjRef.getSaveString().split(";"));
          tempPix.name += " Copy";
          tempPix.pos3d.x += 40;
          pixObjRef.parentFixRef.pixelList.add(tempPix);
          reloadMyGui = pixObjRef.parentFixRef;     // Directly modifying the GUI here would lead to ConcurrentModificationException, so do in main loop
        } else if (propName.equals("Delete Pixel")) {
          pixObjRef.parentFixRef.pixelList.remove(pixObjRef);
          reloadMyGui = pixObjRef.parentFixRef;
        }
      } else if (objType.equals("Fixture")) {
        if (propName.equals("Fork Model")) {
          fixObjRef.panType = "Fork";
        } else if (propName.equals("Head Model")) {
          fixObjRef.tiltType = "Head";
        } else if (propName.equals("Cuboid Model")) {
          fixObjRef.tiltType = "Cuboid";
        } else if (propName.equals("Save Fixture")) {
          String[] tempLine = new String[1];
          tempLine[0] = fixObjRef.getSaveString();
          saveStrings(PATH_FIXTURES + fixObjRef.name + ".lsm", tempLine);
          println("Saved Fixture: " + fixObjRef.name);
        } else if (propName.equals("Copy Fixture")) {
          Fixture tempFix = new Fixture();
          tempFix.setLoadArray(fixObjRef.getSaveString().split(";"));
          tempFix.name = fixObjRef.name+" Copy";
          tempFix.pos3d.x += 200;
          fixtureList.add(tempFix);
          reloadMyGui = tempFix;
        } else if (propName.equals("Delete Fixture")) {
          fixtureList.remove(fixObjRef);
          deleteMyGui = true;
        }
      } else if (objType.equals("Cuboid")) {
        if (propName.equals("Copy Cuboid")) {
          Cuboid tempCub = new Cuboid();
          tempCub.setLoadArray(cubObjRef.getSaveString().split(";"));
          tempCub.name = cubObjRef.name+" Copy";
          tempCub.pos3d.x += 200;
          cuboidList.add(tempCub);
          reloadMyGui = tempCub;
        } else if (propName.equals("Delete Cuboid")) {
          cuboidList.remove(cubObjRef);
          deleteMyGui = true;
        }
      } else if (objType.equals("Expandable")) {
        if (propName.equals("state")) {
          if (expObjRef.state == 0) {
            expObjRef.state = 1;
          } else if (expObjRef.state == 2) {
            expObjRef.state = 3;
          }
        }
      } else if (objType.equals("None")) {
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
        } else if (propName.equals("COM")) {
          showNamesAndComs = !showNamesAndComs;
        } else if (propName.equals("*")) {
          lightsOff = !lightsOff;
        } else if (propName.equals("loadfixfilename")) {
          Fixture tempFix = new Fixture();
          tempFix.setLoadArray(loadStrings(sketchPath() + PATH_FIXTURES + displayName)[0].split(";"));
          fixtureList.add(tempFix);
        } else if (propName.equals("loadenvfilename")) {
          if (displayName.equals("None")) {
            environmentFileName = "";
            environmentShape = null;
          } else {
            environmentFileName = displayName;
            environmentShape = loadShape(sketchPath() + PATH_ENVIRONMENTS + displayName);
            environmentShape.disableStyle();                                    // Ignore the colors in the SVG
          }
        } else if (propName.equals("loadprojfilename")) {
          loadAll(displayName);
        }
      }
    }
  }
}

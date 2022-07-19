/// @brief Class for all Button GUI Elements
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

  /// @brief Displays the Button and decides what to do if the Button is pressed
  void display() {
    noStroke();
    fill(clr);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, size.y/10);
    fill(0);
    textSize((displayName.length()>=3) ? map(height, 900, 1200, 14, 15) : map(height, 900, 1200, 36, 40));
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
          tempPix.load(pixObjRef.save());
          tempPix.name += " Copy";
          tempPix.pos3d.x += 20;
          pixObjRef.parentFixRef.pixelList.add(tempPix);
          reloadMyGui = pixObjRef.parentFixRef;     // Directly modifying the GUI here would lead to ConcurrentModificationException, so do in main loop
        } else if (propName.equals("Delete Pixel")) {
          pixObjRef.parentFixRef.pixelList.remove(pixObjRef);
          reloadMyGui = pixObjRef.parentFixRef;
        }
      } else if (objType.equals("Fixture")) {
        if (propName.equals("Toggle Beams")) {
          fixObjRef.showBeams = !fixObjRef.showBeams;
        } else if (propName.equals("Plate Model")) {
          fixObjRef.baseType = "Plate";
        } else if (propName.equals("No Model")) {
          fixObjRef.baseType = "None";
        } else if (propName.equals("Fork Model")) {
          fixObjRef.panType = "Fork";
        } else if (propName.equals("Head Model")) {
          fixObjRef.tiltType = "Head";
        } else if (propName.equals("Cuboid Model")) {
          fixObjRef.tiltType = "Cuboid";
        } else if (propName.equals("Save Fixture")) {
          saveJSONObject(fixObjRef.save(), PATH_FIXTURES + fixObjRef.name + ".lsm");
          notific("Saved Fixture: " + fixObjRef.name, CLR_NOTIF_SUCCESS, TTL_SUCCESS);
        } else if (propName.equals("Copy Fixture")) {
          Fixture tempFix = new Fixture();
          tempFix.load(fixObjRef.save());
          tempFix.name = fixObjRef.name + " Copy";
          tempFix.pos3d.x += 100;
          fixtureList.add(tempFix);
          reloadMyGui = tempFix;
        } else if (propName.equals("Delete Fixture")) {
          fixtureList.remove(fixObjRef);
          deleteMyGui = true;
        }
      } else if (objType.equals("Cuboid")) {
        if (propName.equals("Copy Cuboid")) {
          Cuboid tempCub = new Cuboid();
          tempCub.load(cubObjRef.save());
          tempCub.name = cubObjRef.name + " Copy";
          tempCub.pos3d.x += 100;
          cuboidList.add(tempCub);
          reloadMyGui = tempCub;
        } else if (propName.equals("Delete Cuboid")) {
          cuboidList.remove(cubObjRef);
          deleteMyGui = true;
        } else if (propName.equals("Cuboid Model")) {
          cubObjRef.displayType = "Cuboid";
        } else if (propName.equals("Truss Model")) {
          cubObjRef.displayType = "Truss";
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
        } else if (propName.equals("B")) {
          beamsOff = !beamsOff;
        } else if (propName.equals("loadfixfilename")) {
          try {
            Fixture tempFix = new Fixture();
            tempFix.load(loadJSONObject(sketchPath() + PATH_FIXTURES + displayName));
            fixtureList.add(tempFix);
          }
          catch(Exception e) {
            notific("Error while loading Fixture " + displayName + "!", CLR_NOTIF_DANGER, TTL_DANGER);
            println(e);
          }
        } else if (propName.equals("loadenvfilename")) {
          if (displayName.equals("None")) {
            environmentFileName = "";
            environmentShape = null;
          } else {
            try {
              environmentFileName = displayName;
              environmentShape = loadShape(sketchPath() + PATH_ENVIRONMENTS + displayName);
              environmentShape.disableStyle();                                  // Ignore the colors in the SVG
            }
            catch(Exception e) {
              notific("Error while loading environment " + displayName + "!", CLR_NOTIF_DANGER, TTL_DANGER);
              println(e);
            }
          }
        } else if (propName.equals("loadprojfilename")) {
          loadAll(displayName);
        }
      }
    }
  }
}

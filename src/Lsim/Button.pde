/**
* @brief Button GUI element class
*/
class Button<T extends IGuiObject> extends GuiObject {
  //color clr = color(255);

  Button(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    super.clr = iClr;
  }
  Button(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iObjRef, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    super.clr = iClr;
  }
  Button(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, color iClr) {
     super(iOffset, iSize, iObjRef, iPropName, iDisplayName, ""/*initialVal*/    , 1.0/*stepSize*/);
    super.clr = iClr;
  }
  
  /**
  * @brief displays the button
  * TODO extzract prest in own method
  */
  void display() {
    noStroke();
    fill(clr);
    rect(getPosition().x, getPosition().y, getPosition().x+getSize().x, getPosition().y+getSize().y, getSize().y/10);
    fill(0);
    textSize((displayName.length()>=3) ? map(height, 900, 1200, 14, 15) : map(height, 900, 1200, 36, 40));
    textAlign(CENTER, CENTER);
    text(displayName, getPosition().x+getSize().x/2, getPosition().y+getSize().y/2-3);

    if (checkMouseOver()) {
      if ( getObjTyp().equals("Pixel")) {
        if (propName.equals("Ellipse")) {
          getObjektRefPixel().faceType = "Ellipse";
        } else if (propName.equals("Rectangle")) {
          getObjektRefPixel().faceType = "Rectangle";
        } else if (propName.equals("Copy Pixel")) {
          Pixel tempPix = new Pixel("Irrelevant", getObjektRefPixel().parentFixRef);
          tempPix.load(getObjektRefPixel().save());
          tempPix.name += " Copy";
          tempPix.pos3d.x += 20;
          getObjektRefPixel().parentFixRef.pixelList.add(tempPix);
          reloadMyGui = getObjektRefPixel().parentFixRef;     // Directly modifying the GUI here would lead to ConcurrentModificationException, so do in main loop
        } else if (propName.equals("Delete Pixel")) {
          getObjektRefPixel().parentFixRef.pixelList.remove(getObjektRefPixel());
          reloadMyGui = getObjektRefPixel().parentFixRef;
        }
      } else if (getObjTyp().equals("Fixture")) {
        if (propName.equals("Toggle Beams")) {
          getObjektRefFixture().showBeams = !getObjektRefFixture().showBeams;
        } else if (propName.equals("Plate Model")) {
          getObjektRefFixture().baseType = "Plate";
        } else if (propName.equals("No Model")) {
          getObjektRefFixture().baseType = "None";
        } else if (propName.equals("Fork Model")) {
          getObjektRefFixture().panType = "Fork";
        } else if (propName.equals("Head Model")) {
          getObjektRefFixture().tiltType = "Head";
        } else if (propName.equals("Cuboid Model")) {
          getObjektRefFixture().tiltType = "Cuboid";
        } else if (propName.equals("Save Fixture")) {
          saveJSONObject(getObjektRefFixture().save(), PATH_FIXTURES + getObjektRefFixture().name + ".lsm");
          notific("Saved Fixture: " + getObjektRefFixture().name, constantData.CLR_NOTIF_SUCCESS, constantData.TTL_SUCCESS);
        } else if (propName.equals("Copy Fixture")) {
          Fixture tempFix = new Fixture();
          tempFix.load(getObjektRefFixture().save());
          tempFix.name = getObjektRefFixture().name + " Copy";
          tempFix.getPosition().x += 200;
          fixtureList.add(tempFix);
          reloadMyGui = tempFix;
        } else if (propName.equals("Delete Fixture")) {
          fixtureList.remove(getObjektRefFixture());
          deleteMyGui = true;
        }
      } else if (getObjTyp().equals("Cuboid")) {
        if (propName.equals("Copy Cuboid")) {
          Cuboid tempCub = new Cuboid();
          tempCub.load(getObjektRefCuboud().save());
          tempCub.name = getObjektRefCuboud().name + " Copy";
          tempCub.getPosition().x += 200;
          cuboidList.add(tempCub);
          reloadMyGui = tempCub;
        } else if (propName.equals("Delete Cuboid")) {
          cuboidList.remove(getObjektRefCuboud());
          deleteMyGui = true;
        }
      } else if (getObjTyp().equals("Expandable")) {
        if (propName.equals("state")) {
          if (getObjektRefExpandable().state == 0) {
            getObjektRefExpandable().state = 1;
          } else if (getObjektRefExpandable().state == 2) {
            getObjektRefExpandable().state = 3;
          }
        }
      } else if (getObjTyp().equals("None")) { //change all these getObjTyp().equals("XXX") to something like objRef.class.equals(XXX.class)
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
            notific("Error while loading Fixture " + displayName + "!", constantData.CLR_NOTIF_DANGER, constantData.TTL_DANGER);
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
              notific("Error while loading environment " + displayName + "!", constantData.CLR_NOTIF_DANGER, constantData.TTL_DANGER);
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

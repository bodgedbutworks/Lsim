/**
* @brief Button GUI element class
*/
class Button<T extends IGuiObject> extends GuiObject {
  //color clr = color(255);

  Button(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, color iClr) {
    super(iOffset, iSize, iPropName, iDisplayName, 0.0 , 1.0/*stepSize*/);
    this.objectColor = iClr;
  }
  Button(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, color iClr) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, 0.0/*initialVal*/    , 1.0/*stepSize*/);
    this.objectColor = iClr;
  }
  Button(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, color iClr) {
    super(iOffset, iSize, iObjRef, iPropName, iDisplayName, 0.0/*initialVal*/    , 1.0/*stepSize*/);
    this.objectColor = iClr;
  }
  
  /**
  * @brief displays the button
  * TODO extzract prest in own method
  */
  void display() {
    noStroke();
    fill(this.objectColor);
    rect(getPosition().x, getPosition().y, getPosition().x+getSize().x, getPosition().y+getSize().y, getSize().y/10);
    fill(0);
    textSize((displayName.length()>=3) ? map(height, 900, 1200, 14, 15) : map(height, 900, 1200, 36, 40));
    textAlign(CENTER, CENTER);
    text(displayName, getPosition().x+getSize().x/2, getPosition().y+getSize().y/2-3);

    //change to setter
    if (checkMouseOver()) {
      if ( getObjTyp().equals("Pixel")) {
        if (this.properName.equals("Ellipse")) {
          getObjektRefPixel().faceType = "Ellipse";
        } else if (this.properName.equals("Rectangle")) {
          getObjektRefPixel().faceType = "Rectangle";
        } else if (this.properName.equals("Copy Pixel")) {
          Pixel tempPix = new Pixel("Irrelevant", getObjektRefPixel().parentFixRef);
          tempPix.load(getObjektRefPixel().save());
          tempPix.displayName += " Copy";
          tempPix.pos3d.x += 20;
          getObjektRefPixel().parentFixRef.pixelList.add(tempPix);
          reloadMyGui = getObjektRefPixel().parentFixRef;     // Directly modifying the GUI here would lead to ConcurrentModificationException, so do in main loop
        } else if (this.properName.equals("Delete Pixel")) {
          getObjektRefPixel().parentFixRef.pixelList.remove(getObjektRefPixel());
          reloadMyGui = getObjektRefPixel().parentFixRef;
        }
      } else if (getObjTyp().equals("Fixture")) {
        if (this.properName.equals("Toggle Beams")) {
          getObjektRefFixture().showBeams = !getObjektRefFixture().showBeams;
        } else if (this.properName.equals("Plate Model")) {
          getObjektRefFixture().baseType = "Plate";
        } else if (this.properName.equals("No Model")) {
          getObjektRefFixture().baseType = "None";
        } else if (this.properName.equals("Fork Model")) {
          getObjektRefFixture().panType = "Fork";
        } else if (this.properName.equals("Head Model")) {
          getObjektRefFixture().tiltType = "Head";
        } else if (this.properName.equals("Cuboid Model")) {
          getObjektRefFixture().tiltType = "Cuboid";
        } else if (this.properName.equals("Save Fixture")) {
          saveJSONObject(getObjektRefFixture().save(), PATH_FIXTURES + getObjektRefFixture().displayName + ".lsm");
          notific("Saved Fixture: " + getObjektRefFixture().displayName, constantData.CLR_NOTIF_SUCCESS, constantData.TTL_SUCCESS);
        } else if (this.properName.equals("Copy Fixture")) {
          Fixture tempFix = new Fixture();
          tempFix.load(getObjektRefFixture().save());
          tempFix.displayName = getObjektRefFixture().displayName + " Copy";
          tempFix.getPosition().x += 200;
          fixtureList.add(tempFix);
          reloadMyGui = tempFix;
        } else if (this.properName.equals("Delete Fixture")) {
          fixtureList.remove(getObjektRefFixture());
          deleteMyGui = true;
        }
      } else if (getObjTyp().equals("Cuboid")) {
        if (this.properName.equals("Copy Cuboid")) {
          Cuboid tempCub = new Cuboid();
          tempCub.load(getObjektRefCuboud().save());
          tempCub.displayName = getObjektRefCuboud().displayName + " Copy";
          tempCub.getPosition().x += 200;
          cuboidList.add(tempCub);
          reloadMyGui = tempCub;
        } else if (this.properName.equals("Delete Cuboid")) {
          cuboidList.remove(getObjektRefCuboud());
          deleteMyGui = true;
        }
      } else if (getObjTyp().equals("Expandable")) {
        if (this.properName.equals("state")) {
          if (getObjektRefExpandable().state == 0) {
            getObjektRefExpandable().state = 1;
          } else if (getObjektRefExpandable().state == 2) {
            getObjektRefExpandable().state = 3;
          }
        }
      } else if (getObjTyp().equals("None")) { //change all these getObjTyp().equals("XXX") to something like objRef.class.equals(XXX.class)
        if (this.properName.equals(">")) {
          if (menuState == 0) {
            menuState = 1;
          } else if (menuState == 2) {
            menuState = 3;
          }
        } else if (this.properName.equals("+")) {
          fixtureList.add(new Fixture());
        } else if (this.properName.equals("++")) {
          cuboidList.add(new Cuboid());
        } else if (this.properName.equals("S")) {
          saveAll();
        } else if (this.properName.equals("COM")) {
          showNamesAndComs = !showNamesAndComs;
        } else if (this.properName.equals("*")) {
          lightsOff = !lightsOff;
        } else if (this.properName.equals("B")) {
          beamsOff = !beamsOff;
        } else if (this.properName.equals("loadfixfilename")) {
          try {
            Fixture tempFix = new Fixture();
            tempFix.load(loadJSONObject(sketchPath() + PATH_FIXTURES + displayName));
            fixtureList.add(tempFix);
          }
          catch(Exception e) {
            notific("Error while loading Fixture " + displayName + "!", constantData.CLR_NOTIF_DANGER, constantData.TTL_DANGER);
            println(e);
          }
        } else if (this.properName.equals("loadenvfilename")) {
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
        } else if (this.properName.equals("loadprojfilename")) {
          loadAll(displayName);
        }
      }
    }
  }
}

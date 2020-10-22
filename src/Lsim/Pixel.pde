/**
* @brief Pixels class for the Fixtures with illuminated surface + beam cone
*/
class Pixel implements IGuiObject{
  Fixture parentFixRef;
  String name = "";
  PVector pos3d = new PVector(0, 0, 27);                                        // Offset realtive to fixture center of mass (COM)
  PShape modelBeam;
  color beamClr;
  int zoomAngleMin = 10;                                                        // [deg]
  int zoomAngleMax = 35;

  String faceType = "Ellipse";                                                  // Ellipse, Rectangle
  PVector faceSize = new PVector(16, 16);                                       // width & height

  int chanDimmer = 6;                                                           // offsets towards fixture address
  int chanZoom = 4;
  int chanClrR = 10;
  int chanClrG = 11;
  int chanClrB = 12;
  int chanClrW = 13;

  float dimmer = 255;
  float zoom = 255;
  float clrR = 0;
  float clrG = 255;
  float clrB = 0;
  float clrW = 0;

  Pixel(String iName, Fixture iParentFixRef) {
    parentFixRef = iParentFixRef;
    name = iName;
    updateBeam();
  }

  /**
  *  @brief Updates 3D beam cone mesh if user changes zoom angle
  */
  void updateBeam() {
    int zoomRadius = int(min(faceSize.x, faceSize.y)) + int(tan(radians(map(zoom, 0, 255, zoomAngleMin, zoomAngleMax)/2))*LENGTH_BEAMS);    // radius = tan(half beam angle) * beam length
    modelBeam = createShape();
    modelBeam.beginShape(TRIANGLE_STRIP);
    modelBeam.noStroke();
    for (int i=0; i<=RESOLUTION_BEAMS; i++) {
      modelBeam.vertex((faceSize.x/2)*sin(i*TWO_PI/RESOLUTION_BEAMS), 0, (faceSize.y/2)*cos(i*TWO_PI/RESOLUTION_BEAMS));
      modelBeam.vertex(zoomRadius*sin(i*TWO_PI/RESOLUTION_BEAMS), LENGTH_BEAMS, zoomRadius*cos(i*TWO_PI/RESOLUTION_BEAMS));
    }
    modelBeam.endShape(CLOSE);
  }

  /**
  *  @brief Get current values for all channels from DMX array
  */
  void updateChannels(int iFixtureAddress, byte[] iDmxUniverse) {
    dimmer = ((chanDimmer>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanDimmer-1, 0, 511)]) : 255);
    clrR = ((chanClrR>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanClrR-1, 0, 511)]) : 0);
    clrG = ((chanClrG>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanClrG-1, 0, 511)]) : 0);
    clrB = ((chanClrB>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanClrB-1, 0, 511)]) : 0);
    clrW = ((chanClrW>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanClrW-1, 0, 511)]) : 0);

    // ToDo: Color model is incorrect, vary dark color settings result in 'black' light output
    beamClr = color(min(clrR+clrW, 255), min(clrG+clrW, 255), min(clrB+clrW, 255), dimmer*(clrR+clrG+clrB+clrW)*OPACITY_BEAMS/(4*255*255));

    if (!beamsOff  &&  parentFixRef.showBeams) {
      float tempZoom = ((chanZoom>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanZoom-1, 0, 511)]) : 0);
      if (zoom != tempZoom) {
        zoom = tempZoom;
        updateBeam();
      }
      modelBeam.setFill(beamClr);
    }
  }

  /**
  *  @brief Display illuminated surface + beam cone
  */
  void display() {
    hint(DISABLE_DEPTH_MASK);                                                   // Disable depth counter, NOT occlusion detection (=DISABLE_DEPTH_TEST)
    pushMatrix();
    translate(pos3d.x, pos3d.z, pos3d.y);
    if (!beamsOff  &&  parentFixRef.showBeams) {
      shape(modelBeam);
    }
    noStroke();
    fill(beamClr | 150<<24);    // Set alpha, ToDo: Causes Pixel face to be colored even though dimmer is off -_-
    rotateX(HALF_PI);
    if (faceType.equals("Ellipse")) {
      ellipse(0, 0, faceSize.x, faceSize.y);
    } else if (faceType.equals("Rectangle")) {
      rect(-faceSize.x/2, -faceSize.y/2, faceSize.x/2, faceSize.y/2);
    }
    popMatrix();
    hint(ENABLE_DEPTH_MASK);
  }

  /**
  *  @brief Load this Pixel's GUI Elements into menu sidebar
  */
  void loadGui() {
    Expandable pixelExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Pixel "+name, true, false, constantData.CLR_MENU_LV1);
    pixelExp.put(new NameBox(new PVector(0, 0), new PVector(120, 25), this, "name", "Name", name));
    pixelExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "Pixel Pos LR", "Pixel Pos LR", pos3d.x, 1.0));
    pixelExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "Pixel Pos UD", "Pixel Pos UD", pos3d.y, 1.0));
    pixelExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "Pixel Pos FB", "Pixel Pos FB", pos3d.z, 1.0));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Pixel Width", "Pixel Width", int(faceSize.x), 1, 1, 10000, -1));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Pixel Height", "Pixel Height", int(faceSize.y), 1, 1, 10000, -1));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Zoom Angle Min", "Zoom Angle Min", zoomAngleMin, 1, 0, 180, -1));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Zoom Angle Max", "Zoom Angle Max", zoomAngleMax, 1, 0, 180, -1));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Dimmer", "Rel. Channel Dimmer", chanDimmer, 1, 0, 512, 0));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Zoom", "Rel. Channel Zoom", chanZoom, 1, 0, 512, 0));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Red", "Rel. Channel Red", chanClrR, 1, 0, 512, 0));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Green", "Rel. Channel Green", chanClrG, 1, 0, 512, 0));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Blue", "Rel. Channel Blue", chanClrB, 1, 0, 512, 0));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel White", "Rel. Channel White", chanClrW, 1, 0, 512, 0));
    Expandable faceTypeExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Pixel Type", true, false, constantData.CLR_MENU_LV2);
    faceTypeExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Ellipse", "Ellipse", constantData.CLR_MENU_LV3));
    faceTypeExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Rectangle", "Rectangle", constantData.CLR_MENU_LV3));
    pixelExp.put(faceTypeExp);
    pixelExp.put(new Button(new PVector(0, 0), new PVector(60, 30), this, "Copy Pixel", "Copy", constantData.CLR_MENU_LV2));
    pixelExp.put(new Button(new PVector(60+SIZE_GUTTER, 0-30-SIZE_GUTTER), new PVector(60, 30), this, "Delete Pixel", "Delete", constantData.CLR_MENU_LV2));
    menuExpRight.put(pixelExp);
  }

  /**
  * @brief Pack relevant attributes into a JSON and return it
  * @return JSON data with this object's saved attributes
  */
  JSONObject save() {
    JSONObject oJson = new JSONObject();
    oJson.setString("name", name);
    oJson.setFloat("pos3d.x", pos3d.x);
    oJson.setFloat("pos3d.y", pos3d.y);
    oJson.setFloat("pos3d.z", pos3d.z);
    oJson.setInt("zoomAngleMin", zoomAngleMin);
    oJson.setInt("zoomAngleMax", zoomAngleMax);
    oJson.setString("faceType", faceType);
    oJson.setFloat("faceSize.x", faceSize.x);
    oJson.setFloat("faceSize.y", faceSize.y);
    oJson.setInt("chanDimmer", chanDimmer);
    oJson.setInt("chanZoom", chanZoom);
    oJson.setInt("chanClrR", chanClrR);
    oJson.setInt("chanClrG", chanClrG);
    oJson.setInt("chanClrB", chanClrB);
    oJson.setInt("chanClrW", chanClrW);
    return(oJson);
  }

  /**
  * @brief Load object attributes from provided JSON Data
  * @param iJson JSON Dataset including this object's attributes to load
  */
  void load(JSONObject iJson) {
    name = iJson.getString("name");
    pos3d.x = iJson.getFloat("pos3d.x");
    pos3d.y = iJson.getFloat("pos3d.y");
    pos3d.z = iJson.getFloat("pos3d.z");
    zoomAngleMin = iJson.getInt("zoomAngleMin");
    zoomAngleMax = iJson.getInt("zoomAngleMax");
    faceType = iJson.getString("faceType");
    faceSize.x = iJson.getFloat("faceSize.x");
    faceSize.y = iJson.getFloat("faceSize.y");
    chanDimmer = iJson.getInt("chanDimmer");
    chanZoom = iJson.getInt("chanZoom");
    chanClrR = iJson.getInt("chanClrR");
    chanClrG = iJson.getInt("chanClrG");
    chanClrB = iJson.getInt("chanClrB");
    chanClrW = iJson.getInt("chanClrW");
    print("Loading Pixel..");
  }
}

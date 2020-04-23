/// Fixture definition
class Fixture extends ScreenObject {
  boolean showBeams = true;

  int universe = 0;                                                             //< ArtNet Universe
  int address = 1;

  ArrayList<Pixel> pixelList = new ArrayList<Pixel>();

  Dynamics pan;
  Dynamics tilt;
  String baseType = "Plate";                                                    // Plate, None
  String panType = "Fork";                                                      // Fork,
  String tiltType = "Head";                                                     // Head, Cuboid
  PShape modelBase;
  PShape modelPan;
  PShape modelTilt;
  PVector sizeBase = new PVector(100, 100, 100);
  PVector sizePan = new PVector(100, 100, 100);
  PVector sizeTilt = new PVector(100, 100, 100);

  Fixture() {
    super(new PVector(int(random(-100, 100)), int(random(-250, -50)), int(random(-100, 100))), new PVector(0, 0, 0));
    modelBase = loadShape("Headbase.obj");
    modelPan = loadShape("Headfork.obj");
    modelTilt = loadShape("Headcorpus.obj");
    modelBase.disableStyle();  // Ignore the colors in the SVG
    modelPan.disableStyle();
    modelTilt.disableStyle();
    rescaleModels();
    pan = new Dynamics("Pan Dynamics");
    tilt = new Dynamics("Tilt Dynamics");
    pixelList.add(new Pixel("1", this));
  }

  void rescaleModels() {
    modelBase.resetMatrix();
    modelPan.resetMatrix();
    modelTilt.resetMatrix();
    modelBase.scale(sizeBase.x/100.0, sizeBase.y/100.0, sizeBase.z/100.0);
    modelPan.scale(sizePan.x/100.0, sizePan.y/100.0, sizePan.z/100.0);
    modelTilt.scale(sizeTilt.x/100.0, sizeTilt.y/100.0, sizeTilt.z/100.0);
  }

  void display() {
    checkMouseOver();
    fill(80);
    stroke(0);
    strokeWeight(1);

    pan.updateDest(address, dmxData[universe]);
    tilt.updateDest(address, dmxData[universe]);

    for (Pixel p : pixelList) {
      p.updateChannels(address, dmxData[universe]);
    }

    PVector dummy = new PVector(0, 500, 0);
    dummy = rotateVector(dummy, -tilt.pos, 0, 0);
    dummy = rotateVector(dummy, 0, -pan.pos, 0);
    dummy = rotateVector(dummy, 0, 0, -rot.z);  // Sequence of rotations makes a difference!
    dummy = rotateVector(dummy, 0, -rot.y, 0);
    dummy = rotateVector(dummy, -rot.x, 0, 0);
    dummy.add(new PVector(pos3d.x, pos3d.y, pos3d.z));

    /*
    stroke(dimmer);
     strokeWeight(5);
     line(pos3d.x, pos3d.y, pos3d.z, dummy.x, dummy.y, dummy.z);
     */

    pushMatrix();
    translate(pos3d.x, pos3d.y, pos3d.z);
    rotateX(radians(rot.x));
    rotateY(radians(rot.y));
    rotateZ(radians(rot.z));
    fill(clr);
    stroke(0);
    strokeWeight(2);
    if (baseType.equals("Plate")) {
      shape(modelBase);
    }
    rotateY(radians(pan.pos));
    if (panType.equals("Fork")) {
      shape(modelPan);
    }
    rotateX(radians(tilt.pos - float(tilt.angle)/2.0));                          // Offset tilt (center = pointing straight forwards)
    if (tiltType.equals("Head")) {
      shape(modelTilt);
    } else if (tiltType.equals("Cuboid")) {
      box(sizeTilt.x, sizeTilt.y, sizeTilt.z);      // ToDo: Implement scaling for obj models
    }
    for (Pixel p : pixelList) {
      p.display();
    }
    popMatrix();

    updatePos2d();
  }

  // ToDo move Dynamics GUI stuff to Dynamics class
  void loadGui() {
    Expandable tempFixExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Fixture", true, true, CLR_MENU_LV1);
    tempFixExp.put(new NameBox(new PVector(0, 0), new PVector(120, 25), this, "name", "Name", name));
    tempFixExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.x", "pos3d.x", pos3d.x, 1.0));
    tempFixExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.y", "pos3d.y", pos3d.y, 1.0));
    tempFixExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.z", "pos3d.z", pos3d.z, 1.0));
    tempFixExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.x", "rot.x", rot.x, 1.0));
    tempFixExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.y", "rot.y", rot.y, 1.0));
    tempFixExp.put(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.z", "rot.z", rot.z, 1.0));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Universe", "Universe", universe, 1, 0, QTY_UNIVERSES-1, -1));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Address", "Address", address, 1, 1, 512, -1));
    tempFixExp.put(pan.returnGui());
    tempFixExp.put(tilt.returnGui());
    Expandable selectBaseExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Base Model", true, false, CLR_MENU_LV2);
    selectBaseExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Plate Model", "Plate", CLR_MENU_LV3));
    selectBaseExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "No Model", "None", CLR_MENU_LV3));
    selectBaseExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Base Size LR", "Base Size LR", int(sizeBase.x), 1, 1, 10000, -1));
    selectBaseExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Base Size FB", "Base Size FB", int(sizeBase.y), 1, 1, 10000, -1));
    selectBaseExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Base Size UD", "Base Size UD", int(sizeBase.z), 1, 1, 10000, -1));
    tempFixExp.put(selectBaseExp);
    Expandable selectPanExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Pan Model", true, false, CLR_MENU_LV2);
    selectPanExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Fork Model", "Fork", CLR_MENU_LV3));
    selectPanExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Pan Size LR", "Pan Size LR", int(sizePan.x), 1, 1, 10000, -1));
    selectPanExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Pan Size UD", "Pan Size UD", int(sizePan.y), 1, 1, 10000, -1));
    selectPanExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Pan Size FB", "Pan Size FB", int(sizePan.z), 1, 1, 10000, -1));
    tempFixExp.put(selectPanExp);
    Expandable selectTiltExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Tilt Model", true, false, CLR_MENU_LV2);
    selectTiltExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Head Model", "Head", CLR_MENU_LV3));
    selectTiltExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Cuboid Model", "Cuboid", CLR_MENU_LV3));
    selectTiltExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Tilt Size LR", "Tilt Size LR", int(sizeTilt.x), 1, 1, 10000, -1));
    selectTiltExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Tilt Size FB", "Tilt Size FB", int(sizeTilt.y), 1, 1, 10000, -1));
    selectTiltExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Tilt Size UD", "Tilt Size UD", int(sizeTilt.z), 1, 1, 10000, -1));
    tempFixExp.put(selectTiltExp);
    tempFixExp.put(new Button(new PVector(0, 0), new PVector(120, 30), this, "Toggle Beams", "Toggle Beams", CLR_MENU_LV2));
    menuExpRight.put(tempFixExp);
    for (Pixel p : pixelList) {
      p.loadGui();
    }
    menuExpRight.put(new Button(new PVector(0, 0), new PVector(60, 30), this, "Copy Fixture", "Copy", CLR_MENU_LV1));
    menuExpRight.put(new Button(new PVector(60+SIZE_GUTTER, 0-30-SIZE_GUTTER), new PVector(60, 30), this, "Delete Fixture", "Delete", CLR_MENU_LV1));
    menuExpRight.put(new Button(new PVector(0, 0), new PVector(60, 30), this, "Save Fixture", "Save", CLR_MENU_LV1));
  }

  JSONObject save() {
    JSONObject oJson = super.save();
    oJson.setInt("showBeams", (showBeams ? 1 : 0));
    oJson.setInt("universe", universe);
    oJson.setInt("address", address);
    oJson.setJSONObject("pan", pan.save());
    oJson.setJSONObject("tilt", tilt.save());
    oJson.setString("baseType", baseType);
    oJson.setString("panType", panType);
    oJson.setString("tiltType", tiltType);
    oJson.setFloat("sizeBase.x", sizeBase.x);
    oJson.setFloat("sizeBase.y", sizeBase.y);
    oJson.setFloat("sizeBase.z", sizeBase.z);
    oJson.setFloat("sizePan.x", sizePan.x);
    oJson.setFloat("sizePan.y", sizePan.y);
    oJson.setFloat("sizePan.z", sizePan.z);
    oJson.setFloat("sizeTilt.x", sizeTilt.x);
    oJson.setFloat("sizeTilt.y", sizeTilt.y);
    oJson.setFloat("sizeTilt.z", sizeTilt.z);
    JSONArray tempJsonArray = new JSONArray();
    for (int i=0; i<pixelList.size(); i++) {
      tempJsonArray.setJSONObject(i, pixelList.get(i).save());
    }
    oJson.setJSONArray("pixels", tempJsonArray);
    return(oJson);
  }

  void load(JSONObject iJson) {
    super.load(iJson);
    showBeams = (!iJson.isNull("showBeams") ? boolean(iJson.getInt("showBeams")) : true);   // Ensure backwards compatibility
    universe = iJson.getInt("universe");
    address = iJson.getInt("address");
    pan.load(iJson.getJSONObject("pan"));
    tilt.load(iJson.getJSONObject("tilt"));
    baseType = iJson.getString("baseType");
    panType = iJson.getString("panType");
    tiltType = iJson.getString("tiltType");
    sizeBase.x = iJson.getFloat("sizeBase.x");
    sizeBase.y = iJson.getFloat("sizeBase.y");
    sizeBase.z = iJson.getFloat("sizeBase.z");
    sizePan.x = iJson.getFloat("sizePan.x");
    sizePan.y = iJson.getFloat("sizePan.y");
    sizePan.z = iJson.getFloat("sizePan.z");
    sizeTilt.x = iJson.getFloat("sizeTilt.x");
    sizeTilt.y = iJson.getFloat("sizeTilt.y");
    sizeTilt.z = iJson.getFloat("sizeTilt.z");
    pixelList.clear();
    JSONArray tempJsonArray = iJson.getJSONArray("pixels");
    for (int i=0; i<tempJsonArray.size(); i++) {
      Pixel tempPixel = new Pixel("irrelevant", this);
      tempPixel.load(tempJsonArray.getJSONObject(i));
      pixelList.add(tempPixel);
    }
    rescaleModels();
    println("Loaded Fixture " + name);
  }

  /*
    void calcPanTilt() {
   PVector tempVec = new PVector(0, 0, 0);
   tempVec = PVector.sub(headPointAt, pos);   // headPointAt = Point in 3D space to point the head at
   tempVec = rotateVector(tempVec, rotX, 0, 0);  // Sequence of rotations makes a difference!
   tempVec = rotateVector(tempVec, 0, rotY, 0);
   tempVec = rotateVector(tempVec, 0, 0, rotZ);
   
   pan = degrees(atan2(tempVec.x, tempVec.z));
   tilt = degrees(acos(tempVec.y/tempVec.mag()));
   
   // For Art-Net Output
   int actualPanRange  = 256*360/panRange;       // <8 bit> * <Pan Range of Sphere Coords> / <Fixture Pan Range>
   int actualTiltRange = 127*180/(tiltRange/2);  // <8 bit> * <Tilt Range of Sphere Coords> / <Fixture Tilt Range>
   byte  panByte = byte(constrain(map(pan, -180, 180, 127-(actualPanRange/2), 127+(actualPanRange/2)), 0, 255));    //ToDo: panRange/TiltRange berücksichtigen
   byte tiltByte = byte(constrain(map(tilt,   0, 180, 127, 127+actualTiltRange), 0, 255));
   setDMXchannel(109, (panInvert ? (255-panByte) : panByte));
   setDMXchannel(111, (tiltInvert ? (255-tiltByte) : tiltByte));
   myBus.sendControllerChange(15, 1, int( panByte*127/255));
   myBus.sendControllerChange(15, 2, int(tiltByte*127/255));
   //println(pan, tilt, panByte, tiltByte);
   }*/
}

/// Fixture definition
class Fixture extends ScreenObject {
  int universe = 0;                                                             //< ArtNet Universe
  int address = 1;

  ArrayList<Pixel> pixelList = new ArrayList<Pixel>();

  int panAngle = 630;                                                           // [deg]
  int tiltAngle = 270;
  int panOffset = 0;                                                            // [deg]
  int tiltOffset = 0;
  Dynamics pan;
  Dynamics tilt;
  String panType = "Fork";                                                      // Fork,
  String tiltType = "Head";                                                     // Head, Cuboid
  PShape modelBase;
  PShape modelPan;
  PShape modelTilt;
  PVector sizePan = new PVector(100, 100, 100);
  PVector sizeTilt = new PVector(100, 100, 100);

  int chanPanCoarse = 1;                                                              // [1-512]
  int chanPanFine = 2;
  int chanTiltCoarse = 3;
  int chanTiltFine = 4;


  Fixture() {
    super(new PVector(int(random(-100, 100)), int(random(-250, -50)), int(random(-100, 100))), new PVector(0, 0, 0));
    modelBase = loadShape("Headbase.obj");
    modelPan = loadShape("Headfork.obj");
    modelTilt = loadShape("Headcorpus.obj");
    modelBase.disableStyle();  // Ignore the colors in the SVG
    modelPan.disableStyle();
    modelTilt.disableStyle();
    rescaleModels();
    pan = new Dynamics();
    tilt = new Dynamics();
    pixelList.add(new Pixel("1", this));
  }



  void rescaleModels() {
    modelBase.resetMatrix();
    modelPan.resetMatrix();
    modelTilt.resetMatrix();
    modelBase.scale(sizePan.x/100.0, sizePan.y/100.0, sizePan.z/100.0);
    modelPan.scale(sizePan.x/100.0, sizePan.y/100.0, sizePan.z/100.0);
    modelTilt.scale(sizeTilt.x/100.0, sizeTilt.y/100.0, sizeTilt.z/100.0);
  }



  void display() {
    checkMouseOver();
    fill(80);
    stroke(0);
    strokeWeight(1);

    if (chanPanCoarse > 0  &&  chanPanFine > 0) {
      int panMSB = ((chanPanCoarse>0) ? int(dmxData[universe][constrain(address-1+chanPanCoarse-1, 0, 511)]) : 127);
      int panLSB = ((chanPanFine>0) ? int(dmxData[universe][constrain(address-1+chanPanFine-1, 0, 511)]) : 127);
      pan.updateDest(((panMSB<<8) | panLSB)*float(panAngle)/65536.0 + panOffset);
      pan.move();
    } else {
      pan.pos = float(panAngle)/2;
    }
    if (chanTiltCoarse > 0  &&  chanTiltFine > 0) {
      int tiltMSB = ((chanTiltCoarse>0) ? int(dmxData[universe][constrain(address-1+chanTiltCoarse-1, 0, 511)]) : 127);
      int tiltLSB = ((chanTiltFine>0) ? int(dmxData[universe][constrain(address-1+chanTiltFine-1, 0, 511)]) : 127);
      tilt.updateDest(((tiltMSB<<8) | tiltLSB)*float(tiltAngle)/65536.0 + tiltOffset);
      tilt.move();
    } else {
      tilt.pos = float(tiltAngle)/2;
    }

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
    shape(modelBase);
    rotateY(radians(pan.pos));
    if (panType.equals("Fork")) {
      shape(modelPan);
    }
    rotateX(radians(tilt.pos - float(tiltAngle)/2.0));                          // Offset tilt (center = pointing straight forwards)
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
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Chan Pan Coarse", "Chan Pan Coarse", chanPanCoarse, 1, 0, 512, 0));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Chan Pan Fine", "Chan Pan Fine", chanPanFine, 1, 0, 512, 0));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Chan Tilt Coarse", "Chan Tilt Coarse", chanTiltCoarse, 1, 0, 512, 0));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Chan Tilt Fine", "Chan Tilt Fine", chanTiltFine, 1, 0, 512, 0));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Pan Offset", "Pan Offset", panOffset, 1, -180, 180, -999));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Tilt Offset", "Tilt Offset", tiltOffset, 1, -180, 180, -999));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Pan Angle", "Pan Angle", panAngle, 1, 90, 720, -1));
    tempFixExp.put(new SpinBox(new PVector(10, 0), new PVector(70, 25), this, "Pan Accel", "Pan Accel", pan.maxAcc, 0.01));
    tempFixExp.put(new SpinBox(new PVector(10, 0), new PVector(70, 25), this, "Pan Speed", "Pan Speed", pan.maxSpd, 0.01));
    tempFixExp.put(new SpinBox(new PVector(10, 0), new PVector(70, 25), this, "Pan Tweak", "Pan Tweak", pan.maxSpdTweak, 0.01));
    tempFixExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Tilt Angle", "Tilt Angle", tiltAngle, 1, 90, 360, -1));
    tempFixExp.put(new SpinBox(new PVector(10, 0), new PVector(70, 25), this, "Tilt Accel", "Tilt Accel", tilt.maxAcc, 0.01));
    tempFixExp.put(new SpinBox(new PVector(10, 0), new PVector(70, 25), this, "Tilt Speed", "Tilt Speed", tilt.maxSpd, 0.01));
    tempFixExp.put(new SpinBox(new PVector(10, 0), new PVector(70, 25), this, "Tilt Tweak", "Tilt Tweak", tilt.maxSpdTweak, 0.01));
    Expandable selectPanExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Pan", true, false, CLR_MENU_LV2);
    selectPanExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Fork Model", "Fork Model", CLR_MENU_LV3));    // ToDo add representation in Button class
    selectPanExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Pan Size LR", "Pan Size LR", int(sizePan.x), 1, 1, 10000, -1));
    selectPanExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Pan Size UD", "Pan Size UD", int(sizePan.y), 1, 1, 10000, -1));
    selectPanExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Pan Size FB", "Pan Size FB", int(sizePan.z), 1, 1, 10000, -1));
    tempFixExp.put(selectPanExp);
    Expandable selectTiltExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Tilt", true, false, CLR_MENU_LV2);
    selectTiltExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Head Model", "Head Model", CLR_MENU_LV3));
    selectTiltExp.put(new Button(new PVector(10, 0), new PVector(120, 30), this, "Cuboid Model", "Cuboid Model", CLR_MENU_LV3));
    selectTiltExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Tilt Size LR", "Tilt Size LR", int(sizeTilt.x), 1, 1, 10000, -1));
    selectTiltExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Tilt Size FB", "Tilt Size FB", int(sizeTilt.y), 1, 1, 10000, -1));
    selectTiltExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Tilt Size UD", "Tilt Size UD", int(sizeTilt.z), 1, 1, 10000, -1));
    tempFixExp.put(selectTiltExp);
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
    oJson.setInt("universe", universe);
    oJson.setInt("address", address);
    oJson.setInt("chanPanCoarse", chanPanCoarse);
    oJson.setInt("chanPanFine", chanPanFine);
    oJson.setInt("chanTiltCoarse", chanTiltCoarse);
    oJson.setInt("chanTiltFine", chanTiltFine);
    oJson.setFloat("panOffset", panOffset);
    oJson.setFloat("tiltOffset", tiltOffset);
    oJson.setInt("panAngle", panAngle);
    oJson.setInt("tiltAngle", tiltAngle);
    oJson.setString("panType", panType);
    oJson.setString("tiltType", tiltType);
    oJson.setFloat("sizePan.x", sizePan.x);
    oJson.setFloat("sizePan.y", sizePan.y);
    oJson.setFloat("sizePan.z", sizePan.z);
    oJson.setFloat("sizeTilt.x", sizeTilt.x);
    oJson.setFloat("sizeTilt.y", sizeTilt.y);
    oJson.setFloat("sizeTilt.z", sizeTilt.z);
    oJson.setJSONObject("pan", pan.save());
    oJson.setJSONObject("tilt", tilt.save());
    JSONArray tempJsonArray = new JSONArray();
    for (int i=0; i<pixelList.size(); i++) {
      tempJsonArray.setJSONObject(i, pixelList.get(i).save());
    }
    oJson.setJSONArray("pixels", tempJsonArray);
    return(oJson);
  }

  void load(JSONObject iJson) {
    super.load(iJson);
    universe = iJson.getInt("universe");
    address = iJson.getInt("address");
    chanPanCoarse = iJson.getInt("chanPanCoarse");
    chanPanFine = iJson.getInt("chanPanFine");
    chanTiltCoarse = iJson.getInt("chanTiltCoarse");
    chanTiltFine = iJson.getInt("chanTiltFine");
    panOffset = iJson.getInt("panOffset");
    tiltOffset = iJson.getInt("tiltOffset");
    panAngle = iJson.getInt("panAngle");
    tiltAngle = iJson.getInt("tiltAngle");
    panType = iJson.getString("panType");
    tiltType = iJson.getString("tiltType");
    sizePan.x = iJson.getFloat("sizePan.x");
    sizePan.y = iJson.getFloat("sizePan.y");
    sizePan.z = iJson.getFloat("sizePan.z");
    sizeTilt.x = iJson.getFloat("sizeTilt.x");
    sizeTilt.y = iJson.getFloat("sizeTilt.y");
    sizeTilt.z = iJson.getFloat("sizeTilt.z");
    pan.load(iJson.getJSONObject("pan"));
    tilt.load(iJson.getJSONObject("tilt"));
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

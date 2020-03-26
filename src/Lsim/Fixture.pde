/// Fixture definition
class Fixture extends ScreenObject {
  int universe = 0;                                                             //< ArtNet Universe
  int address = 1;
  //byte numChannels = 1;
  int panAngle = 630;
  int tiltAngle = 270;
  //boolean hasPan = true;
  //boolean hasTilt = true;

  Dynamics pan;
  Dynamics tilt;

  ArrayList<Pixel> pixelList = new ArrayList<Pixel>();

  String panType = "Fork";                                                      // Fork,
  String tiltType = "Head";                                                     // Head, Cuboid
  PShape modelBase;
  PShape modelPan;
  PShape modelTilt;

  int chanPan = 1;                                                              // [1-512]
  int chanTilt = 2;


  Fixture() {
    super(new PVector(int(random(-100, 100)), int(random(-250, -50)), int(random(-100, 100))), new PVector(0, 0, 0));
    modelPan = loadShape("Headfork.obj");
    modelTilt = loadShape("Headcorpus.obj");
    modelPan.disableStyle();  // Ignore the colors in the SVG
    modelTilt.disableStyle();
    pan = new Dynamics();
    tilt = new Dynamics();
    pixelList.add(new Pixel(address));
  }

  void display() {
    checkMouseOver();
    fill(80);
    stroke(0);
    strokeWeight(1);

    pan.updateDest(int(dmxData[universe][constrain(address-1+chanPan-1, 0, 511)])*float(panAngle)/255.0);
    pan.move();
    tilt.updateDest(int(dmxData[universe][constrain(address-1+chanTilt-1, 0, 511)])*float(tiltAngle)/255.0 - float(tiltAngle)/2.0);
    tilt.move();

    for (Pixel p : pixelList) {
      p.updateChannels(dmxData[universe]);
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
    rotateY(radians(pan.pos));
    fill(clr);
    stroke(0);
    strokeWeight(2);
    if (panType.equals("Fork")) {
      shape(modelPan);
    }
    rotateX(radians(tilt.pos));
    if (tiltType.equals("Head")) {
      shape(modelTilt);
    } else if (tiltType.equals("Cuboid")) {
      box(25, 40, 25);
    }
    for (Pixel p : pixelList) {
      p.display();
    }
    popMatrix();

    updatePos2d();
  }

  void loadGui() {
    Expandable headExp = new Expandable(new PVector(0, 0), new PVector(0, 0), true, true);
    headExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "pos3d.x", pos3d.x, 1.0));
    headExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "pos3d.y", pos3d.y, 1.0));
    headExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "pos3d.z", pos3d.z, 1.0));
    headExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "rot.x", rot.x, 1.0));
    headExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "rot.y", rot.y, 1.0));
    headExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "rot.z", rot.z, 1.0));
    headExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Universe", universe, 1, 0, QTY_UNIVERSES-1));
    headExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Address", address, 1, 1, 512));
    headExp.put(new IntBox(new PVector(10, 0), new PVector(100, 25), this, "Pan Angle", panAngle, 1, 90, 720));
    headExp.put(new SpinBox(new PVector(20, 0), new PVector(80, 25), this, "Pan Accel", pan.maxAcc, 0.01));
    headExp.put(new SpinBox(new PVector(20, 0), new PVector(80, 25), this, "Pan Speed", pan.maxSpd, 0.01));
    headExp.put(new SpinBox(new PVector(20, 0), new PVector(80, 25), this, "Pan Tweak", pan.maxSpdTweak, 0.01));
    headExp.put(new IntBox(new PVector(10, 0), new PVector(100, 25), this, "Tilt Angle", tiltAngle, 1, 90, 360));
    headExp.put(new SpinBox(new PVector(20, 0), new PVector(80, 25), this, "Tilt Accel", tilt.maxAcc, 0.01));
    headExp.put(new SpinBox(new PVector(20, 0), new PVector(80, 25), this, "Tilt Speed", tilt.maxSpd, 0.01));
    headExp.put(new SpinBox(new PVector(20, 0), new PVector(80, 25), this, "Tilt Tweak", tilt.maxSpdTweak, 0.01));
    headExp.put(new IntBox(new PVector(10, 0), new PVector(60, 25), this, "Channel Pan", chanPan, 1, 1, 512));
    headExp.put(new IntBox(new PVector(10, 0), new PVector(60, 25), this, "Channel Tilt", chanTilt, 1, 1, 512));
    Expandable selectPanExp = new Expandable(new PVector(10, 0), new PVector(0, 0), true, false);
    selectPanExp.put(new Button(new PVector(0, 0), new PVector(120, 30), this, "Fork Model"));    // ToDo add representation in Button class
    headExp.put(selectPanExp);
    Expandable selectTiltExp = new Expandable(new PVector(10, 0), new PVector(0, 0), true, false);
    selectTiltExp.put(new Button(new PVector(0, 0), new PVector(120, 30), this, "Head Model"));
    selectTiltExp.put(new Button(new PVector(0, 0), new PVector(120, 30), this, "Cuboid Model"));
    headExp.put(selectTiltExp);
    menuExpRight.put(headExp);
    for (Pixel p : pixelList) {
      p.loadGui();
    }
  }

  String getSaveString() {
    /*
    XML tempXml = parseXML("<Fixture><Mechanical></Mechanical></Fixture>");
     XML nodeFixture = tempXml.getChild("Mechanical");
     XML x = nodeFixture.addChild("Property");
     x.setString("name", "panAngle");
     x.setString("value", str(panAngle));
     saveXML(tempXml, "xml/" + name + ".xml");
     */
    return(
      name + ";" +
      str(pos3d.x) + ";" +
      str(pos3d.y) + ";" +
      str(pos3d.z) + ";" +
      str(rot.x) + ";" +
      str(rot.y) + ";" +
      str(rot.z) + ";" +
      str(universe) + ";" +
      str(address) + ";" +
      str(panAngle) + ";" +
      str(pan.maxAcc) + ";" +
      str(pan.maxSpd) + ";" +
      str(pan.maxSpdTweak) + ";" +
      str(tiltAngle) + ";" +
      str(tilt.maxAcc) + ";" +
      str(tilt.maxSpd) + ";" +
      str(tilt.maxSpdTweak)/* + ";" +
     str(zoomAngleMin) + ";" +
     str(zoomAngleMax) + ";" +
     str(lensSize) + ";" +
     str(chanPan) + ";" +
     str(chanTilt) + ";" +
     str(chanDimmer) + ";" +
     str(chanZoom) + ";" +
     str(chanClrR) + ";" +
     str(chanClrG) + ";" +
     str(chanClrB) + ";" +
     str(chanClrW)*/
      );
  }

  void setLoadString(String iLine) {
    String[] props = split(iLine, ';');
    if (props.length == 28) {
      name = props[0];
      pos3d = new PVector(float(props[1]), float(props[2]), float(props[3]));
      rot = new PVector(float(props[4]), float(props[5]), float(props[6]));
      universe = int(props[7]);
      address = int(props[8]);
      panAngle = int(props[9]);
      pan.maxAcc = float(props[10]);
      pan.maxSpd = float(props[11]);
      pan.maxSpdTweak = float(props[12]);
      tiltAngle = int(props[13]);
      tilt.maxAcc = float(props[14]);
      tilt.maxSpd = float(props[15]);
      tilt.maxSpdTweak = float(props[16]);
      /*zoomAngleMin = int(props[17]);
       zoomAngleMax = int(props[18]);
       lensSize = int(props[19]);
       chanPan = int(props[20]);
       chanTilt = int(props[21]);
       chanDimmer = int(props[22]);
       chanZoom = int(props[23]);
       chanClrR = int(props[24]);
       chanClrG = int(props[25]);
       chanClrB = int(props[26]);
       chanClrW = int(props[27]);*/
      println("Loaded Fixture " + name);
    } else {
      println("!Error while loading a Fixture: Number of properties in line not as expected!");
      return;
    }
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

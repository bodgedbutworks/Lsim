/// Fixture definition
class Fixture extends ScreenObject {
  int lensSize = 5;                                                             // Size of upper part of beam cone
  int zoomAngleMin = 10;                                                        // [deg]
  int zoomAngleMax = 35;
  int universe = 0;                                                             //< ArtNet Universe
  int address = 1;
  //byte numChannels = 1;
  int panAngle = 630;
  int tiltAngle = 270;
  //boolean hasPan = true;
  //boolean hasTilt = true;

  Dynamics pan;
  Dynamics tilt;

  PShape modelBase;
  PShape modelPan;
  PShape modelTilt;
  PShape modelBeam;

  int chanPan = 1;                                                              // [1-512]
  int chanTilt = 2;
  int chanDimmer = 3;
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

  Fixture() {
    super(new PVector(int(random(-100, 100)), int(random(-250, -50)), int(random(-100, 100))), new PVector(0, 0, 0));
    modelPan = loadShape("Headfork.obj");
    modelTilt = loadShape("Headcorpus.obj");
    modelPan.disableStyle();  // Ignore the colors in the SVG
    modelTilt.disableStyle();
    updateBeam();
    pan = new Dynamics();
    tilt = new Dynamics();
  }

  void updateBeam() {
    int zoomRadius = lensSize + int(tan(radians(map(zoom, 0, 255, zoomAngleMin, zoomAngleMax)/2))*LENGTH_BEAMS);    // radius = tan(half beam angle) * beam length
    modelBeam = createShape();
    modelBeam.beginShape(TRIANGLE_STRIP);
    modelBeam.noStroke();
    // ToDo: Color model is incorrect, vary dark color settings result in 'black' light output
    modelBeam.fill(min(clrR+clrW, 255), min(clrG+clrW, 255), min(clrB+clrW, 255), dimmer*(clrR+clrG+clrB+clrW)*OPACITY_BEAMS/(4*255*255));
    for (int i=0; i<=RESOLUTION_BEAMS; i++) {
      modelBeam.vertex(lensSize*sin(i*TWO_PI/RESOLUTION_BEAMS), 20, lensSize*cos(i*TWO_PI/RESOLUTION_BEAMS));
      modelBeam.vertex(zoomRadius*sin(i*TWO_PI/RESOLUTION_BEAMS), LENGTH_BEAMS, zoomRadius*cos(i*TWO_PI/RESOLUTION_BEAMS));
    }
    modelBeam.endShape(CLOSE);
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
    dimmer = int(dmxData[universe][constrain(address-1+chanDimmer-1, 0, 511)]);
    zoom = int(dmxData[universe][constrain(address-1+chanZoom-1, 0, 511)]);
    clrR = int(dmxData[universe][constrain(address-1+chanClrR-1, 0, 511)]);
    clrG = int(dmxData[universe][constrain(address-1+chanClrG-1, 0, 511)]);
    clrB = int(dmxData[universe][constrain(address-1+chanClrB-1, 0, 511)]);
    clrW = int(dmxData[universe][constrain(address-1+chanClrW-1, 0, 511)]);

    updateBeam();

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
    shape(modelPan);
    rotateX(radians(tilt.pos));
    shape(modelTilt);
    hint(DISABLE_DEPTH_MASK);                                                   // Disable depth counter, NOT occlusion detection (=DISABLE_DEPTH_TEST)
    shape(modelBeam);
    hint(ENABLE_DEPTH_MASK);
    popMatrix();

    updatePos2d();
  }

  void loadGui() {
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.x", pos3d.x, 1.0));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.y", pos3d.y, 1.0));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "pos3d.z", pos3d.z, 1.0));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.x", rot.x, 1.0));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.y", rot.y, 1.0));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(80, 25), this, "rot.z", rot.z, 1.0));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Universe", universe, 1, 0, QTY_UNIVERSES-1));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Address", address, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(100, 25), this, "Pan Angle", panAngle, 1, 90, 720));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(100, 25), this, "Pan Accel", pan.maxAcc, 0.01));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(100, 25), this, "Pan Speed", pan.maxSpd, 0.01));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(100, 25), this, "Pan Tweak", pan.maxSpdTweak, 0.01));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Tilt Angle", tiltAngle, 1, 90, 360));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(100, 25), this, "Tilt Accel", tilt.maxAcc, 0.01));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(100, 25), this, "Tilt Speed", tilt.maxSpd, 0.01));
    guiList.add(new SpinBox(new PVector(0, 0), new PVector(100, 25), this, "Tilt Tweak", tilt.maxSpdTweak, 0.01));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Zoom Angle Min", zoomAngleMin, 1, 0, 180));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Zoom Angle Max", zoomAngleMax, 1, 0, 180));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Lens Size", lensSize, 1, 0, 30));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Pan", chanPan, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Tilt", chanTilt, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Dimmer", chanDimmer, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Zoom", chanZoom, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Red", chanClrR, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Green", chanClrG, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel Blue", chanClrB, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(50, 25), this, "Channel White", chanClrW, 1, 1, 512));
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
      str(tilt.maxSpdTweak) + ";" +
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
      str(chanClrW)
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
      pan.maxAcc = int(props[10]);
      pan.maxSpd = int(props[11]);
      pan.maxSpdTweak = int(props[12]);
      tiltAngle = int(props[13]);
      tilt.maxAcc = int(props[14]);
      tilt.maxSpd = int(props[15]);
      tilt.maxSpdTweak = int(props[16]);
      zoomAngleMin = int(props[17]);
      zoomAngleMax = int(props[18]);
      lensSize = int(props[19]);
      chanPan = int(props[20]);
      chanTilt = int(props[21]);
      chanDimmer = int(props[22]);
      chanZoom = int(props[23]);
      chanClrR = int(props[24]);
      chanClrG = int(props[25]);
      chanClrB = int(props[26]);
      chanClrW = int(props[27]);
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

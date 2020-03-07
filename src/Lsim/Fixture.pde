/// Fixture definition
class Fixture extends ScreenObject {
  int universe = 0;                                                           //< ArtNet Universe
  int address = 1;
  byte numChannels = 1;
  int panAngle = 630;
  int tiltAngle = 270;
  boolean hasPan = true;
  boolean hasTilt = true;
  PShape modelBase;
  PShape modelPan;
  PShape modelTilt;

  int chanPan = 1;                                                              // [1-512]
  int chanTilt = 2;
  int chanDimmer = 3;

  float pan = 0;
  float tilt = 0;
  float dimmer = 255;

  Fixture() {
    super(new PVector(0, 0, 0), new PVector(0, 0, 0));  // ToDo
    modelPan = loadShape("Headfork.obj");
    modelTilt = loadShape("Headcorpus.obj");
    modelPan.disableStyle();  // Ignore the colors in the SVG
    modelTilt.disableStyle();
  }

  void display() {
    checkMouseOver();
    fill(80);
    stroke(0);
    strokeWeight(1);

    pan = int(dmxData[universe][constrain(address-1+chanPan-1, 0, 511)])*float(panAngle)/255.0;
    tilt = int(dmxData[universe][constrain(address-1+chanTilt-1, 0, 511)])*float(tiltAngle)/255.0 - float(tiltAngle)/2.0;
    dimmer = int(dmxData[universe][constrain(address-1+chanDimmer-1, 0, 511)]);

    PVector dummy = new PVector(0, 500, 0);
    dummy = rotateVector(dummy, -tilt, 0, 0);
    dummy = rotateVector(dummy, 0, -pan, 0);
    dummy = rotateVector(dummy, 0, 0, -rot.z);  // Sequence of rotations makes a difference!
    dummy = rotateVector(dummy, 0, -rot.y, 0);
    dummy = rotateVector(dummy, -rot.x, 0, 0);
    dummy.add(new PVector(pos3d.x, pos3d.y, pos3d.z));

    stroke(dimmer);
    strokeWeight(5);
    line(pos3d.x, pos3d.y, pos3d.z, dummy.x, dummy.y, dummy.z);

    pushMatrix();
    translate(pos3d.x, pos3d.y, pos3d.z);
    rotateX(radians(rot.x));
    rotateY(radians(rot.y));
    rotateZ(radians(rot.z));
    rotateY(radians(pan));
    fill(clr);
    stroke(0);
    strokeWeight(2);
    shape(modelPan);
    rotateX(radians(tilt));
    shape(modelTilt);
    popMatrix();

    pos2d.x = screenX(pos3d.x, pos3d.y, pos3d.z);
    pos2d.y = screenY(pos3d.x, pos3d.y, pos3d.z);
  }

  void loadGui() {
    guiList.add(new SpinBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "pos3d.x", pos3d.x));
    guiList.add(new SpinBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "pos3d.y", pos3d.y));
    guiList.add(new SpinBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "pos3d.z", pos3d.z));
    guiList.add(new SpinBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "rot.x", rot.x));
    guiList.add(new SpinBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "rot.y", rot.y));
    guiList.add(new SpinBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "rot.z", rot.z));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Universe", universe, 0, QTY_UNIVERSES-1));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Address", address, 1, 512));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Pan Angle", panAngle, 90, 720));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Tilt Angle", tiltAngle, 90, 360));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Channel Pan", chanPan, 1, 512));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Channel Tilt", chanTilt, 1, 512));
    guiList.add(new IntBox<Fixture>(new PVector(0, 0), new PVector(80, 25), this, "Channel Dimmer", chanDimmer, 1, 512));
  }

     x.setString("value", str(panAngle));
     saveXML(tempXml, "xml/" + name + ".xml");
     */
    return(

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

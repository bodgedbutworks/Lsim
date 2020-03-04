/// Fixture definition
class Fixture extends ScreenObject {
  int universe = 0;                                                           //< ArtNet Universe
  int address = 0;
  byte numChannels = 1;
  float panAngle = 630;
  float tiltAngle = 270;
  boolean hasPan = true;
  boolean hasTilt = true;
  PShape modelBase;
  PShape modelPan;
  PShape modelTilt;

  float pan = 0;
  float tilt = 0;

  Fixture() {
    super(new PVector(0, 0, 0), new PVector(0, 0, 0));  // ToDo
    modelPan = loadShape("Headfork.obj"); //<>// //<>//
    modelTilt = loadShape("Headcorpus.obj");
    modelPan.disableStyle();  // Ignore the colors in the SVG
    modelTilt.disableStyle();
  }
/*
  void display(){
     fill(80);  stroke(0); strokeWeight(1);
     checkMouseOver();

     // pan = ArtNet receive, tilt = ...

     PVector dummy = new PVector(0, 500, 0);
     dummy = rotateVector(dummy, -tilt, 0, 0);
     dummy = rotateVector(dummy, 0, -pan, 0);
     dummy = rotateVector(dummy, 0, 0, -rotZ);  // Sequence of rotations makes a difference!
     dummy = rotateVector(dummy, 0, -rotY, 0);
     dummy = rotateVector(dummy, -rotX, 0, 0);
     dummy.add(new PVector(pos.x, pos.y, pos.z));

     stroke(255); strokeWeight(5);
     line(pos.x, pos.y, pos.z, dummy.x, dummy.y, dummy.z);
    pan = int(dmxData[0][0])*panAngle/255;
    tilt = int(dmxData[0][1])*tiltAngle/255;

     fill(255); stroke(0);
     text("O", dummy.x, dummy.y, dummy.z);

     pushMatrix();
     translate(pos.x, pos.y, pos.z);
     rotateX(radians(rotX));
     rotateY(radians(rotY));
     rotateZ(radians(rotZ));
     rotateY(radians(pan));
     fill(mouseOverClr);
     stroke(0);
     strokeWeight(2);
     shape(Headfork);
     rotateX(radians(tilt));
     shape(Headcorpus);
     popMatrix();

     posScreen.x = screenX(pos.x, pos.y, pos.z);
     posScreen.y = screenY(pos.x, pos.y, pos.z);
   }



   void calcPanTilt() {
     PVector tempVec = new PVector(0, 0, 0);
     tempVec = PVector.sub(headPointAt, pos);   //headPointAt = Point in 3D space to point the head at
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

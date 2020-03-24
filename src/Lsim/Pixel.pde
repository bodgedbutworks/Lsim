class Pixel{
  PShape modelBeam;

  int lensSize = 5;                                                             // Size of upper part of beam cone
  int zoomAngleMin = 10;                                                        // [deg]
  int zoomAngleMax = 35;

  int fixtureAddress = 1;
  int chanDimmer = 1;                                                           // offsets towards fixture address
  int chanZoom = 1;
  int chanClrR = 1;
  int chanClrG = 1;
  int chanClrB = 1;
  int chanClrW = 1;

  float dimmer = 255;
  float zoom = 255;
  float clrR = 0;
  float clrG = 255;
  float clrB = 0;
  float clrW = 0;
  
  String faceType = "Circle";

  Pixel(int iFixtureAddress){
    fixtureAddress = iFixtureAddress;
    chanDimmer = fixtureAddress+2;      // ToDo
    chanZoom = fixtureAddress+3;
    chanClrR = fixtureAddress+9;
    chanClrG = fixtureAddress+10;
    chanClrB = fixtureAddress+11;
    chanClrW = fixtureAddress+12;
    updateBeam();
  }

  void updateBeam() {
    int zoomRadius = lensSize + int(tan(radians(map(zoom, 0, 255, zoomAngleMin, zoomAngleMax)/2))*LENGTH_BEAMS);    // radius = tan(half beam angle) * beam length
    modelBeam = createShape();
    modelBeam.beginShape(TRIANGLE_STRIP);
    modelBeam.noStroke();
    for (int i=0; i<=RESOLUTION_BEAMS; i++) {
      modelBeam.vertex(lensSize*sin(i*TWO_PI/RESOLUTION_BEAMS), 20, lensSize*cos(i*TWO_PI/RESOLUTION_BEAMS));
      modelBeam.vertex(zoomRadius*sin(i*TWO_PI/RESOLUTION_BEAMS), LENGTH_BEAMS, zoomRadius*cos(i*TWO_PI/RESOLUTION_BEAMS));
    }
    modelBeam.endShape(CLOSE);
  }

  void updateChannels(byte[] iDmxUniverse){
    dimmer = int(iDmxUniverse[constrain(fixtureAddress-1+chanDimmer-1, 0, 511)]);
    float tempZoom = int(iDmxUniverse[constrain(fixtureAddress-1+chanZoom-1, 0, 511)]);
    if (zoom != tempZoom) {
      zoom = tempZoom;
      updateBeam();
    }
    clrR = int(iDmxUniverse[constrain(fixtureAddress-1+chanClrR-1, 0, 511)]);
    clrG = int(iDmxUniverse[constrain(fixtureAddress-1+chanClrG-1, 0, 511)]);
    clrB = int(iDmxUniverse[constrain(fixtureAddress-1+chanClrB-1, 0, 511)]);
    clrW = int(iDmxUniverse[constrain(fixtureAddress-1+chanClrW-1, 0, 511)]);

    // ToDo: Color model is incorrect, vary dark color settings result in 'black' light output
    modelBeam.setFill(color(min(clrR+clrW, 255), min(clrG+clrW, 255), min(clrB+clrW, 255), dimmer*(clrR+clrG+clrB+clrW)*OPACITY_BEAMS/(4*255*255)));
  }

  void display(){
    hint(DISABLE_DEPTH_MASK);                                                   // Disable depth counter, NOT occlusion detection (=DISABLE_DEPTH_TEST)
    shape(modelBeam);
    hint(ENABLE_DEPTH_MASK);
  }

  void loadGui() {
    guiList.add(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Zoom Angle Min", zoomAngleMin, 1, 0, 180));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Zoom Angle Max", zoomAngleMax, 1, 0, 180));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Lens Size", lensSize, 1, 0, 30));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Channel Dimmer", chanDimmer, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Channel Zoom", chanZoom, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Channel Red", chanClrR, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Channel Green", chanClrG, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Channel Blue", chanClrB, 1, 1, 512));
    guiList.add(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Channel White", chanClrW, 1, 1, 512));
  }
}

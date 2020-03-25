class Pixel {
  PShape modelBeam;

  int lensSize = 5;                                                             // Size of upper part of beam cone
  int zoomAngleMin = 10;                                                        // [deg]
  int zoomAngleMax = 35;

  int fixtureAddress = 1;
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

  color beamClr;
  String faceType = "Rectangle";                                                   // Circle, Rectangle

  Pixel(int iFixtureAddress) {
    fixtureAddress = iFixtureAddress;
    /*chanDimmer = fixtureAddress+6;      // ToDo
     chanZoom = fixtureAddress+4;
     chanClrR = fixtureAddress+9;
     chanClrG = fixtureAddress+10;
     chanClrB = fixtureAddress+11;
     chanClrW = fixtureAddress+12;*/
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

  void updateChannels(byte[] iDmxUniverse) {
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
    beamClr = color(min(clrR+clrW, 255), min(clrG+clrW, 255), min(clrB+clrW, 255), dimmer*(clrR+clrG+clrB+clrW)*OPACITY_BEAMS/(4*255*255));
    modelBeam.setFill(beamClr);
  }

  void display() {
    hint(DISABLE_DEPTH_MASK);                                                   // Disable depth counter, NOT occlusion detection (=DISABLE_DEPTH_TEST)
    shape(modelBeam);
    noStroke();
    fill(beamClr | 150<<24);    // Set alpha
    pushMatrix();
    rotateX(HALF_PI);
    translate(0, 0, -50);    // ToDo implement position & size
    if (faceType.equals("Circle")) {
      ellipse(0, 0, 100, 100);
    } else if (faceType.equals("Rectangle")) {
      rect(-30, -15, 30, 15);
    }
    popMatrix();
    hint(ENABLE_DEPTH_MASK);
  }

  void loadGui() {
    Expandable pixelExp = new Expandable(new PVector(0, 0), new PVector(0, 0), true, false);
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Zoom Angle Min", zoomAngleMin, 1, 0, 180));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Zoom Angle Max", zoomAngleMax, 1, 0, 180));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(80, 25), this, "Lens Size", lensSize, 1, 0, 30));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Dimmer", chanDimmer, 1, 1, 512));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Zoom", chanZoom, 1, 1, 512));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Red", chanClrR, 1, 1, 512));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Green", chanClrG, 1, 1, 512));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel Blue", chanClrB, 1, 1, 512));
    pixelExp.put(new IntBox(new PVector(0, 0), new PVector(60, 25), this, "Rel. Channel White", chanClrW, 1, 1, 512));
    menuExpRight.put(pixelExp);
  }
}

import hypermedia.net.*;    // For UDP
UDP udp;

final int SIZE_GUTTER = 5;
int SIZE_X_SUBMENU;
int SIZE_X_MAINMENU;

ArrayList<Fixture> fixtureList = new ArrayList<Fixture>();
ArrayList<GuiObject> guiList = new ArrayList<GuiObject>();
ArrayList<Button> btnList = new ArrayList<Button>();

PVector camPos = new PVector(0, 0, 500);
PImage comImg;

byte[] artnetHeader = {'A', 'r', 't', '-', 'N', 'e', 't', '\0'};
byte[][] dmxData = new byte[4][512];                                            // [universe][address]

int selectedFixture = -1;
int selectedGuiObject = -1;
long lastFrameTime = 0;
long calcFrameRate = 1000;

boolean flag = false;
byte menuState = 0; // 0=closed, 1=expanding, 2=expanded, 3=closing
float menuPos = 0;  // Closed -> 0, Expanded -> positive

Button expandBtn;



void setup() {
  size(1200, 900, P3D);
  //fullScreen(P3D, 1);
  surface.setResizable(true);
  frameRate(60);

  SIZE_X_SUBMENU = width/5;
  SIZE_X_MAINMENU = width/10;

  udp = new UDP(this, 6454);
  //udp.log(true);
  udp.listen(true);

  rectMode(CORNERS);
  textFont(createFont("Crown SA", 100));

  comImg = loadImage("comImg2.png");

  btnList.add(new Button(new PVector(20, 20), new PVector(width/20, width/20), "+"));
  expandBtn = new Button(new PVector(0, 0), new PVector(width/20, width/20), ">");
}



void draw() {
  /********************* 3D Elements ********************/
  background(0);

  camera(camPos.x, camPos.y, camPos.z, 0, 0, 0, 0, 1, 0);
  fill(255);
  stroke(255);
  strokeWeight(1);
  line(0, 0, 0, 100, 0, 0);
  line(0, 0, 0, 0, 100, 0);
  line(0, 0, 0, 0, 0, 100);
  textSize(9);
  text("+X", 110, 0, 0);
  text("+Y", 0, 110, 0);
  text("+Z", 0, 0, 110);
  stroke(0);

  pushMatrix();
  translate(0, 3, 0);
  fill(#555555);
  box(200, 6, 200);
  popMatrix();

  /*
  if (keyPressed  &&  key == CODED) {
   if (mousePressed) {
   if (keyCode == SHIFT) {
   } else if (keyCode == CONTROL) {
   }
   }
   }
   */

  if (mousePressed) {
    if (mouseButton == RIGHT) {
      addSphereCoords(camPos, 0, (pmouseY-mouseY)/100.0, (pmouseX-mouseX)/100.0);
    }
  }

  for (int f=0; f<fixtureList.size(); f++) {
    fixtureList.get(f).display();
  }

  /********************* 2D Elements ********************/
  camera();
  hint(DISABLE_DEPTH_TEST);
  fill(255);
  textSize(height/50);
  textAlign(RIGHT, TOP);
  if (frameCount % 15 == 0) {
    calcFrameRate = 1000/(millis()-lastFrameTime+1);
  }
  lastFrameTime = millis();
  text(int(calcFrameRate), width-10, 7);                           // Print framerate

  for (int n=0; n<fixtureList.size(); n++) {
    Fixture theFixture = fixtureList.get(n);
    image(comImg, theFixture.pos2d.x-10, theFixture.pos2d.y-10, 20, 20);
    textAlign(LEFT, CENTER);
    text("Position [cm]: X " + int(theFixture.pos3d.x) + " Y " + int(theFixture.pos3d.y) + "  Z " + int(theFixture.pos3d.z), theFixture.pos2d.x, theFixture.pos2d.y-200);
    text("Rotation [deg]: X " + int(theFixture.rot.x) + " Y " + int(theFixture.rot.y) + " Z " + int(theFixture.rot.z), theFixture.pos2d.x, theFixture.pos2d.y-180);
  }

  PVector tempPos = new PVector(20, 120);                                          // Anchor point of following GUI elements
  for (int g=0; g<guiList.size(); g++) { //<>// //<>//
  // Menu sidebar
  switch(menuState) {
  case 0:
    break;
  case 1:
    if (abs(menuPos-(SIZE_X_SUBMENU+SIZE_X_MAINMENU)) > 0.2) {
      menuPos += 0.2*((SIZE_X_SUBMENU+SIZE_X_MAINMENU)-menuPos);
    } else {
      menuPos = SIZE_X_SUBMENU+SIZE_X_MAINMENU;
      menuState = 2;
    }
    break;
  case 2:
    break;
  case 3:
    if (menuPos > 0.2) {
      menuPos -= 0.2*menuPos;
    } else {
      menuPos = 0;
      menuState = 0;
    }
    break;
  default:
    break;
  }
  stroke(0);
  strokeWeight(2);
  fill(60);
  rect(menuPos-(SIZE_X_SUBMENU+SIZE_X_MAINMENU), 0, menuPos, height);
  stroke(0);
  strokeWeight(1);
  line(menuPos-SIZE_X_SUBMENU, 0, menuPos-SIZE_X_SUBMENU, height);
  PVector tempPos = new PVector(menuPos-(SIZE_X_SUBMENU)+20, 20);                                          // Anchor point of following GUI elements
  for (int g=0; g<guiList.size(); g++) {
    guiList.get(g).pos = tempPos.get();                                         // get() -> clone tempPos instead of creating a reference
    tempPos.add(new PVector(0, guiList.get(g).size.y));                        // Only vertical size
    tempPos.add(new PVector(0, SIZE_GUTTER));
    guiList.get(g).display();
  }
  hint(ENABLE_DEPTH_TEST);
}





// Transform _vector to sphere coordinates, modify them, then tranform back to cartesian & save to vector
// r = radius, omega = [0°-180°], phi = [0°-360°]
// Note: {+x, +y, +z} in sphere coordinates correspond to {+z, +x, -y}
void addSphereCoords(PVector _vector, float add_r, float add_omega, float add_phi) {
  PVector sphereCoords = new PVector(0, 0, 0);

  // Transform cartesian Processing coordinates to cartesian coordinates as defined for sphere
  sphereCoords.x = _vector.z;
  sphereCoords.y = _vector.x;
  sphereCoords.z = -(_vector.y);

  float old_r = sqrt(sq(sphereCoords.x) + sq(sphereCoords.y) + sq(sphereCoords.z));
  float old_omega = acos(sphereCoords.z/old_r);
  float old_phi = atan2(sphereCoords.y, sphereCoords.x);

  float new_r = old_r + add_r;
  float new_omega = old_omega;
  if ((old_omega+add_omega) < PI  &&  (old_omega+add_omega) > 0) {  // Exact values 0 and PI lead to display errors
    new_omega = old_omega + add_omega;
  for (int b=0; b<btnList.size(); b++) {
    btnList.get(b).pos.x = menuPos-SIZE_X_MAINMENU-SIZE_X_SUBMENU+20;
    btnList.get(b).display();
  }
  float new_phi = old_phi + add_phi;

  sphereCoords.x = new_r*sin(new_omega)*cos(new_phi);
  sphereCoords.y = new_r*sin(new_omega)*sin(new_phi);
  sphereCoords.z = new_r*cos(new_omega);

  // Transform cartesian coordinates as defined for sphere to cartesian Processing coordinates and save to vector
  _vector.x = sphereCoords.y;
  _vector.y = -(sphereCoords.z);
  _vector.z = sphereCoords.x;
}

PVector Kreuzprodukt(PVector vA, PVector vB) {
  return new PVector(vA.y*vB.z-vA.z*vB.y, vA.z*vB.x-vA.x*vB.z, vA.x*vB.y-vA.y*vB.x);
  expandBtn.pos.x = menuPos;
  expandBtn.display();
  hint(ENABLE_DEPTH_TEST);
}

PVector rotateVector(PVector _oldVector, float _rotX, float _rotY, float _rotZ) {  //For KOSY to KOSY rotation
  PVector newVector = new PVector(0, 0, 0);

  float cx = cos(radians(_rotX));
  float cy = cos(radians(_rotY));
  float cz = cos(radians(_rotZ));

  float sx = sin(radians(_rotX));
  float sy = sin(radians(_rotY));
  float sz = sin(radians(_rotZ));

  newVector.x =          (cz*cy)*_oldVector.x +          (sz*cy)*_oldVector.y +   (-sy)*_oldVector.z;
  newVector.y = (cz*sy*sx-sz*cx)*_oldVector.x + (sz*sy*sx+cz*cx)*_oldVector.y + (cy*sx)*_oldVector.z;
  newVector.z = (cz*sy*cx-sz*sx)*_oldVector.x + (sz*sy*cx-cz*sx)*_oldVector.y + (cy*cx)*_oldVector.z;

  return(newVector);
void updateSelectedFixture(int iNum) {
  selectedFixture = iNum;
  guiList.clear();
}



void mousePressed() {
  if (mouseButton == LEFT) {
    flag = true;
    selectedFixture = -1;
    selectedGuiObject = -1;
  }
}

void mouseWheel(MouseEvent event) {
  if (selectedGuiObject != -1) {
    guiList.get(selectedGuiObject).editValMouse(event.getCount());
  } else {
    //camPos.setMag(camPos.mag()*(1.0+event.getCount()/10.0));
    addSphereCoords(camPos, 50.0*event.getCount(), 0, 0);
  }
}

void keyPressed() {
  if (selectedGuiObject != -1) {
    guiList.get(selectedGuiObject).editValKey();
  }
}


/*
sendUdp(){
 String message = "lol rofl";
 udp.send(message, "localhost", 6454);
 }
 */



void receive(byte[] iData, String iIp, int iPort) {
  if (iData.length == 530) {                                                      // ArtNet header + 512 bytes
    for (int i=0; i<8; i++) {
      if (iData[i] != artnetHeader[i]) {                                          // First 8 bytes must match header
        print("! ArtNet header mismatch !");
        return;
      }
    }
    int universe = iData[15]<<8 | iData[14];
    if (universe >= 0  &&  universe <= 3) {
      dmxData[universe] = subset(iData, 18, 512);
    }
    /*
    for(int i=8; i<30; i++){
     print(int(iData[i]));
     print(".");
     }
     println();
     */
    //println("receive: \"" + str(subset(iData, 0, 10)) + "\" from " + iIp + " on port " + iPort);
  } else {
    println("!!! Packet of wrong length received !!!");
  }
}

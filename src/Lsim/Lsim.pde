import hypermedia.net.*;    // For UDP
UDP udp;


final int OPACITY_BEAMS = 180;       // [0-255]
final int LENGTH_BEAMS = 1000;
final int RESOLUTION_BEAMS = 20;
final float POS_TOLERANCE = 0.2;    // Threshold for moving lights pan and tilt
final int QTY_UNIVERSES = 4;
final int SIZE_GUTTER = 5;
int SIZE_X_SUBMENU;
int SIZE_X_MAINMENU;

ArrayList<Fixture> fixtureList = new ArrayList<Fixture>();
ArrayList<Cuboid> cuboidList = new ArrayList<Cuboid>();
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
  textFont(createFont("Verdana", 100, false));

  comImg = loadImage("comImg2.png");

  btnList.add(new Button(new PVector(20, 20), new PVector(width/20, width/20), "+"));
  btnList.add(new Button(new PVector(20, 20), new PVector(width/20, width/20), "++"));
  btnList.add(new Button(new PVector(20, 20), new PVector(width/20, width/20), "S"));
  btnList.add(new Button(new PVector(20, 20), new PVector(width/20, width/20), "L"));
  expandBtn = new Button(new PVector(0, 0), new PVector(width/20, width/20), ">");
}



void draw() {
  /********************* 3D Elements ********************/
  background(0);

  camera(camPos.x, camPos.y, camPos.z, 0, 0, 0, 0, 1, 0);
  fill(255);
  stroke(255);
  strokeWeight(1);
  line(0, 0, 0, 200, 0, 0);
  line(0, 0, 0, 0, 200, 0);
  line(0, 0, 0, 0, 0, 200);
  textSize(9);
  text("+X", 210, 0, 0);
  text("+Y", 0, 210, 0);
  text("+Z", 0, 0, 210);
  stroke(0);

  pushMatrix();
  translate(0, 3, 0);
  fill(#555555);
  box(2000, 6, 2000);
  popMatrix();

  if (mousePressed) {
    if (mouseButton == RIGHT) {
      addSphereCoords(camPos, 0, (pmouseY-mouseY)/100.0, (pmouseX-mouseX)/100.0);
    } else if (mouseButton == CENTER) {
      /* // ToDo: This still needs some love to work
       PVector tempDirection = new PVector();
       PVector.cross(camPos, new PVector(0, 1, 0), tempDirection);
       camPos.add(PVector.mult(tempDirection, 0.01*(mouseX-pmouseX)));
       */
    }
  }

  for (int f=0; f<fixtureList.size(); f++) {
    fixtureList.get(f).display();
  }
  for (int f=0; f<cuboidList.size(); f++) {
    cuboidList.get(f).display();
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

  for (int n=0; n<fixtureList.size(); n++) {                      // ToDo move to class
    Fixture theFixture = fixtureList.get(n);
    image(comImg, theFixture.pos2d.x-10, theFixture.pos2d.y-10, 20, 20);
    textAlign(LEFT, CENTER);
    text("Position [cm]: X " + int(theFixture.pos3d.x) + " Y " + int(theFixture.pos3d.y) + "  Z " + int(theFixture.pos3d.z), theFixture.pos2d.x, theFixture.pos2d.y-200);
    text("Rotation [deg]: X " + int(theFixture.rot.x) + " Y " + int(theFixture.rot.y) + " Z " + int(theFixture.rot.z), theFixture.pos2d.x, theFixture.pos2d.y-180);
  }

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
  PVector tempPos2 = new PVector(menuPos-(SIZE_X_MAINMENU+SIZE_X_SUBMENU)+20, 20);
  for (int b=0; b<btnList.size(); b++) {
    btnList.get(b).pos = tempPos2.get();
    tempPos2.add(new PVector(0, btnList.get(b).size.y));
    tempPos2.add(new PVector(0, SIZE_GUTTER));
    btnList.get(b).display();
  }
  expandBtn.pos.x = menuPos;
  expandBtn.display();
  hint(ENABLE_DEPTH_TEST);
}



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
  } else if (key == ' ') {
  }
}

void saveAll() {
  String[] saveData = new String[fixtureList.size()];
  for (int f=0; f<fixtureList.size(); f++) {
    saveData[f] = fixtureList.get(f).getSaveString();
  }
  saveStrings("/save/fixtures.lsm", saveData);
  println("Saved " + str(fixtureList.size()) + " Fixtures.");
}

void loadAll() {
  fixtureList.clear();
  String[] loadData = loadStrings("/save/fixtures.lsm");
  for (int f=0; f<loadData.length; f++) {
    fixtureList.add(new Fixture());
    fixtureList.get(f).setLoadString(loadData[f]);
  }
  println("Loaded " + str(loadData.length) + " Fixtures.");
}

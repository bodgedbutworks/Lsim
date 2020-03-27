import hypermedia.net.*;    // For UDP
import java.util.Arrays;
UDP udp;


final int OPACITY_BEAMS = 180;       // [0-255]
final int LENGTH_BEAMS = 2000;
final int RESOLUTION_BEAMS = 20;
final float POS_TOLERANCE = 0.2;    // Threshold for moving lights pan and tilt
final int QTY_UNIVERSES = 4;
final int SIZE_GUTTER = 5;
int SIZE_X_SUBMENU;
int SIZE_X_MAINMENU;
String PATH_FIXTURES = "/save/fixtures/";

// ToDo merge fixture and cuboid lists if feasible
ArrayList<Fixture> fixtureList = new ArrayList<Fixture>();
ArrayList<Cuboid> cuboidList = new ArrayList<Cuboid>();
Expandable menuExpLeft;
Expandable menuExpRight;
Button expandBtn;
float menuXpos = 0;                                                             // Closed -> 0, Expanded -> positive
byte menuState = 0;                                                             // 0=closed, 1=expanding, 2=expanded, 3=closing
boolean scrolling = false;
int menuScroll = 0;

PVector camPos = new PVector(900, -300, 900);
PVector camLookAt = new PVector(0, -200, 0);
PImage comImg;

byte[] artnetHeader = {'A', 'r', 't', '-', 'N', 'e', 't', '\0'};
byte[][] dmxData = new byte[4][512];                                            // [universe][address]

int selectedFixture = -1;
GuiObject selectedGuiObject = null;
long lastFrameTime = 0;
long calcFrameRate = 1000;
boolean lightsOff = false;                                                      // Activation of ambient/directional lights
boolean flag = false;
ScreenObject reloadMyGui;     // GUI sometimes can't be reloaded directly because it would delete the calling element, instead, do it in main loop

PShape env;



void setup() {
  size(1500, 900, P3D);
  //fullScreen(P3D, 1);
  surface.setResizable(true);
  frameRate(60);

  SIZE_X_SUBMENU = width/5;
  SIZE_X_MAINMENU = width/10;

  udp = new UDP(this, 6454);
  //udp.log(true);
  udp.listen(true);

  rectMode(CORNERS);
  ellipseMode(CENTER);
  textFont(createFont("Khmer UI", 100, false));

  comImg = loadImage("comImg2.png");

  reloadMyGui = null;

  expandBtn = new Button(new PVector(0, 0), new PVector(width/20, width/20), ">", ">");

  menuExpLeft = new Expandable(new PVector(0, 0), new PVector(0, 0), "", false, true);
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "+", "+"));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "++", "++"));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "S", "S"));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "L", "L"));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "*", "*"));

  Expandable loadFixExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Load Fixtures", true, false);
  File dir = new File(sketchPath() + PATH_FIXTURES);
  if (dir.isDirectory()) {
    String names[] = dir.list();
    for (String n : names) {
      loadFixExp.put(new Button(new PVector(0, 0), new PVector(width/12, width/40), "loadfilename", n));
    }
  } else {
    print("Error while loading environments!");
  }
  menuExpLeft.put(loadFixExp);

  menuExpRight = new Expandable(new PVector(0, 0), new PVector(0, 0), "", false, true);

  File file = new File(sketchPath() + "/data/");
  if (file.isDirectory()) {
    String names[] = file.list();
    for (String n : names) {
      if (n.indexOf("env") != -1) {
        println(n);
      }
    }
  } else {
    print("Error while loading environments!");
  }

  env = loadShape("env_test1.obj");
  env.disableStyle();  // Ignore the colors in the SVG
}



void draw() {
  /********************* 3D Elements ********************/
  background(0);

  if (lightsOff) {
    ambientLight(128, 128, 128);
    directionalLight(128, 128, 128, 0, 0, -1);
  }

  camera(camPos.x, camPos.y, camPos.z, camLookAt.x, camLookAt.y, camLookAt.z, 0, 1, 0);
  fill(255);
  stroke(255);
  strokeWeight(1);
  line(0, -1, 0, 70, -1, 0);
  line(0, -1, 0, 0, -71, 0);
  line(0, -1, 0, 0, -1, 70);
  textSize(height/90);
  text("+X", 80, -10, 0);
  text("-Y", 0, -80, 0);
  text("+Z", 0, -10, 80);
  stroke(0);

  pushMatrix();
  translate(0, 1000, 0);
  stroke(#222222);
  strokeWeight(5);
  fill(#333333);
  box(6000, 2000, 6000);
  popMatrix();

  if (mousePressed) {
    if (mouseButton == RIGHT) {
      camPos = addSphereCoords(PVector.sub(camPos, camLookAt), 0, (pmouseY-mouseY)/100.0, (pmouseX-mouseX)/100.0);
      camPos.add(camLookAt);
    } else if (mouseButton == CENTER) {
      float xzDir = atan2(camPos.z, camPos.x);
      camLookAt.add(new PVector((pmouseX-mouseX)*sin(xzDir), pmouseY-mouseY, -(pmouseX-mouseX)*cos(xzDir)));
      camPos.add(new PVector((pmouseX-mouseX)*sin(xzDir), pmouseY-mouseY, -(pmouseX-mouseX)*cos(xzDir)));
    }
  }

  pushMatrix();
  noStroke();
  fill(70);
  translate(0, -1, 0);
  shape(env);
  popMatrix();

  for (int f=0; f<fixtureList.size(); f++) {
    fixtureList.get(f).display();
  }
  for (int f=0; f<cuboidList.size(); f++) {
    cuboidList.get(f).display();
  }

  /********************* 2D Elements ********************/
  if (reloadMyGui != null) {
    println("GUI Reeeeeeloading!");
    menuExpRight.subElementsList.clear();
    reloadMyGui.loadGui();
    reloadMyGui = null;
  }
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
    if (abs(menuXpos-(SIZE_X_SUBMENU+SIZE_X_MAINMENU)) > 0.2) {
      menuXpos += 0.2*((SIZE_X_SUBMENU+SIZE_X_MAINMENU)-menuXpos);
    } else {
      menuXpos = SIZE_X_SUBMENU+SIZE_X_MAINMENU;
      menuState = 2;
    }
    break;
  case 2:
    break;
  case 3:
    if (menuXpos > 0.2) {
      menuXpos -= 0.2*menuXpos;
    } else {
      menuXpos = 0;
      menuState = 0;
    }
    break;
  default:
    break;
  }
  stroke(0);
  strokeWeight(2);
  fill(60);
  rect(menuXpos-(SIZE_X_SUBMENU+SIZE_X_MAINMENU), 0, menuXpos, height);
  if (flag && mousePressed && mouseX>=(menuXpos-SIZE_X_SUBMENU-10) && mouseX<=(menuXpos-SIZE_X_SUBMENU+10) && mouseY>=(menuScroll-30) && mouseY<=(menuScroll+30)) {
    flag = false;
    scrolling = true;
  }
  if (scrolling) {
    menuScroll += mouseY-pmouseY;
  }
  menuScroll = constrain(menuScroll, 0, height);
  stroke(0);
  strokeWeight(1);
  fill(100);
  rect(menuXpos-SIZE_X_SUBMENU-10, menuScroll-30, menuXpos-SIZE_X_SUBMENU+10, menuScroll+30);
  expandBtn.pos.x = menuXpos;
  expandBtn.display();
  menuExpLeft.pos = PVector.add(new PVector(menuXpos-(SIZE_X_MAINMENU+SIZE_X_SUBMENU)+20, 20-menuScroll), menuExpLeft.offset);
  menuExpLeft.display();
  menuExpRight.pos = PVector.add(new PVector(menuXpos-(SIZE_X_SUBMENU)+20, 20-menuScroll), menuExpRight.offset);
  menuExpRight.display();
  hint(ENABLE_DEPTH_TEST);
}



void updateSelectedFixture(int iNum) {
  selectedFixture = iNum;
  menuExpRight.subElementsList.clear();
}



void mousePressed() {
  if (mouseButton == LEFT) {
    flag = true;
    selectedFixture = -1;
    selectedGuiObject = null;
  }
}


void mouseReleased() {
  scrolling = false;
}



void mouseWheel(MouseEvent event) {
  if (selectedGuiObject != null) {
    selectedGuiObject.editValMouse(event.getCount());
  } else {
    if (menuState == 2  &&  mouseX <= SIZE_X_SUBMENU+SIZE_X_MAINMENU) {
      menuScroll += 100*event.getCount();
    } else {
      camPos = addSphereCoords(camPos, 80.0*event.getCount(), 0, 0);
    }
  }
}

void keyPressed() {
  if (selectedGuiObject != null) {
    selectedGuiObject.editValKey();
  } else if (key == ' ') {
  }
}

void saveAll() {
  String[] saveDataFix = new String[fixtureList.size()];
  for (int f=0; f<fixtureList.size(); f++) {
    saveDataFix[f] = fixtureList.get(f).getSaveString();
  }
  saveStrings("/save/fixtures.lsm", saveDataFix);
  println("Saved " + str(fixtureList.size()) + " Fixtures.");

  String[] saveDataCub = new String[cuboidList.size()];
  for (int f=0; f<cuboidList.size(); f++) {
    saveDataCub[f] = cuboidList.get(f).getSaveString();
  }
  saveStrings("/save/cuboids.lsm", saveDataCub);
  println("Saved " + str(cuboidList.size()) + " Cuboids.");
}

void loadAll() {
  fixtureList.clear();
  cuboidList.clear();
  menuExpRight.subElementsList.clear();

  println("\n --- Loading ---");

  try {
    String[] loadDataFix = loadStrings("/save/fixtures.lsm");
    for (int f=0; f<loadDataFix.length; f++) {
      fixtureList.add(new Fixture());
      fixtureList.get(f).setLoadArray(loadDataFix[f].split(";"));
    }
    println("Loaded " + str(loadDataFix.length) + " Fixtures.");
  }
  catch(Exception e) {
    println("Error while loading file /save/fixtures.lsm");
    println(e);
  }

  try {
    String[] loadDataCub = loadStrings("/save/cuboids.lsm");
    for (int f=0; f<loadDataCub.length; f++) {
      cuboidList.add(new Cuboid());
      cuboidList.get(f).setLoadArray(loadDataCub[f].split(";"));
    }
    println("Loaded " + str(loadDataCub.length) + " Cuboids.");
  }
  catch(Exception e) {
    println("Error while loading file /save/cuboids.lsm");
    println(e);
  }
}

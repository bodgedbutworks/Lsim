import hypermedia.net.*;    // For UDP
import java.util.Arrays;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
UDP udp;


final int OPACITY_BEAMS = 180;       // [0-255]
final int LENGTH_BEAMS = 2000;
final int RESOLUTION_BEAMS = 20;
final float POS_TOLERANCE = 0.2;    // Threshold for moving lights pan and tilt
final int QTY_UNIVERSES = 4;
final int SIZE_GUTTER = 5;
int SIZE_MENU_RIGHT;
int SIZE_MENU_LEFT;
String PATH_FIXTURES = "/save/fixtures/";
String PATH_ENVIRONMENTS = "/data/";                                            // .obj files must be in data/ dir in Processing
String PATH_PROJECTS = "/save/projects/";
// Saturation 57%, Brightness 100%, Hue varied
color CLR_MENU_LV1 = #FF00FF;
color CLR_MENU_LV2 = #FFD68C;
color CLR_MENU_LV3 = #6CE8FF;

ArrayList<Fixture> fixtureList = new ArrayList<Fixture>();
ArrayList<Cuboid> cuboidList = new ArrayList<Cuboid>();
Expandable menuExpLeft;
Expandable menuExpRight;
Button expandBtn;
float menuXpos = 0;                                                             // Closed -> 0, Expanded -> positive
byte menuState = 0;                                                             // 0=closed, 1=expanding, 2=expanded, 3=closing
boolean scrolling = false;
int menuScroll = 0;

String projectName = "Oops";

PVector camPos = new PVector(900, -300, 900);
PVector camLookAt = new PVector(0, -200, 0);
PImage comImg;
boolean showNamesAndComs = true;                                                // Toggle display of names and Center-Of-Mass icons

byte[] artnetHeader = {'A', 'r', 't', '-', 'N', 'e', 't', '\0'};
byte[][] dmxData = new byte[4][512];                                            // [universe][address]

ScreenObject selectedScreenObject = null;
GuiObject selectedGuiObject = null;
long lastFrameTime = 0;
long calcFrameRate = 1000;
boolean lightsOff = false;                                                      // Activation of ambient/directional lights
boolean flag = false;
ScreenObject reloadMyGui;     // GUI sometimes can't be reloaded directly because it would delete the calling element, instead, do it in main loop
boolean deleteMyGui = false;                                                    // Clear right hand side GUI (f.ex. when deleting a Fixture)

PShape environmentShape;
String environmentFileName = "";                                                // Save filename to be able to save environment later



void setup() {
  size(1500, 900, P3D);
  //fullScreen(P3D, 1);
  surface.setResizable(true);
  frameRate(60);

  SIZE_MENU_LEFT = width/9;
  SIZE_MENU_RIGHT = width/6;

  udp = new UDP(this, 6454);
  //udp.log(true);
  udp.listen(true);

  rectMode(CORNERS);
  ellipseMode(CENTER);
  textFont(createFont("Khmer UI", 100, false));

  comImg = loadImage("comImg2.png");

  reloadMyGui = null;

  projectName = "Projname_" + ZonedDateTime.now(ZoneId.systemDefault()).format(DateTimeFormatter.ofPattern( "uuuu_MM_dd HH_mm_ss" ));

  expandBtn = new Button(new PVector(0, 0), new PVector(width/30, width/25), ">", ">", color(100, 70, 100));

  menuExpLeft = new Expandable(new PVector(0, 0), new PVector(0, 0), "", false, true, CLR_MENU_LV1);
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "+", "Add\nFixture", CLR_MENU_LV1));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "++", "Add\nCuboid", CLR_MENU_LV1));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "COM", "Toggle\nNames", CLR_MENU_LV1));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "*", "Toggle\nLights", CLR_MENU_LV1));
  menuExpLeft.put(new Button(new PVector(0, 0), new PVector(width/20, width/20), "S", "Save\nProject", CLR_MENU_LV1));
  menuExpLeft.put(new NameBox(new PVector(0, 0), new PVector(width/15, 25), "projectName", "", projectName));

  // Load fixtures
  Expandable loadFixExp = new Expandable(new PVector(0, 20), new PVector(0, 0), "Fixtures", true, false, CLR_MENU_LV1);
  File dir = new File(sketchPath() + PATH_FIXTURES);
  if (dir.isDirectory()) {
    String names[] = dir.list();
    for (String n : names) {
      loadFixExp.put(new Button(new PVector(0, 0), new PVector(width/12, width/40), "loadfixfilename", n, CLR_MENU_LV2));
    }
  } else {
    print("Error while scanning fixtures!");
  }
  menuExpLeft.put(loadFixExp);

  // Load environment
  Expandable loadEnvExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Environments", true, false, CLR_MENU_LV1);
  loadEnvExp.put(new Button(new PVector(0, 0), new PVector(width/12, width/40), "loadenvfilename", "None", CLR_MENU_LV2));
  dir = new File(sketchPath() + PATH_ENVIRONMENTS);
  if (dir.isDirectory()) {
    String names[] = dir.list();
    for (String n : names) {
      if (n.indexOf("env_") != -1) {
        loadEnvExp.put(new Button(new PVector(0, 0), new PVector(width/12, width/40), "loadenvfilename", n, CLR_MENU_LV2));
      }
    }
  } else {
    print("Error while scanning environments!");
  }
  menuExpLeft.put(loadEnvExp);

  // Load projects
  Expandable loadProjExp = new Expandable(new PVector(0, 0), new PVector(0, 0), "Projects", true, false, CLR_MENU_LV1);
  dir = new File(sketchPath() + PATH_PROJECTS);
  if (dir.isDirectory()) {
    String names[] = dir.list();
    for (String n : names) {
      loadProjExp.put(new Button(new PVector(0, 0), new PVector(width/12, width/40), "loadprojfilename", n, CLR_MENU_LV2));
    }
  } else {
    print("Error while scanning projects!");
  }
  menuExpLeft.put(loadProjExp);


  menuExpRight = new Expandable(new PVector(0, 0), new PVector(0, 0), "", false, true, CLR_MENU_LV1);
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
      // ToDo this movement behaves a bit unintuitively
      float xzDir = atan2(camPos.z, camPos.x);
      camLookAt.add(new PVector((pmouseX-mouseX)*sin(xzDir), pmouseY-mouseY, -(pmouseX-mouseX)*cos(xzDir)));
      camPos.add(new PVector((pmouseX-mouseX)*sin(xzDir), pmouseY-mouseY, -(pmouseX-mouseX)*cos(xzDir)));
    }
  }

  if (environmentShape != null) {
    pushMatrix();
    noStroke();
    fill(70);
    translate(0, -1, 0);
    shape(environmentShape);
    popMatrix();
  }

  for (Fixture f : fixtureList) {
    f.display();
  }
  for (Cuboid c : cuboidList) {
    c.display();
  }

  if (reloadMyGui != null) {
    println("GUI Reeeeeeloading!");
    menuExpRight.subElementsList.clear();
    reloadMyGui.loadGui();
    reloadMyGui = null;
  }
  if (deleteMyGui) {
    println("Clearing GUI!");
    deleteMyGui = false;
    menuExpRight.subElementsList.clear();
  }

  /********************* 2D Elements ********************/
  camera();
  hint(DISABLE_DEPTH_TEST);
  fill(255);
  textSize(height/50);
  textAlign(RIGHT, TOP);
  if (frameCount % 15 == 0) {
    calcFrameRate = int(0.8*calcFrameRate + 0.2*(1000/(millis()-lastFrameTime+1)));  // Average about 5 frames
  }
  lastFrameTime = millis();
  text(int(calcFrameRate), width-10, 7);                                        // Print framerate

  if (showNamesAndComs) {
    for (Fixture f : fixtureList) {
      f.draw2d();
    }
    for (Cuboid c : cuboidList) {
      c.draw2d();
    }
  }

  // Menu sidebar
  switch(menuState) {
  case 0:
    break;
  case 1:
    if (abs(menuXpos-(SIZE_MENU_RIGHT+SIZE_MENU_LEFT)) > 0.2) {
      menuXpos += 0.2*((SIZE_MENU_RIGHT+SIZE_MENU_LEFT)-menuXpos);
    } else {
      menuXpos = SIZE_MENU_RIGHT+SIZE_MENU_LEFT;
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
  rect(menuXpos-(SIZE_MENU_RIGHT+SIZE_MENU_LEFT), 0, menuXpos, height);
  if (flag && mousePressed && mouseX>=(menuXpos-SIZE_MENU_RIGHT-10) && mouseX<=(menuXpos-SIZE_MENU_RIGHT+10) && mouseY>=(menuScroll-30) && mouseY<=(menuScroll+30)) {
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
  rect(menuXpos-SIZE_MENU_RIGHT-10, menuScroll-30, menuXpos-SIZE_MENU_RIGHT+10, menuScroll+30);
  expandBtn.pos.x = menuXpos;
  expandBtn.display();
  menuExpLeft.pos = PVector.add(new PVector(menuXpos-(SIZE_MENU_LEFT+SIZE_MENU_RIGHT)+20, 20-menuScroll), menuExpLeft.offset);
  menuExpLeft.display();
  menuExpRight.pos = PVector.add(new PVector(menuXpos-(SIZE_MENU_RIGHT)+20, 20-menuScroll), menuExpRight.offset);
  menuExpRight.display();
  hint(ENABLE_DEPTH_TEST);
}




void mousePressed() {
  if (mouseButton == LEFT) {
    flag = true;
    selectedScreenObject = null;
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
    if (menuState == 2  &&  mouseX <= SIZE_MENU_RIGHT+SIZE_MENU_LEFT) {
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
  println("\n--- Saving Project ---");
  int fls = fixtureList.size();
  int cls = cuboidList.size();
  String[] saveData = new String[fls+cls+((environmentShape!=null)? 1 : 0)];
  for (int f=0; f<fls; f++) {
    saveData[f] = "Fixture_;" + fixtureList.get(f).getSaveString();
  }
  for (int c=0; c<cls; c++) {
    saveData[fls+c] = "Cuboid_;" + cuboidList.get(c).getSaveString();
  }
  if (environmentShape != null) {
    saveData[fls+cls] = "Environment_;" + environmentFileName;
  }

  try {
    saveStrings(PATH_PROJECTS + projectName + ".lsm", saveData);
    println("Saved " + str(fls) + " Fixtures.");
    println("Saved " + str(cls) + " Cuboids.");
    if (environmentShape != null) {
      println("Saved the environment (lol).");
    }
  }
  catch(Exception e) {
    print(e);
  }
}

void loadAll(String iFileName) {
  // Commented to try loading multiple projects at once
  //fixtureList.clear();
  //cuboidList.clear();
  //menuExpRight.subElementsList.clear();
  //environmentShape = null;
  //environmentFileName = "";

  int countFix = 0;
  int countCub = 0;
  boolean loadedEnv = false;
  println("\n--- Loading Project ---");
  try {
    String[] loadData = loadStrings(PATH_PROJECTS + iFileName);
    for (String d : loadData) {
      if (d.indexOf("Fixture_;") == 0) {                                        // Identifier at BEGINNING of string
        Fixture tempFix = new Fixture();
        tempFix.setLoadArray(d.substring(d.indexOf(";")+1, d.length()).split(";"));   // Cut away identifier
        fixtureList.add(tempFix);
        countFix++;
      } else if (d.indexOf("Cuboid_;") == 0) {
        Cuboid tempCub = new Cuboid();
        tempCub.setLoadArray(d.substring(d.indexOf(";")+1, d.length()).split(";"));
        cuboidList.add(tempCub);
        countCub++;
      } else if (d.indexOf("Environment_;") == 0) {
        environmentFileName = d.substring(d.indexOf(";")+1, d.length());
        environmentShape = loadShape(sketchPath() + PATH_ENVIRONMENTS + environmentFileName);
        environmentShape.disableStyle();                                        // Ignore the colors in the SVG
        loadedEnv = true;
      }
    }
    println("Loaded " + str(countFix) + " Fixtures.");
    println("Loaded " + str(countCub) + " Cuboids.");
    if (loadedEnv) {
      println("Loaded an environment.");
    }
  }
  catch(Exception e) {
    println("Error while loading project " + iFileName + "!");
    println(e);
  }
}

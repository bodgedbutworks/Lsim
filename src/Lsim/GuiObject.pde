class GuiObject {
  private PositionUnit positionData;
  //PVector offset;     // Position offset, added to temporary position before saving to pos
  //PVector pos;        // Actual element pos, used for mouseover/displaying, set by "parent" Expandable //not in use anymore insted positionData

  private Object generalRef;
  String objType = "";

  String propName = "";
  String displayName = "";
  String valStr = "42.0";
  String utilStr = "0";                                                         // Used while editing via keyboard, later applied to valStr
  byte keyEditState = 0;                                                        // 0=idle, 1=editing
  float stepSize = 1.0;
  color clr = color(255, 0, 255);

  // Overloaded constructor for every object type reference
  GuiObject(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    objType = "None";
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);  // Initialize object type independent properties     //null is very bad just for porposis of the clean code cleaning at the end correct this agean
  }
  
  GuiObject(PVector iOffset, PVector iSize, Object iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    if(iObjRef.equals(Fixture.class)) {
      objType = "Fixture";
    } else if (iObjRef.equals(Cuboid.class)) {
      objType = "Cuboid";
    } else if (iObjRef.equals(Pixel.class)) {
      objType = "Pixel";
    } else if (iObjRef.equals(Dynamics.class)) {
      objType = "Dynamics";
    } else if (iObjRef.equals(Expandable.class)) {
      objType = "Expandable";
    }
    this.generalRef = iObjRef;
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  
  //expandable is the one how makes the problems with the button sub thing
  GuiObject(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    objType = "Expandable";
    this.generalRef = iObjRef;
    init(iOffset, iSize, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  
  void init(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    PVector empty = new PVector(0, 0);
    propName = iPropName;
    displayName = iDisplayName;
    valStr = iInitialVal;
    stepSize = iStepSize;
    this.positionData = new PositionUnit(empty, empty, iSize, iOffset, false);
  }

  void editValMouse(float iEventGetCount) {
    iEventGetCount *= stepSize;
    if (keyPressed  &&  key==CODED  &&  keyCode==CONTROL) {
      iEventGetCount *= 10;
    } else if (keyPressed  &&  key==CODED  &&  keyCode==SHIFT) {
      iEventGetCount *= 100;
    }
    valStr = str(float(valStr)-iEventGetCount);
  }

  void editValKey() {
  }

  void display() {
  }

  // Returns true if mouse was clicked inside hitbox. Setting of selectedGuiObject moved
  // to child classes because some of them (f.ex. Button) arent't supposed to be a selectedGuiObject
  boolean checkMouseOver() {
    if (mouseX > getPosition().x  &&  mouseX < (getPosition().x+this.positionData.getSize2D().x)  &&  mouseY > getPosition().y  &&  mouseY < (getPosition().y+this.positionData.getSize2D().y)) {
      if (flag  &&  mousePressed) {
        flag = false;
        return(true);
      }
    }
    return(false);
  }
  
  public PVector getPosition() {
    return this.positionData.getPosition2D(); 
  }
  
  public void setPosition(PVector iPosition) {
    this.positionData.setPosition2D(iPosition); 
  }
  
  private PVector getRotation() {
    return this.positionData.getRotation2D(); 
  }
  
  private void setRotation(PVector iRotation) {
    this.positionData.setRotation2D(iRotation); 
  }
  
  public PVector getSize() {
    return this.positionData.getSize2D(); 
  }
  
  public void setSize(PVector iSize) {
    this.positionData.setSize2D(iSize); 
  }
  
  public PVector getOffset() {
    return this.positionData.getDirection2D(); 
  }
  
  private void setOffset(PVector iOffset) {
    this.positionData.setDirection2D(iOffset); 
  }
  
  //-------------------------- the following schould be schrinked down to one get'er if generics come in
  
  
  public Fixture getObjektRefFixture() {
    return (Fixture) this.generalRef; 
  }
  public Cuboid getObjektRefCuboud() {
    return (Cuboid) this.generalRef; 
  }
  public Pixel getObjektRefPixel() {
    return (Pixel) this.generalRef; 
  }
  public Expandable getObjektRefExpandable() {
    return (Expandable) this.generalRef; 
  }
  public Dynamics getObjektRefDynamix() {
    return (Dynamics) this.generalRef; 
  }
  private Object getObjektRefString() {
    return (Object) this.generalRef; 
  }
}

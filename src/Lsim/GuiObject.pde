class GuiObject<T extends IGuiObject> implements IGuiObject{
  private PositionUnit positionData;
  //PVector offset;     // Position offset, added to temporary position before saving to pos
  //PVector pos;        // Actual element pos, used for mouseover/displaying, set by "parent" Expandable //not in use anymore insted positionData

  private T generalRef;
  private Expandable generalRefE;
  private String objType = ""; // this is just used to name the specific class change to xxx.clas.equals(XXX.class) <-- tried it dident work but I will try it agean later

  String propName = "";
  String displayName = "";
  String valStr = "42.0";
  String utilStr = "0";                                                         // Used while editing via keyboard, later applied to valStr
  byte keyEditState = 0;                                                        // 0=idle, 1=editing
  float stepSize = 1.0;
  color clr = color(255, 0, 255);

  // Overloaded constructor for every object type reference
  GuiObject(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    this.objType = "None";
    init(iOffset, iSize, null, iPropName, iDisplayName, iInitialVal, iStepSize);  // Initialize object type independent properties     //null is very bad just for porposis of the clean code cleaning at the end correct this agean
  }
  
  GuiObject(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    
    ///*
    if(iObjRef.equals(Fixture.class)) {
      this.objType = "Fixture";
    } else if (iObjRef.equals(Cuboid.class)) {
      this.objType = "Cuboid";
    } else if (iObjRef.equals(Pixel.class)) {
      this.objType = "Pixel";
    } else if (iObjRef.equals(Dynamics.class)) {
      this.objType = "Dynamics";
    } else if (iObjRef.equals(Expandable.class)) {
      this.objType = "Expandable";
    }
    //*/
    //100 % unsure if this below replaces this obove. not quiet it must be something like T.class.toString()
    //this.objType = iObjRef.toString();
    init(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  
  //expandable is the one how makes the problems with the button sub thing
  GuiObject(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    this.objType = "Expandable";
    initE(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, iStepSize);
  }
  
  void init(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    PVector empty = new PVector(0, 0);
    propName = iPropName;
    displayName = iDisplayName;
    valStr = iInitialVal;
    stepSize = iStepSize;
    this.positionData = new PositionUnit(empty, empty, iSize, iOffset, false);
    this.generalRef = iObjRef;
  }
  
  void initE(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, String iInitialVal, float iStepSize) {
    PVector empty = new PVector(0, 0);
    propName = iPropName;
    displayName = iDisplayName;
    valStr = iInitialVal;
    stepSize = iStepSize;
    this.positionData = new PositionUnit(empty, empty, iSize, iOffset, false);
    this.generalRefE = iObjRef;
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
  
  public void setRotation(PVector iRotation) {
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
  
  public String getObjTyp() {
    return this.objType;
  }
  
  public Object getGeneralRef() {
    if(this.equals(Expandable.class)) {
      return this.generalRefE;
    } else {
      return this.generalRef;
    }
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
    return (Expandable) this.generalRefE; 
  }
  public Dynamics getObjektRefDynamix() {
    return (Dynamics) this.generalRef; 
  }
  private Object getObjektRefString() {
    return (Object) this.generalRef; 
  }
}

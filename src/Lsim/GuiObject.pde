/**
* @brief parent class for GUI objects
*/
class GuiObject<T extends IGuiObject> extends IGuiObject{

  public T generalRef;
  private Expandable generalRefE;
  private String objType = ""; // this is just used to name the specific class change to xxx.clas.equals(XXX.class) <-- tried it dident work but I will try it agean later

  float valNr = 42.0;
                                                        // Used while editing via keyboard, later applied to valStr
  byte keyEditState = 0;                                                        // 0=idle, 1=editing
  float stepSize = 1.0;

  // Overloaded constructor for every object type reference
  GuiObject(PVector iOffset, PVector iSize, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    this.objType = "None";
    init(iOffset, iSize, null, iPropName, iDisplayName, iInitialVal, iStepSize);  // Initialize object type independent properties     //null is very bad just for porposis of the clean code cleaning at the end correct this agean
  }
  
  GuiObject(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    
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
    this.objectColor = color(255, 0, 255);
  }
  
  //expandable is the one how makes the problems with the button sub thing
  GuiObject(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    this.objType = "Expandable";
    initE(iOffset, iSize, iObjRef, iPropName, iDisplayName, iInitialVal, iStepSize);
    this.objectColor = color(255, 0, 255);
  }
  
  void init(PVector iOffset, PVector iSize, T iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    PVector empty = new PVector(0, 0);
    this.properName = iPropName;
    this.displayName = iDisplayName;
    valNr = iInitialVal;
    stepSize = iStepSize;
    this.positionData = new PositionUnit(empty, empty, iSize, iOffset, false);
    this.generalRef = iObjRef;
  }
  
  void initE(PVector iOffset, PVector iSize, Expandable iObjRef, String iPropName, String iDisplayName, float iInitialVal, float iStepSize) {
    PVector empty = new PVector(0, 0);
    this.properName = iPropName;
    displayName = iDisplayName;
    valNr = iInitialVal;
    stepSize = iStepSize;
    this.positionData = new PositionUnit(empty, empty, iSize, iOffset, false);
    this.generalRefE = iObjRef;
  }

  /**
  * @brief Method that gets get triggert if mouse wheel is scrollen and this GuiObject is focused
  * @param iEventGetCount Number of mousewheel scroll ticks
  */
  void editValMouse(float iEventGetCount) {
    iEventGetCount *= stepSize;
    if (keyPressed  &&  key==CODED  &&  keyCode==CONTROL) {
      iEventGetCount *= 10;
    } else if (keyPressed  &&  key==CODED  &&  keyCode==SHIFT) {
      iEventGetCount *= 100;
    }
    valNr = valNr - iEventGetCount;
    PVector transitionalPosition = generalRef.getPosition();
    PVector transitionalRotation = generalRef.getRotation();
    PVector transitionalSize = generalRef.getSize();
    if(this.properName == "pos3d.x" ) {
      transitionalPosition.set(valNr, transitionalPosition.y, transitionalPosition.z);
      generalRef.setPosition(transitionalPosition);
    } else if(this.properName == "pos3d.y") {
      transitionalPosition.set(transitionalPosition.x, valNr, transitionalPosition.z);
      generalRef.setPosition(transitionalPosition);
    } else if(this.properName == "pos3d.z") {
      transitionalPosition.set(transitionalPosition.x, transitionalPosition.y, valNr);
      generalRef.setPosition(transitionalPosition);
    } else if(this.properName == "rot.x") {
      transitionalRotation.set(valNr, transitionalRotation.y, transitionalRotation.z);
      generalRef.setRotation(transitionalRotation);
    } else if(this.properName == "rot.y") {
      transitionalRotation.set(transitionalRotation.x, valNr, transitionalRotation.z);
      generalRef.setRotation(transitionalRotation);
    } else if(this.properName == "rot.z") {
      transitionalRotation.set(transitionalRotation.x, transitionalRotation.y, valNr);
      generalRef.setRotation(transitionalRotation);
    } else if(this.properName =="size3d.x") {
      transitionalSize.set(valNr, transitionalSize.y, transitionalSize.z);
      generalRef.setSize(transitionalSize);
    } else if(this.properName =="size3d.y") {
      transitionalSize.set(transitionalSize.x, valNr, transitionalSize.z);
      generalRef.setSize(transitionalSize);
    } else if(this.properName =="size3d.z") {
      transitionalSize.set(transitionalSize.x, transitionalSize.y, valNr);
      generalRef.setSize(transitionalSize);
    }
  }

  /**
  * @brief function for value edit via keyboard
  */
  void editValKey() {
  }

  /**
  * @brief function for GuiObject display
  */
  void display() {
  }

  /**
  * @brief Checks for mouse over and click inside focused GuiObject's hitbox
  * @return true if mouse was clicked inside focused GuiObject's hitbox
  */
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
  
  public PVector getRotation() {
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

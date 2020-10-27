abstract class IGuiObject {
    
  public PositionUnit positionData;
  public String properName;
  public String displayName;
  public color objectColor;
  
  
  public abstract PVector getPosition();
  public abstract PVector getRotation();
  public abstract PVector getSize();
  
  public abstract void setPosition(PVector iNewPosition);
  public abstract void setRotation(PVector iNewRotation);
  public abstract void setSize(PVector iSize);
}

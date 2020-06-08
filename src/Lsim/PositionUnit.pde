class PositionUnit {

  private PVector position3D;
  private PVector rotation3D;
  private PVector size3D;
  private PVector direction3D;
  
  private PVector position2D;
  private PVector rotation2D;
  private PVector size2D;
  private PVector direction2D; //also used as offset
  
  /**
  * 
  */
  public PositionUnit(final PVector iPosition3D, final PVector iRotation3D, final PVector iSize3D, final PVector iDirection3D, final PVector iPosition2D, final PVector iRotation2D, final PVector iSize2D, final PVector iDirection2D) {
    this.position3D = iPosition3D;
    this.rotation3D = iRotation3D;
    this.size3D = iSize3D;
    this.direction3D = iDirection3D;
    
    this.position2D = iPosition2D;
    this.rotation2D = iRotation2D;
    this.size2D = iSize2D;
    this.direction2D = iDirection2D;
  }
  
  /**
  * 
  */
  public PositionUnit(final PVector iPosition, final PVector iRotation, final PVector iSize, final PVector iDirection, final boolean iIs3DVector) {
    if(iIs3DVector) {
      this.position3D = iPosition;
      this.rotation3D = iRotation;
      this.size3D = iSize;
      this.direction3D = iDirection;
    } else if(!iIs3DVector) {
      this.position2D = iPosition;
      this.rotation2D = iRotation;
      this.size2D = iSize;
      this.direction2D = iDirection;
    }
  }
  
  //more constructores probabley needed
  
  public PVector getPosition3D() {
    return this.position3D; 
  }
  
  public PVector getRotation3D() {
    return this.rotation3D; 
  }
  
  public PVector getSize3D() {
    return this.size3D; 
  }
  
  public PVector getDirection3D() {
    return this.direction3D; 
  }
  
  public PVector getPosition2D() {
    return this.position2D; 
  }
  
  public PVector getRotation2D() {
    return this.rotation2D; 
  }
  
  public PVector getSize2D() {
    return this.size2D; 
  }
  
  public PVector getDirection2D() {
    return this.direction2D; 
  }
  
  public void setPosition2D(PVector iNewPosition) {
    this.position2D = iNewPosition;
  }

}

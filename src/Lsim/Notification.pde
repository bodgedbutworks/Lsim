class Notification {
  int ttl;                                                                      // Time to live in seconds
  long birthTime;
  final PositionUnit positionUnit2DNotification;
  color clr;
  String txt;

  Notification(String iTxt, color iClr, int iTtl) {
    txt = iTxt;
    clr = iClr;
    ttl = iTtl;
    birthTime = millis();
    
    PVector pos = new PVector(0, 0);
    PVector rot = new PVector(0,0);
    PVector size = new PVector(400, 70);
    PVector offset = new PVector(0, 0);
    this.positionUnit2DNotification = new PositionUnit(pos, rot, size, offset, false);
  }

  boolean checkMouseOver() {
    boolean moseCheckOne = mouseX > this.positionUnit2DNotification.getPosition2D().x;
    boolean moseCheckTwo = mouseX < (this.positionUnit2DNotification.getPosition2D().x + this.positionUnit2DNotification.getSize2D().x);
    boolean moseCheckTree = mouseY > this.positionUnit2DNotification.getPosition2D().y;
    boolean moseCheckFore = mouseY < (this.positionUnit2DNotification.getPosition2D().y + this.positionUnit2DNotification.getSize2D().y);
    
    if (moseCheckOne && moseCheckTwo && moseCheckTree && moseCheckFore) {
      if (flag  &&  mousePressed) {
        flag = false;
        return(true);
      }
    }
    return(false);
  }

  void display() {
    if (checkMouseOver()  ||  ((millis()-birthTime) > (ttl*1000))) {
      removeMyNotification = this;
      return;
    }

    strokeWeight(2);
    stroke(0);
    fill(clr);
    float posX = this.positionUnit2DNotification.getPosition2D().x;
    float posY = this.positionUnit2DNotification.getPosition2D().y;
    float sizeX = this.positionUnit2DNotification.getSize2D().x;
    float sizeY = this.positionUnit2DNotification.getSize2D().y;
    rect(posX, posY, posX+sizeX, posY+sizeY, 5);
    textSize(height/60);
    textAlign(LEFT, TOP);
    fill(0);
    text(txt, posX + SIZE_GUTTER, posY + SIZE_GUTTER, posX + sizeX - 2*SIZE_GUTTER, posX + sizeY- 2*SIZE_GUTTER); //the last one schould be posY I think 
  }
}

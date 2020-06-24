/// @brief Class for all GUI text notifications
class Notification {
  int ttl;            // Time to live in seconds
  long birthTime;
  PVector offset;     // Position offset, added to temporary position before saving to pos
  PVector pos;       // Actual element pos, used for mouseover/displaying, set in draw()
  PVector size;
  color clr;
  String txt;

  Notification(String iTxt, color iClr, int iTtl) {
    txt = iTxt;
    clr = iClr;
    ttl = iTtl;
    birthTime = millis();
    offset = new PVector(0, 0);
    pos = new PVector(0, 0);
    size = new PVector(400, 70);
  }

  /// @brief Check if mouse is over notification or notification was clicked (dismissed)
  /// @return true if mouse was clicked inside notification's hitbox, else false
  boolean checkMouseOver() {
    if (mouseX > pos.x  &&  mouseX < (pos.x+size.x)  &&  mouseY > pos.y  &&  mouseY < (pos.y+size.y)) {
      if (flag  &&  mousePressed) {
        flag = false;
        return(true);
      }
    }
    return(false);
  }

  /// @brief Displays notification, handles mouse over/click, removes notification after TTL
  void display() {
    if (checkMouseOver()  ||  ((millis()-birthTime) > (ttl*1000))) {
      removeMyNotification = this;
      return;
    }

    strokeWeight(2);
    stroke(0);
    fill(clr);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, 5);
    textSize(height/60);
    textAlign(LEFT, TOP);
    fill(0);
    text(txt, pos.x+SIZE_GUTTER, pos.y+SIZE_GUTTER, pos.x+size.x-2*SIZE_GUTTER, pos.x+size.y-2*SIZE_GUTTER);
  }
}

class Button extends GuiObject {
  Button(PVector iPos, PVector iSize, String iPropName) {
    super(iPos, iSize, iPropName, 0.0/*initialVal*/);
  }

  void display() {
    if (checkMouseOver()) {
      if (propName.equals(">")) {
        if (menuState==0) {
          menuState = 1;
        } else if (menuState==2) {
          menuState = 3;
        }
      } else if (propName.equals("+")){
        fixtureList.add(new Fixture());
      }
    }
    noStroke();
    fill(clr);
    rect(pos.x, pos.y, pos.x+size.x, pos.y+size.y, size.y/10);
    fill(0);
    textSize(size.y/2);
    textAlign(CENTER, CENTER);
    text(propName, pos.x+size.x/2, pos.y+size.y/2);
  }
}

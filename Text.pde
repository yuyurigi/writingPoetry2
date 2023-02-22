class Text {
  float x, y; 
  int current;
  boolean bDraw, bLine;
  float eY, startY, goalY;
  float eX, startX, goalX, lineX;

  Text(float _x, float _y, int _current) {
    x = _x;
    y = _y;
    current = _current;
    bDraw = true;
    bLine = false;
  }

  void setBool(boolean _bDraw) {
    bDraw = _bDraw;
  }

  void setBoolLine(boolean _bLine) {
    bLine = _bLine;
  }

  void setEasing(float _startY, float _goalY) {
    eY = 0;
    startY = _startY;
    goalY = _goalY;
  }
  
  void setLineEasing() {
    eX = 0;
    startX = x;
    goalX = grp[current].getBottomRight().x + startX;
  }

  void display() {
    fill(255);
    noStroke();
    pushMatrix();
    translate(x, y);
    if (bDraw) {
      //現在のライン
      float splitPos = map(time%intervals[current], 0, intervals[current]-1, 0, 1);
      RShape[] splitShapes = grp[current].split(splitPos);
      RG.shape(splitShapes[0]);
    } else {
      //現在のラインより上のライン（文字を表示するだけ）
      RShape[] splitShapes = grp[current].split(1);
      RG.shape(splitShapes[0]);
    }
    popMatrix();
  }

  void move(float speed) {
    y = map(easeInOutBack(eY), 0, 1, startY, goalY);
    //y = map(easeOutCubic(eY), 0, 1, startY, goalY);
    eY += 1 / speed; //イージングのスピード（数値が小さいほど早い）
    if (eY > 1) {
      eY = 1;
    }
  }

  float getEY() {
    return eY;
  }
}

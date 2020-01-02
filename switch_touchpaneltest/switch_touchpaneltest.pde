LineLocus ll;

void setup() {
  //size(1280, 720);
  size(600, 340);
  frameRate(60);
  ll = new LineLocus();
  drawbg();
}

void draw() {
  if (mousePressed) {
    if (ll.linestart) {
      ll.linestart = false;
      ll.clearpoint();
    }
    drawbg();
    ll.drawline();
    drawpoint();
  } else {
    ll.linestart = true;
  }
}

void mouseReleased() {
  drawbg();
  ll.drawline();
}

class LineLocus {
  ArrayList<Integer> mx;
  ArrayList<Integer> my;
  boolean linestart;

  LineLocus() {
    mx = new ArrayList<Integer>(600);
    my = new ArrayList<Integer>(600);
    linestart = true;
  }

  void addpoint() {
    mx.add(mouseX);
    my.add(mouseY);
  }

  void drawline() {
    addpoint();
    strokeWeight(0.5);
    stroke(0);
    fill(0);
    int mxsize = mx.size();
    rect(mx.get(0)-1, my.get(0)-1, 2, 2);
    for (int i=0; i<mxsize-1; i++) {
      rect(mx.get(i+1)-1, my.get(i+1)-1, 2, 2);
      line(mx.get(i), my.get(i), mx.get(i+1), my.get(i+1));
    }
  }

  void clearpoint() {
    mx = new ArrayList<Integer>(600);
    my = new ArrayList<Integer>(600);
  }
}

void drawbg() {
  background(255);
  strokeWeight(1);
  stroke(192);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  line(0, 0, width, height);
  line(width, 0, 0, height);
  line(width/6, height/6, width*5/6, height/6);
  line(width/6, height/6, width/6, height*5/6);
  line(width*5/6, height/6, width*5/6, height*5/6);
  line(width/6, height*5/6, width*5/6, height*5/6);
}

void drawpoint() {
  int linelength = 120;
  strokeWeight(1);
  stroke(0, 0, 255);
  line(mouseX-linelength, mouseY, mouseX+linelength, mouseY);
  line(mouseX, mouseY-linelength, mouseX, mouseY+linelength);
  noFill();
  ellipse(mouseX, mouseY, 50, 50);
}

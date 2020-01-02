float start, dt; //<>//
float time;
float serial;
float buff;

void setup() {
  size(480, 480);
  frameRate(60);
  colorMode(HSB, 255, 100, 100);
  start = millis();
  time = 0;
  serial = 1;
  buff = 0;
}

void draw() {
  dt = millis() - start; //<>//
  start = millis();
  time = time + dt;
  centerCircle();
  aroundCircle(0, 70);
  aroundCircle(120, 140);
  aroundCircle(240, 210);
  serialBar();
  fade();
}

void centerCircle() {
  stroke(time/10%255, 100, 100);
  pushMatrix();
  translate(mouseX, mouseY);
  strokeWeight(5);
  rotate(-radians(time / 2 % 360));
  ellipse(30, 0, 40, 40);
  popMatrix();
}

void aroundCircle(float theta, int dcolor) {
  stroke((time/10+dcolor)%255, 100, 100);
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(-radians(time / 2 % 360));
  translate(30, 0);
  rotate(radians((buff + theta) % 360));
  buff = buff + (serial / 30 + 1);
  println(serial);
  strokeWeight(3);
  ellipse(70, 0, 10, 10);
  popMatrix();
}

void serialBar() {
  pushMatrix();
  stroke(0, 100, 100);
  line(width/8, (height/8)*7, (width/8)*7, (height/8)*7);
  ellipse(width/8, (height/8)*7, 20, 20);
  ellipse((width/8)*7, (height/8)*7, 20, 20);
  if (mousePressed) {
    if (mouseX < width/8) {
      ellipse(width/8, (height/8)*7, 40, 40);
      serial = 1.0;
    } else if ((width/8)*7 < mouseX) {
      ellipse((width/8)*7, (height/8)*7, 40, 40);
      serial = 255.0;
    } else {
      ellipse(mouseX, (height/8)*7, 40, 40);
      serial = map(mouseX, width/8, (width/8)*7, 1, 255);
    }
  }
  popMatrix();
}



void fade() {
  noStroke();
  fill(0, 30);
  rectMode(CENTER);
  rect(0, 0, width*2, height*2);
}

import processing.serial.*;

Serial myPort;

float start, dt;
float time;
float serial;
float buff;
final int serial_num = 4;
int val0, val1, val2, val3;

void setup() {
  size(480, 480);
  frameRate(60);
  colorMode(HSB, 255, 100, 100);
  myPort = new Serial(this, "COM5", 9600);
  start = millis();
  time = 0;
  serial = 1;
  buff = 0;
}

void draw() {
  dt = millis() - start;
  start = millis();
  time = time + dt;
  centerCircle();
  aroundCircle(0, 70);
  aroundCircle(120, 140);
  aroundCircle(240, 210);
  fade();
}

void serialEvent(Serial p) {
  serial = p.read();
  serial = map(serial, 0, 255, -120, 230);
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


void fade() {
  noStroke();
  fill(0, 30);
  rectMode(CENTER);
  rect(0, 0, width*2, height*2);
}

void SerialEvent(Serial p){
  if(myPort.available() >= serial_num){
    val0 = myPort.read();
    val1 = myPort.read();
    val2 = myPort.read();
    val3 = myPort.read();
    
    myPort.write(55);
  }
}

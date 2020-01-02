import processing.serial.*;

Serial myPort;

float a,b;
float degc,dega;
float ccx,ccy;
float rad;
float rot;
float start,t;
float se;

void setup() {
  size(480, 480);
  frameRate(60);
  myPort = new Serial(this,"COM3",9600);
  rot = PI*2/3;
  start = millis();
}

void draw() {
  t = millis() - start;
  centercircle();
  aroundcircle();
  fade();
}

void serialEvent(Serial p){
  se = p.read();
  println(se);
}

void centercircle(){
  a = abs(t/10%256);
  b = abs(t/10%40);
  degc = t/2%360;
  colorMode(HSB,255,100,100);
  stroke(a,100,100);
  strokeWeight(5);
  ccx = mouseX+cos(radians(degc))*50.0;
  ccy = mouseY+sin(radians(degc))*50.0;
  ellipse(ccx, ccy, 40, 40);
}

void aroundcircle(){
  dega = ((t/160)*se)%360;
  rad = radians(-dega);
  stroke(a,100,100);
  strokeWeight(3);
  ellipse(ccx+cos(rad)*70.0, ccy+sin(rad)*70.0, 10, 10);
  ellipse(ccx+cos(rad+rot)*70.0, ccy+sin(rad+rot)*70.0, 10, 10);
  ellipse(ccx+cos(rad-rot)*70.0, ccy+sin(rad-rot)*70.0, 10, 10);
}


void fade(){
  noStroke();
  fill(0,30);
  rectMode(CORNER);
  rect(0,0,width,height);
}

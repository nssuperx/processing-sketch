import processing.serial.*;

Serial myPort;

final int serial_num = 4;
int val0, val1, val2, val3;

void setup() {
  size(480, 480);
  frameRate(60);
  myPort = new Serial(this, "COM5", 9600);
}

void draw() {
  background(0);
  stroke(255);
  rect(0,0,val0,80);
  rect(0,height/4,val1,80);
  rect(0,height/4*2,val2,80);
  rect(0,height/4*3,val3,80);
  
}

void serialEvent(Serial p){
  if(myPort.available() >= serial_num){
    val0 = myPort.read();
    val1 = myPort.read();
    val2 = myPort.read();
    val3 = myPort.read();
    
    myPort.write(55);
  }
}

void mousePressed(){
  myPort.clear();
  myPort.write(55);
}

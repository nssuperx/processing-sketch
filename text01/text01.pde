PFont font;

int val;

void setup() {
  size(150, 150);
  frameRate(60);
  font = loadFont("SegoeUI-48.vlw");
}

void draw(){
  textFont(font,32);
  text(val,width/2,height/2);
}

void keyPressed(){
  background(0);
  val = key;
}

import processing.serial.*; //<>//

Serial myPort;
int val[] = new int[4];
final int UP_LEFT = 0;
final int UP_RIGHT = 1;
final int DOWN_LEFT = 2;
final int DOWN_RIGHT = 3;
final int CIRCLE_DIAMETER = 200;
final int SERIAL_MAX = 255;
float xshort, xlong, yshort, ylong;
float circle_size;
float max;

void setup() {
  size(480, 480);
  frameRate(60);
  myPort = new Serial(this, "COM3", 9600);
  max = dist(0, 0, width, height);
  xshort = width/8;
  xlong = width - xshort;
  yshort = height/8;
  ylong = height - yshort;
}

void draw() {
  background(0);
  stroke(255, 255, 0);
  strokeWeight(1);
  line(mouseX, 0, mouseX, height);
  line(0, mouseY, width, mouseY);
  val[UP_LEFT] = int(map(dist(0, 0, mouseX, mouseY), 0, max, 0, SERIAL_MAX));
  val[UP_RIGHT] = int(map(dist(width, 0, mouseX, mouseY), 0, max, 0, SERIAL_MAX));
  val[DOWN_LEFT] = SERIAL_MAX - val[UP_RIGHT];
  val[DOWN_RIGHT] = SERIAL_MAX - val[UP_LEFT];
  noFill();
  strokeWeight(3);
  circle_size = CIRCLE_DIAMETER - map(val[UP_LEFT], 0, SERIAL_MAX, 0, CIRCLE_DIAMETER);
  ellipse(xshort, yshort, circle_size, circle_size);
  circle_size = CIRCLE_DIAMETER - map(val[UP_RIGHT], 0, SERIAL_MAX, 0, CIRCLE_DIAMETER);
  ellipse(xlong, yshort, circle_size, circle_size);
  circle_size = CIRCLE_DIAMETER - map(val[DOWN_LEFT], 0, SERIAL_MAX, 0, CIRCLE_DIAMETER);
  ellipse(xshort, ylong, circle_size, circle_size);
  circle_size = CIRCLE_DIAMETER - map(val[DOWN_RIGHT], 0, SERIAL_MAX, 0, CIRCLE_DIAMETER);
  ellipse(xlong, ylong, circle_size, circle_size);

  myPort.write(val[3]);
  myPort.write(val[2]);
  myPort.write(val[1]);
  myPort.write(val[0]);
  myPort.write("\0");
}

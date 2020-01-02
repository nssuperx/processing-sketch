import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
 
Minim minim;
AudioPlayer player;
ParticleSystem ps;
Serial myPort;

FFT fft;

float buff[];
final float delay = 2.5;
final float wavegap = 5.0;
final int strokeweight = 3;
final int serial_num = 4;
float serial0, serial1, serial2, serial3;
int i;
 
void setup(){
 
  size(1024, 800);
  //fullScreen();
 
  minim = new Minim(this);
  player = minim.loadFile("../music/music2.mp3", 1024);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  buff = new float[int(fft.specSize()) + 1];
  player.play();
  frameRate(60);
  myPort = new Serial(this, "COM5", 9600);
  ps = new ParticleSystem(new PVector(width/2, 50));
  i = 0;
  blendMode(ADD);
}
 
void draw(){
  
  background(0);
  stroke(255);
  
  if (i % (int(serial0)/28 + 1) == 0)ps.addParticle();
  colorMode(RGB);
  ps.run();
  i++;
  
  colorMode(HSB,360,100,100,100);
  fft.forward(player.left);
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(strokeweight);
    float x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    float now = max((fft.getBand(i) * 8),buff[i]);
    line(x, height/2, x, height/2 - now);
    buff[i] = now - delay;
  }
  
  fft.forward(player.right);
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(strokeweight);
    float x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    float now = max((fft.getBand(i) * 8),buff[i]);
    line(x, height/2, x, height - (height/2 - now));
    buff[i] = now - delay;
  }
}

void mousePressed(){
  myPort.clear();
  myPort.write(55);
}

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  color col1, col2;
  float dr, dg, db;
  float BASE = 100.0;    //gradation speed
  int delta, direction;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
    //particles = new ArrayList();

    //setup gradation
    col1 = color(#80FF06);
    col2 = color(#FF6FFB);
    dr = (red(col2)-red(col1))/BASE;
    dg = (green(col2)-green(col1))/BASE;
    db = (blue(col2)-blue(col1))/BASE;
    delta = 0;
    direction = 1;
  }

  void addParticle() {
    //particles.add(new Particle(origin));
    color pc = color(
      (red(col1) + delta*dr), 
      (green(col1) + delta*dg), 
      (blue(col1) + delta*db)
      );
    particles.add(new Particle(new PVector(random(0, width), random(0, height)), pc, random(10, serial2/4 + 20)));
 
    if (delta > BASE) {
      direction = -1;
    } else if (delta < 0) {
      direction = 1;
    }
    delta = delta + direction;
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color valpc;
  float size;

  Particle(PVector l, color pc, float val) {
    //acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-serial3/20-0.3, serial3/20+0.3), random(-serial3/20-0.3, serial3/20+0.3));
    position = l.copy();
    lifespan = 255.0;
    valpc = pc;
    size = val;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    //velocity.add(acceleration);
    position.add(velocity);
    lifespan -= serial1/51.0 + 1.0;
  }

  // Method to display
  void display() {
    //stroke(valpc, lifespan);
    noStroke();
    fill(valpc, lifespan);
    ellipse(position.x, position.y, size, size);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

void stop(){
 
  player.close();
  minim.stop();
  super.stop();
}

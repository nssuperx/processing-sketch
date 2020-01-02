import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player;

FFT fft;

float buffleft[];
float buffright[];
final float delay = 5.0;
final float wavegap = 5.0;
final int sw = 2;            //strokeWeight
final int amplifier = 8;
 
void setup(){
 
  size(1280, 800);
  //fullScreen();
 
  minim = new Minim(this);
  player = minim.loadFile("../music/music3.mp3", 1024);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  buffleft = new float[int(fft.specSize()) + 1];
  buffright = new float[int(fft.specSize()) + 1];
  player.play();
  colorMode(HSB,360,100,100,100);
}
 
void draw(){
  
  background(0);
  translate(0,height/2);
  
  fft.forward(player.left);
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(sw);
    float x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    float now = max((fft.getBand(i) * amplifier),buffleft[i]);
    line(x, 0, x, -now);
    buffleft[i] = now - delay;
  }
  
  fft.forward(player.right);
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(sw);
    float x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    float now = max((fft.getBand(i) * amplifier),buffright[i]);
    line(x, 0, x, now);
    buffright[i] = now - delay;
  }
}
 
void stop(){
  player.close();
  minim.stop();
  super.stop();
}

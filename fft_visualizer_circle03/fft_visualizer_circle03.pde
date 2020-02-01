import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player;

FFT fft;

float buff[];
final float delay = 2.5;
final float wavegap = 5.0;

float i = 0;
 
void setup(){
 
  size(1024, 800);
  frameRate(60);
 
  minim = new Minim(this);
  player = minim.loadFile("../music/music12.mp3", 1024);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  buff = new float[int(fft.specSize()) + 1];
  player.play();
  colorMode(HSB,360,100,100,100);
}
 
void draw(){
  
  background(0);
  stroke(255);
  //pushMatrix();
  translate(width/2,height/2);
  
  fft.forward(player.mix);
  for(int i = 0; i < fft.specSize(); i++){
    pushMatrix();
    rotate(map(i,0,fft.specSize(),0,PI));
    translate(0,-150);
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(2);
    //float x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    //float now = max(min((fft.getBand(i) * 8),height/3),buff[i]);
    float now = max(20*(float)Math.log10(fft.getBand(i) * 16)*3,buff[i]);
    line(0, 0, 0, -now);
    buff[i] = now - delay;
    if(buff[i] < 0){
      buff[i] = 0;
    }
    popMatrix();
  }
  
  for(int i = 0; i < fft.specSize(); i++){
    pushMatrix();
    rotate(-map(i,0,fft.specSize(),0,PI));
    translate(0,-150);
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(2);
    //float x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    //float now = max(min((fft.getBand(i) * 8),height/3),buff[i]);
    float now = max(20*(float)Math.log10(fft.getBand(i) * 16)*3,buff[i]);
    line(0, 0, 0, -now);
    buff[i] = now - delay;
    if(buff[i] < 0){
      buff[i] = 0;
    }
    popMatrix();
  }
}
 
void stop(){
 
  player.close();
  minim.stop();
  super.stop();
}

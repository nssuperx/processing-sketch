import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player;

FFT fft;
 
void setup(){
 
  size(1024, 400);
 
  minim = new Minim(this);
  player = minim.loadFile("../music/music3.mp3", 1024);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  player.play();
  colorMode(HSB,360,100,100,100);
}
 
void draw(){
 
  background(0);
  stroke(255);
  
  fft.forward(player.mix);
  
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,360);
    stroke(h,100,100);
    strokeWeight(3);
    float x = map(i, 0, fft.specSize(), 0, width);
    line(x, height, x, height - fft.getBand(i) * 8);
  }
}
 
void stop(){
 
  player.close();
  minim.stop();
  super.stop();
}

import ddf.minim.*;
import ddf.minim.analysis.*;
int BUFSIZE = 512;
Minim minim;
AudioPlayer player;
FFT fft;
int waveH = 100;
 
void setup(){
 
  size(1024, 400);
 
  minim = new Minim(this);
  player = minim.loadFile("../music/music3.mp3", 512);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  player.play();
  colorMode(HSB,255,100,100,100);
  //noStroke();
}
 
void draw(){
 
  background(0);
  
  fft.forward(player.mix);
  
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,180);
    float a = map(fft.getBand(i),0,BUFSIZE/16,0,255);
    float x = map(i,0,fft.specSize(),width/2,0);
    float w = width / float(fft.specSize()) /2;
    fill(h,80,80,a);
    rect(x,0,w,height);
  }
  
  fft.forward(player.right);
  
  for(int i = 0; i < fft.specSize(); i++){
    float h = map(i,0,fft.specSize(),0,180);
    float a = map(fft.getBand(i),0,BUFSIZE/16,0,255);
    float x = map(i,0,fft.specSize(),width/2,width);
    float w = width / float(fft.specSize()) /2;
    fill(h,80,80,a);
    rect(x,0,w,height);
  }
  
}
 
void stop(){
 
  player.close();
  minim.stop();
  super.stop();
}

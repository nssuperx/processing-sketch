import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player;
//AudioInput player;

FFT fft;

SpectrumSystem ss;

final float decay = 1.25;
final float wavegap = 0.0;
final float sw = 1.5;           //strokeWeight
final int amplifier = 1;
final float baseY = height/32;
//logAverages parameters
final int minBandwidth = 300;
final int bandsPerOctave = 20;

void setup(){
  size(1200, 200);
  frameRate(60);
  //fullScreen();
  minim = new Minim(this);
  player = minim.loadFile("../music/music14.mp3",1024);
  //player = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  println(fft.specSize());
  println(fft.getBandWidth());
  //player.setGain(-20);
  fft.logAverages(minBandwidth,bandsPerOctave);
  //fft.linAverages(50);
  player.play();
  ss = new SpectrumSystem();
  for(int i = 0; i < fft.avgSize(); i++){
    ss.addSpectrum(i);
  }
  //colorMode(HSB,360,100,100,100);
}
 
void draw(){
  background(0);
  //translate(0,height/2);
  translate(0,height);
  fft.forward(player.mix);
  ss.run();
  //saveFrame("frames/######.tif");
}
 
void stop(){
  player.close();
  minim.stop();
  super.stop();
}

class SpectrumSystem {
  ArrayList<Spectrum> spectrums;
  
  SpectrumSystem(){
    spectrums = new ArrayList<Spectrum>();
  }
  
  void addSpectrum(int i){
    spectrums.add(new Spectrum(i));
  }
  
  void run(){
    for(int i = 0; i < spectrums.size(); i++){
      Spectrum s = spectrums.get(i);
      s.run(i);
    }
  }
}

class Spectrum {
  float col,x;
  float buffer,now;
  
  Spectrum(int i){
    //col = map(i,0,fft.avgSize(),0,360);
    col = 255;
    x = map((i + wavegap) % fft.avgSize(), 0, fft.avgSize(), 0, width/2);
    buffer = 0;
    now = 0;
  }
  
  void run(int i){
    //stroke(col,100,100);
    stroke(col);
    strokeWeight(sw);
    now = max((fft.getAvg(i) * amplifier),buffer);
    //now += 20 * (float)Math.log10(fft.getAvg(i) * amplifier);
    //now /= decay;
    if(now < baseY){
      now = baseY;
    }
    //line(x, 0, x, now);
    line(x, 0, x, -now);
    line(width-x, 0, width-x, -now);
    buffer = now / decay;
  }
}

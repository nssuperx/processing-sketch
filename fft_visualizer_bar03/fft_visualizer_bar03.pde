import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
//AudioInput player;

FFT fft;

SpectrumSystem ss;

final float decay = 1.15;
final float wavegap = 0.0;
final int sw = 2;            //strokeWeight
final int amplifier = 16;
final int select[] = {3, 30, 50, 100, 250};

void setup() {
  size(1280, 800);
  //fullScreen();
  minim = new Minim(this);
  player = minim.loadFile("../music/music12.mp3", 1024);
  //player = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  println(fft.specSize());
  println(fft.getBandWidth());
  player.setGain(-20);
  player.play();
  ss = new SpectrumSystem();
  for (int i = 0; i < fft.specSize(); i++) {
    ss.addSpectrum(i);
  }
  colorMode(HSB, 360, 100, 100, 100);
}

void draw() {
  background(0);
  translate(0, height/2);
  fft.forward(player.mix);
  ss.run();
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}

class SpectrumSystem {
  ArrayList<Spectrum> spectrums;
  //int maxIndex;

  SpectrumSystem() {
    spectrums = new ArrayList<Spectrum>();
  }

  void addSpectrum(int i) {
    spectrums.add(new Spectrum(i));
  }

  void run() {
    int maxIndex = 0;
    for (int i = 1; i < spectrums.size(); i++) {
      if (fft.getBand(maxIndex) < fft.getBand(i)) {
        maxIndex = i;
      }
    }
    Spectrum max = spectrums.get(maxIndex);
    max.setEnable();
    for (int i = 1; i < spectrums.size(); i++) {
      Spectrum s = spectrums.get(i);
      s.run();
    }


    /*
    for(int i: select){
     for(int j=0; j<3; j++){
     Spectrum s = spectrums.get(i+j);
     s.run();
     }
     }
     */
  }
}

class Spectrum {
  float col, x;
  float buffer, now;
  int bandIndex;
  boolean enable = false;

  Spectrum(int i) {
    bandIndex = i;
    col = map(i, 0, fft.specSize(), 0, 360);
    x = map((i + wavegap) % fft.specSize(), 0, fft.specSize(), 0, width);
    buffer = 0;
    now = 0;
  }

  void setEnable() {
    enable = true;
  }

  void run() {
    stroke(col, 100, 100);
    strokeWeight(sw);
    //now = max(20*(float)Math.log10(fft.getBand(i) * amplifier) * 5,buffer);
    if (enable) {
      now += 20*(float)Math.log10(fft.getBand(bandIndex) * amplifier);
    }
    now /= decay;
    if (now < 0) {
      now = 0;
    }
    line(x, 0, x, now);
    line(x, 0, x, -now);
    //buffer = now - decay;
    enable = false;
  }
}

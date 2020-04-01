import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
float highestAmp = 0,freq,frequency;
float amplitude;
FFT fft;
AudioInput in;
int[] frequencies;
String[] notes;

PImage background;
PImage scale;
PImage pointer;

int pixelsPerTooth = 9;

void setup() {
  size(500,200);
  // load data about note names and corresponding frequencies
  notes = loadStrings("notes.txt");
  frequencies = new int[notes.length];
  for (int i = 0; i < notes.length; i++) {
    String[] split = split(notes[i], "\t"); 
    notes[i] = split[0];
    frequencies[i] = int(split[1]);
  }
  
  // initialize Minim and catch the output
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 4096, 44100);
  fft = new FFT(in.left.size(), 44100);
  
  // load images
  background = loadImage("resources/background.png");
  background.resize(500,200);
  scale = loadImage("resources/scale.png");
  scale.resize(int(scale.width * 0.3), int(scale.height * 0.3));
  pointer = loadImage("resources/pointer.png");
  pointer.resize(int(pointer.width * 0.3), int(pointer.height * 0.3));
}

void draw() {
 
  highestAmp = 0;
  amplitude = 0;
  frequency = 0;
  fft.forward(in.left);

  // finding the frequency
  for(int i = 0; i < 20000; i++) {
    amplitude = fft.getFreq(i);
    if (amplitude > highestAmp){
       highestAmp = amplitude;
       frequency = i;
     }
   } 
   
   // finding the closest note
   int maxIdx = 0;
   for (int i = 0; i < notes.length; i++) {
     if (abs(frequency - frequencies[i]) < abs(frequency - frequencies[maxIdx])) {
       maxIdx = i;
     }
   }
   
   float difference = frequencies[maxIdx] - frequency;
   println(notes[maxIdx] + " " + frequency + ", difference: " + difference);
   
   background(background);
   image(scale,7,60);
   if (frequency > 50) {
     fill(0);
     textSize(30); 
     text(notes[maxIdx], width/2 - 10, 40);
     image(pointer,width/2 - pointer.width/2 + difference * pixelsPerTooth,100);
   } else {
     image(pointer,width/2 - pointer.width/2, 100);
   }
}

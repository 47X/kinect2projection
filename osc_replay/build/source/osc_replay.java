import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class osc_replay extends PApplet {

 



OscP5 oscP5;
NetAddress myRemoteLocation;

String[] simlines;

public void setup() {
  
  frameRate(25);

  //OSC
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12001);

  //load sim data into array
  simlines = loadStrings("capture.txt");
}


public void draw() {
  background(0);
  //load lines in loop one at a time
  String line = simlines[frameCount%simlines.length];
  //split into tokens
  String[] pieces = split(line, ' ');
  //cast from string to apropriate datatypes and send via osc
  fakeKinect(PApplet.parseInt(pieces[0]), PApplet.parseFloat(pieces[1]), PApplet.parseFloat(pieces[2]), PApplet.parseInt(pieces[3]));
}


public void fakeKinect(int id, float x, float y, int z){
  OscMessage myMessage = new OscMessage("/kinect");
  myMessage.add(id);
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);
  oscP5.send(myMessage, myRemoteLocation);
  //println(id+" " + x +" "+ y +" "+ z +" ");
}



public void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/kinect");

  myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
}
  public void settings() {  size(400,400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "osc_replay" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

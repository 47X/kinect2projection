 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

String[] simlines;

void setup() {
  size(400,400);
  frameRate(25);
  
  //OSC
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12001);

  //load sim data into array
  simlines = loadStrings("capture.txt");
}


void draw() {
  background(0);  
  //load lines in loop one at a time
  String line = simlines[frameCount%simlines.length];
  //split into tokens
  String[] pieces = split(line, ' ');
  //cast from string to apropriate datatypes and send via osc 
  fakeKinect(int(pieces[0]), float(pieces[1]), float(pieces[2]), int(pieces[3]));
}


void fakeKinect(int id, float x, float y, int z){
  OscMessage myMessage = new OscMessage("/kinect");
  myMessage.add(id);
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);
  oscP5.send(myMessage, myRemoteLocation); 
  //println(id+" " + x +" "+ y +" "+ z +" ");
}



void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/kinect");
  
  myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
}

//simulates body tracking for testing purposes
//reads mouse and sends as kinect person position
 
import codeanticode.tablet.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Tablet tablet;
float mouseWheel = 500;  

void setup() {
  size(640,480);
  frameRate(30);

  //OSC
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12001);

  //tablet
  tablet = new Tablet(this); 
  
}


void draw() {
  background(0);
  int x = mouseX;
  int y = mouseY;
  int d= max(20+int(mouseWheel),int(tablet.getPressure()*600));
  
  fill(250,50,50);
  ellipse(x, y, 600-d, 600-d);
  
  fill(255);
  String pos = str(x)+","+str(y)+","+str(d);
  text(pos, x, y);
  
  fakeKinect(1, float(x), y , d);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  mouseWheel+=(e*5);
  println(mouseWheel);
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

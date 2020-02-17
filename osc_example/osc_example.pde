import netP5.*;
import oscP5.*;

float xPos =0f;
float yPos =0f;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  // setting window width and height
  // note the values, we will calculate the data we will send based on these
  size(400,400);
  frameRate(25);

  //set up an OSC receiver
  oscP5 = new OscP5(this,7001);

  // set up the address and port of the host we are going to send to
  myRemoteLocation = new NetAddress("127.0.0.1",7000);

}

void draw(){
background(0);
 text("This small example will set layer 1 position X and Y",20,20);
 text(" based on where you move the mouse in this window.",20,40);
 text("mouse xPos : "+xPos+ "   yPos : "+yPos, 20,60);
 ellipse(mouseX,mouseY,7,7);
}

void mouseMoved() {
  //calculate the normalized OSC value based on window size, and mouse position
  xPos = (mouseX - (width / 2) + 16384) / 32768f ;
  yPos = (mouseY - (height /2) + 16384) / 32768f ;
  
  //uncomment the next 2 lines to calculate an absolute value based on mouse coordinates within the window
  //xPos = mouseX - (width / 2);
  //yPos = mouseY - (height /2);
  
  println("xPos : ",xPos, "   yPos : ",yPos);

  // we create a new OSC Bundle that we will send
  OscBundle myBundle = new OscBundle();
  
  // we create a new OSC message and set the OSC address we want to send to in one line
  OscMessage myMessage = new OscMessage("/composition/selectedclip/video/effects/transform/positionx");
  
  //We add "a" to the bundle to tell resolume we'll send an absolute value
   // myMessage.add("a");
  
  // we set add the position
  myMessage.add(xPos);
  
  // we add the message to the bundle we will send
  myBundle.add(myMessage);
  
  // we clear the osc message because we will reuse the variable
  myMessage.clear();
  
  // we set the OSC address here to layer position Y
  myMessage.setAddrPattern("/composition/selectedclip/video/effects/transform/positiony");
 
  //We add "a" to the bundle to tell resolume we'll send an absolute value
  //  myMessage.add("a");

  //we add the value we have for the Y position
  myMessage.add(yPos);
  
  // we add the message to the bundle we will send
  myBundle.add(myMessage);
  
  // finally we send the OSC bundle
  oscP5.send(myBundle, myRemoteLocation);
}

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  print(" typetag: "+theOscMessage.typetag());
  println(" timetag: "+theOscMessage.timetag());
}

void keyPressed(){
 
  OscBundle myBundle = new OscBundle();
  OscMessage myMessage = new OscMessage("/composition/selectedclip/video/effects/transform/positionx");
  myMessage.add("+");
  myMessage.add(10f);
  myBundle.add(myMessage);
  oscP5.send(myBundle, myRemoteLocation);

}

import oscP5.*;
import netP5.*;
//import spout.*;

OscP5 oscP5;
NetAddress  myRemoteLocation;
//Spout spout;

float xPos =0f;
float yPos =0f;

//PrintWriter output;

//float[] user1={0,0,0};
//float[] user2={0,0,0};

//PVector raw1 = new PVector(0,0,0);
//PVector raw2 = new PVector(0,0,0);

//easyVec3 user1 = new easyVec3();
//easyVec3 user2 = new easyVec3();

//boolean recording = false;

void setup() {
  size(400,400);
  frameRate(25);
  
  //oscP5 = new OscP5(this,"239.0.0.1",7001);
  oscP5 = new OscP5(this,7001);
  myRemoteLocation = new NetAddress("127.0.0.1",7000);
  //spout
 // spout = new Spout(this);
  //spout.createSender("Spout Processing");
  
  //output = createWriter("positions"+"_"+str(month())+"_"+str(day())+"_"+str(hour())+"_"+str(minute())+"_"+str(second())+".txt");
}


void draw() {
  //background(0);  
  //noStroke();
  
  //resoPos(mouseX, mouseY);
  
  //PVector prev1 = new PVector(raw1.x, raw1.y, raw1.z);
  
  //    if (raw1==prev1){user1.age++;}else{user1.age=0;};
  
  ////user1
  //fill(80,50,200, 100);
  //float[] real1 = toFloatSpace(int(raw1.x), int(raw1.y), int(raw1.z));
  ////ellipse(real1[0]*width, height-(real1[1]*height), 100,100);
  
  //fill(255);
  //String pos = "U1 age " +user1.age+" "+ nf(real1[0],1,2)+", "+nf(real1[1],1,2)+", "+nf(real1[2],1,2);
  ////text(pos, real1[0]*width, height-(real1[1]*height));
  
  //fill(250,50,0, 100);
  //real1 = toFloatSpace(int(raw1.x), int(raw1.y), int(raw1.z));
  //ellipse(user1.x*width, height-(user1.y*height), 100,100);
  
  
  ////user2 
  //fill(50,80,150,100);
  //float[] real2 = toFloatSpace(int(raw2.x), int(raw2.y), int(raw2.z));
  ////ellipse(real2[0]*width, height-(real2[1]*height), 100,100);
  
  //fill(255);
  //String pos2 = "U2 age " +user2.age+" "+nf(real2[0],1,2)+", "+nf(real2[1],1,2)+", "+nf(real2[2],1,2);
  ////text(pos2, real2[0]*width, height-(real2[1]*height));
  
  //fill(250,50,0, 100);
  //real2 = toFloatSpace(int(raw2.x), int(raw2.y), int(raw2.z));
  //ellipse(user2.x*width, height-(user2.y*height), 100,100);
  
  //stroke(255);
  //noFill();
  //float[] upperLeft = toFloatSpace(0,0,480);
  //float[] upperRight = toFloatSpace(640,0,480);
  //float[] lowerLeft = toFloatSpace(0,480,80);
  //float[] lowerRight = toFloatSpace(640,480,80);
  
  ////quad(lowerLeft[0]*width, height-(lowerLeft[1]*height), lowerRight[0]*width, height-(lowerRight[1]*height),  upperRight[0]*width, height-(upperRight[1]*height), upperLeft[0]*width, height-(upperLeft[1]*height));
  
  
  //user1.raw.set(real1[0],real1[2],real1[1]);
  ////user1.raw.set(raw1.x, raw1.z, raw1.y);
  //user2.raw.set(real2[0],real2[2],real2[1]);
  //user1.update();
  //user2.update();
  
  
  
  //if  (recording){
  //  fill(255,0,0);
  //  rect(10, 10, 50, 50);
  //  fill(255);
  //  text("REC", 20, 40);
  //}
  
 // spout.sendTexture();
  
}

//void mousePressed() { 
//  recording = !recording;
//}


///* incoming osc message are forwarded to the oscEvent method. */
//void oscEvent(OscMessage theOscMessage) {
//  //println(theOscMessage);
//  if(theOscMessage.checkAddrPattern("/userOn")==true) {
//    /* check if the typetag is the right one. */
//    if(theOscMessage.checkTypetag("iffi")) {
//      /* parse theOscMessage and extract the values from the osc message arguments. */
//      int id = theOscMessage.get(0).intValue();  
//      float x = theOscMessage.get(1).floatValue();
//      float y = theOscMessage.get(2).floatValue();
//      int z = theOscMessage.get(3).intValue();
//     // if (recording) {output.println(id + " "+x + " "+y + " "+z);};
//      if (id == 1 ){
//      PVector prev1 = new PVector(raw1.x, raw1.y, raw1.z);
//      raw1.set(x,y,z);
//      if (raw1==prev1){user1.age++;}else{user1.age=0;};
//      }
//      if (id > 1 ){
//      PVector prev2 = new PVector(raw2.x, raw2.y, raw2.z);
//      raw2.set(x,y,z);
//      if (raw2==prev2){user2.age++;}else{user2.age=0;};
//      }
//      println(" values: "+id+", "+x+", "+y+" "+z);
//      return;
//    }  
//  } 
  
//}

//void resoPos(int X, int Y){
//  OscBundle myBundle = new OscBundle();
//  OscMessage myMessage = new OscMessage("/composition/selectedclip/video/effects/transform/positionx");
//  myMessage.add((mouseX - (width / 2) + 16384) / 32768f);
//  myBundle.add(myMessage);
//  myMessage.clear();
//  myMessage.setAddrPattern("/composition/selectedclip/video/effects/transform/positiony");
//  myMessage.add((mouseY - (height /2) + 16384) / 32768f);
//  myBundle.add(myMessage);
//  oscP5.send(myBundle,  myRemoteLocation);
//}

//float resoNorm(int X, int max){  
//  return (X - (max / 2) + 16384) / 32768f  ;
//}

//void mouseMoved() {
//   xPos = (mouseX - (width / 2) + 16384) / 32768f ;
//   yPos = (mouseY - (height /2) + 16384) / 32768f ;
//  println("xPos : ",xPos, "   yPos : ",yPos);
//  OscBundle myBundle = new OscBundle();
//  OscMessage myMessage = new OscMessage("/composition/selectedclip/video/effects/transform/positionx");
//  myMessage.add(xPos);
//  myBundle.add(myMessage);
//  myMessage.clear();
//  myMessage.setAddrPattern("/composition/selectedclip/video/effects/transform/positiony");
//  myMessage.add(yPos);
//  myBundle.add(myMessage);
//  oscP5.send(myBundle, resoOSC);
//}
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
  oscP5.send(myBundle,  myRemoteLocation);
}

//void stop(){
//  output.flush(); // Write the remaining data
//  output.close(); // Finish the file
//  //exit(); // Stop the program
//}

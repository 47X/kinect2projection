import oscP5.*;
import netP5.*;
import spout.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Spout spout;

PrintWriter output;

//float[] user1={0,0,0};
//float[] user2={0,0,0};

PVector raw1 = new PVector(0,0,0);
PVector raw2 = new PVector(0,0,0);

easyVec3 user1 = new easyVec3();
easyVec3 user2 = new easyVec3();

boolean recording = false;

void setup() {
  size(1280,800, P3D);
  frameRate(30);
  
  oscP5 = new OscP5(this,"239.0.0.1",6666);
  //spout
  spout = new Spout(this);
  spout.createSender("Spout Processing");
  
  output = createWriter("positions"+"_"+str(month())+"_"+str(day())+"_"+str(hour())+"_"+str(minute())+"_"+str(second())+".txt");
}


void draw() {
  background(0);  
  noStroke();
  
  PVector prev1 = new PVector(raw1.x, raw1.y, raw1.z);
  
      if (raw1==prev1){user1.age++;}else{user1.age=0;};
  
  //user1
  fill(80,50,200, 100);
  float[] real1 = toFloatSpace(int(raw1.x), int(raw1.y), int(raw1.z));
  //ellipse(real1[0]*width, height-(real1[1]*height), 100,100);
  
  fill(255);
  String pos = "U1 age " +user1.age+" "+ nf(real1[0],1,2)+", "+nf(real1[1],1,2)+", "+nf(real1[2],1,2);
  //text(pos, real1[0]*width, height-(real1[1]*height));
  
  fill(250,50,0, 100);
  real1 = toFloatSpace(int(raw1.x), int(raw1.y), int(raw1.z));
  ellipse(user1.x*width, height-(user1.y*height), 100,100);
  
  
  //user2 
  fill(50,80,150,100);
  float[] real2 = toFloatSpace(int(raw2.x), int(raw2.y), int(raw2.z));
  //ellipse(real2[0]*width, height-(real2[1]*height), 100,100);
  
  fill(255);
  String pos2 = "U2 age " +user2.age+" "+nf(real2[0],1,2)+", "+nf(real2[1],1,2)+", "+nf(real2[2],1,2);
  //text(pos2, real2[0]*width, height-(real2[1]*height));
  
  fill(250,50,0, 100);
  real2 = toFloatSpace(int(raw2.x), int(raw2.y), int(raw2.z));
  ellipse(user2.x*width, height-(user2.y*height), 100,100);
  
  stroke(255);
  noFill();
  float[] upperLeft = toFloatSpace(0,0,480);
  float[] upperRight = toFloatSpace(640,0,480);
  float[] lowerLeft = toFloatSpace(0,480,80);
  float[] lowerRight = toFloatSpace(640,480,80);
  quad(upperLeft[0], upperLeft[1], upperRight[0], upperRight[1], lowerLeft[0], lowerLeft[1], lowerRight[0], lowerRight[1]);
  
  
  user1.raw.set(real1[0],real1[2],real1[1]);
  user2.raw.set(real2[0],real2[2],real2[1]);
  user1.update();
  user2.update();
  
  
  
  if  (recording){
    fill(255,0,0);
    rect(10, 10, 50, 50);
    fill(255);
    text("REC", 20, 40);
  }
  
  spout.sendTexture();
}

void mousePressed() { 
  recording = !recording;
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage);
  if(theOscMessage.checkAddrPattern("/userOn")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("iffi")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int id = theOscMessage.get(0).intValue();  
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      int z = theOscMessage.get(3).intValue();
      if (recording) {output.println(id + " "+x + " "+y + " "+z);};
      if (id == 1 ){
      PVector prev1 = new PVector(raw1.x, raw1.y, raw1.z);
      raw1.set(x,y,z);
      if (raw1==prev1){user1.age++;}else{user1.age=0;};
      }
      if (id > 1 ){
      PVector prev2 = new PVector(raw2.x, raw2.y, raw2.z);
      raw2.set(x,y,z);
      if (raw2==prev2){user2.age++;}else{user2.age=0;};
      }
      println(" values: "+id+", "+x+", "+y+" "+z);
      return;
    }  
  } 
  
}


void stop(){
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  //exit(); // Stop the program
}

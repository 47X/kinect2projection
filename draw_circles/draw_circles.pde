import oscP5.*;
import netP5.*;
import spout.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Spout spout;

float[] user1={0,0,0};
float[] user2={0,0,0};

void setup() {
  size(1280,800, P3D);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12001);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  //spout
  spout = new Spout(this);
  spout.createSender("Spout Processing");
}


void draw() {
  background(0);  
  //fill(250,50,50);
  //ellipse(user1[0], user1[2], user1[1], user1[1]);
  //fill(50,50,250);
  //ellipse(user2[0], user2[2], user2[1], user2[1]);
  
  fill(80,50,200);
  float[] real1 = toFloatSpace(int(user1[0]), int(user1[1]), int(user1[2]));
  ellipse(real1[0]*width, real1[1]*height, 100,100);
  
  fill(255);
  String pos = nf(real1[0],1,2)+", "+nf(real1[1],1,2)+", "+nf(real1[2],1,2);
  text(pos, real1[0]*width, real1[1]*height);
  
  fill(50,80,150);
  float[] real2 = toFloatSpace(int(user2[0]), int(user2[1]), int(user2[2]));
  ellipse(real2[0]*width, real2[1]*height, 100,100);
  
  fill(255);
  String pos2 = nf(real2[0],1,2)+", "+nf(real2[1],1,2)+", "+nf(real2[2],1,2);
  text(pos2, real2[0]*width, real2[1]*height);
  
  spout.sendTexture();
}

void mousePressed() { 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/kinect")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("iffi")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int id = theOscMessage.get(0).intValue();  
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      int z = theOscMessage.get(3).intValue();
      if (id == 1 ){
      user1[0]=x;
      user1[1]=y;
      user1[2]=z;
      }
      if (id == 2 ){
      user2[0]=x;
      user2[1]=y;
      user2[2]=z;
      }
      println(" values: "+id+", "+x+", "+y+" "+z);
      return;
    }  
  } 
  
}

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float[] user1={0,0,0};
float[] user2={0,0,0};

void setup() {
  size(1280,800);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12001);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}


void draw() {
  background(0);  
  fill(250,50,50);
  ellipse(user1[0], user1[2], user1[1], user1[1]);
  fill(50,50,250);
  ellipse(user2[0], user2[2], user2[1], user2[1]);

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

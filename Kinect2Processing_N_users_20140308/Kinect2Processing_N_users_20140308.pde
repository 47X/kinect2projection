// OSC
//    /userOn   id x y dist
//    /userOff  id
//    /userLost id

import oscP5.*;
import netP5.*;
import SimpleOpenNI.*; 

static final int BROADCAST_PORT = 6666;
static final int RECEIVE_PORT   = 6665;


OscP5 oscP5;
NetAddress remoteNet;
SimpleOpenNI kinect;
int userID; 
int USERS_MAX = 30;
int[] userOnFlag = new int[USERS_MAX];

// boolean tracking = false;


void setup() { 
  size(640, 480);
  frameRate (10); 

  initOSC();
  kinect = new SimpleOpenNI(this);

  kinect.enableDepth();   
  kinect.enableUser(); // NI2.0
  fill(255, 0, 0);
  
  for (int i=0; i<USERS_MAX; i++) { 
    userOnFlag [i] = 0;
  }

}

void draw() { 
  background(0); 
  kinect.update();
   
  image(kinect.depthImage(), 0, 0); 
  int[] depthValues = kinect.depthMap();  
  IntVector userList = new IntVector(); 
  kinect.getUsers(userList);
  
  for (int i=0; i<userList.size(); i++) { 
    int userId = userList.get(i);
    PVector position = new PVector();
   
    kinect.getCoM(userId, position);
    kinect.convertRealWorldToProjective(position, position); 
    int depthPosition = (int)(depthValues [(int)position.x + ((int) position.y * 640)] / 10.); //cm
  
    if (position.x > 0 ){
      userOnFlag [userId] = 1;  
      OscMessage myMessage = new OscMessage("/userOn");
      myMessage.add(userId);    
      myMessage.add(position.x);
      myMessage.add(position.y);
      myMessage.add(depthPosition); 
      oscP5.send(myMessage); 
    } else if (userOnFlag [userId] > 0) {
      userOnFlag [userId] = 0;  
      OscMessage myMessage = new OscMessage("/userOff");
      myMessage.add(userId);           
      oscP5.send(myMessage); 
    }     

    textSize(40); 
    text(userId + "-" + depthPosition, position.x, position.y);
    } 
}

void onNewUser(SimpleOpenNI curContext, int uID) {
//  tracking = true;
  println("tracking" + uID);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  OscMessage myMessage = new OscMessage("/userLost");
  myMessage.add(userId);            
  oscP5.send(myMessage); 
}

public void toKinect (int theA) {
  println("### received a message /toKinect.");
  println(" 1 int received: "+theA);  
}

void initOSC() {
  String ip           = "127.0.0.1";      // local
//  String ip           = "10.0.130.133";  //UMs008
//  String ip           = "10.0.132.1";    //UMs008
 
  int    brodcastPort = BROADCAST_PORT;
  int    receivePort  = RECEIVE_PORT;
  
  OscProperties properties = new OscProperties();
  properties.setRemoteAddress(ip, brodcastPort);
  properties.setListeningPort(receivePort);
  oscP5 = new OscP5(this, properties);
  oscP5.plug(this, "toKinect", "/toKinect");
}

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import spout.*; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class draw_circles4 extends PApplet {





OscP5 oscP5, oscP5reso;
NetAddress resoOSC;
Spout spout;

//resolume layer numbers
int layerU1 = 5;
int layerU2 = 4;

float xPos =0f;
float yPos =0f;

PrintWriter output;

//float[] user1={0,0,0};
//float[] user2={0,0,0};

PVector raw1 = new PVector(0,0,0);
PVector raw2 = new PVector(0,0,0);

easyVec3 user1 = new easyVec3();
easyVec3 user2 = new easyVec3();

boolean recording = false;
boolean debugText = true;


public void setup() {
  
  frameRate(30);

  oscP5 = new OscP5(this,"239.0.0.1", 6666); //multicast
  oscP5reso = new OscP5(this, 5555); //local
  resoOSC = new NetAddress("127.0.0.1",7000);
  //spout
 spout = new Spout(this);
 spout.createSender("Spout Processing");

  output = createWriter("positions"+"_"+str(month())+"_"+str(day())+"_"+str(hour())+"_"+str(minute())+"_"+str(second())+".txt");
}


public void draw() {
  background(0);
  noStroke();


  //user1

  if(debugText){
  fill(80,50,200, 100);
  float[] real1 = toFloatSpace(PApplet.parseInt(raw1.x), PApplet.parseInt(raw1.y), PApplet.parseInt(raw1.z));
  ellipse(real1[0]*width, height-(real1[1]*height), 50,50);

  fill(255);
  String pos = "U1 age " +user1.age+" "+ nf(real1[0],1,2)+", "+nf(real1[1],1,2)+", "+nf(real1[2],1,2);
  text(pos, real1[0]*width, height-(real1[1]*height));
  }

  fill(50,50,250, 100-(user1.age));
  float[] real1 = toFloatSpace(PApplet.parseInt(raw1.x), PApplet.parseInt(raw1.y), PApplet.parseInt(raw1.z));
  ellipse(user1.x*width, height-(user1.y*height), 100,100);
  resoPosF(resoNorm(PApplet.parseInt(user1.x*width), width), resoNorm(PApplet.parseInt(height-(user1.y*height)), height),user1.age, layerU1);
  resoPosF(resoNorm(PApplet.parseInt(user1.x*width), width), 0.5f,user1.age, 7);

  //user2
  if(debugText){
  fill(50,80,150,100);
  float[] real2 = toFloatSpace(PApplet.parseInt(raw2.x), PApplet.parseInt(raw2.y), PApplet.parseInt(raw2.z));
  ellipse(real2[0]*width, height-(real2[1]*height), 50,50);

  fill(255);
  String pos2 = "U2 age " +user2.age+" "+nf(real2[0],1,2)+", "+nf(real2[1],1,2)+", "+nf(real2[2],1,2);
  text(pos2, real2[0]*width, height-(real2[1]*height));
  }

  fill(250,50,0, 100-(user2.age));
  float[] real2 = toFloatSpace(PApplet.parseInt(raw2.x), PApplet.parseInt(raw2.y), PApplet.parseInt(raw2.z));
  ellipse(user2.x*width, height-(user2.y*height), 100,100);
  resoPosF(resoNorm(PApplet.parseInt(user2.x*width), width), resoNorm(PApplet.parseInt(height-(user2.y*height)), height),user2.age, layerU2);


  stroke(255);
  noFill();
  float[] upperLeft = toFloatSpace(0,0,480);
  float[] upperRight = toFloatSpace(640,0,480);
  float[] lowerLeft = toFloatSpace(0,480,80);
  float[] lowerRight = toFloatSpace(640,480,80);

  //quad(lowerLeft[0]*width, height-(lowerLeft[1]*height), lowerRight[0]*width, height-(lowerRight[1]*height),  upperRight[0]*width, height-(upperRight[1]*height), upperLeft[0]*width, height-(upperLeft[1]*height));


  user1.raw.set(real1[0],real1[2],real1[1]);
  //user1.raw.set(raw1.x, raw1.z, raw1.y);
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
 if(debugText){println("U1 age: "+ user1.age+ ", U2 age: "+user2.age);};
}

public void nothing(){
}


/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
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


public void resoPosF(float X, float Y, float opacity,int layer){
  OscBundle myBundle = new OscBundle();
  //OscMessage myMessage = new OscMessage("/composition/layers/"+layer+"/clips/1/video/effects/transform/positionx");
  OscMessage myMessage = new OscMessage("/composition/layers/"+layer+"/clips/1/video/effects/transform/positionx");
  myMessage.add(X);
  myBundle.add(myMessage);
  myMessage.clear();
  myMessage.setAddrPattern("/composition/layers/"+layer+"/clips/1/video/effects/transform/positiony");
  myMessage.add(Y);
  myBundle.add(myMessage);
  myMessage.clear();
  myMessage.setAddrPattern("/composition/layers/"+layer+"/video/opacity");
  myMessage.add(1-(opacity/1025));
  myBundle.add(myMessage);
  oscP5reso.send(myBundle, resoOSC);
  ///composition/layers/5/video/opacity
}

public float resoNorm(int X, int max){
  return (X - (max / 2) + 16384) / 32768f  ;
}

public void keyPressed(){
   switch(key){
     case 't':
       debugText = !debugText;
       break;
     case 'r':
       recording = !recording;
       break;
   }

}

//void mouseMoved() {

//}


public void stop(){
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  //exit(); // Stop the program
}


class easyVec3{
  PVector easy = new PVector(0,0,0);
  PVector raw = new PVector(0,0,0);
  PVector prev = new PVector(0,0,0);
  float x, y, z;
  float easing = 0.15f;
  int aging = 25;
  
  int age = 0;
  
  private int index = 0;
  private float[] hist = {0,0,0};
  
  //ArrayList<PVector> hist = new ArrayList<PVector>(); 
  
  easyVec3(){
  }
  
  public void update(){
    //calc easing
    PVector d = PVector.sub(raw, easy);
    d.mult(easing);
    easy = PVector.add(easy ,d); 
    x = easy.x;
    y = easy.y;
    y = easy.z;
    
    
        
    ////fill history and trim it
    hist[index] = raw.x;
    index = (index+1)%3;
    
    //calc hist avg
    float sum = 0;
    for(int i = 0; i < hist.length; i ++){
      sum = sum + hist[i];
    } 
    
    
    if(sum/hist.length==raw.x){
      if (age<1024){
      age = age + aging;
      }
      //println("Age is: "+ age);
    } else {
      age = age - aging;
    }
    
    if (age<0){
      age =0;
    }
    
    ////fill history and trim it
    //hist.add(raw);
    //if (hist.size() > 5) {
    //  hist.remove(0);
    //}
    //PVector oldpos = hist.get(hist.size()-1);
    ////PVector old2pos = hist.get(2);
    ////PVector old3pos = hist.get(1);
    ////println(hist);
    
    ////increase age if position stalled
    //if(hist.size()>3 && oldpos.x==raw.x){
    //  age ++;
    //  //println("Age is: "+ age);
    //} else {
    //  age = 0;
    //}
  
    //hist.trimToSize();
  }
  

}//endclass
//maps sensorspace values to worldspace values, for horizontal only, passes vertival as is
//
//assuming kinect v1 horizontal fov of 57deg tan(57/2)=0,5429556996
//maps to 0-1


public float[] toFloatSpace(int x, int y, int z){
  
  //tangens of horizontal fov bisecting angle
  final float htan = 0.5429556996f;
  
  //normalize input assuming input data is in pixels for x and y, centimeters for z
  float h = norm(x, 0, 640);
  float v = norm(y, 0, 480);
  float d = norm(z, 0, 460); //max real distance on stage
 
  //calculates max x at given distance
  //float maxX = d* htan;
  float maxX = 0.5f;
  
  float firstXpoint = 0.5f - maxX;
  float lastXpoint = 0.5f +maxX;
  float positionX = map(h,0,1,firstXpoint, lastXpoint);
  
  //return
  float[] ret = {0,0,0};
  ret[0]=positionX;
  ret[1]=d;
  ret[2]=v;
  return ret; 
}
  public void settings() {  size(1280 , 800, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "draw_circles4" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

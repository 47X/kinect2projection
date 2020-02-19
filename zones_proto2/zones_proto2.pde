int currentSceneIndex = 0; //current scene
boolean zonesEditingMode = false;
int selectedZone=0;

int stageSetupMode = 0; //0 false,  1 minXY, 2 maxXY, 3 angle

Scenes data;
String zonesFile = "testdata.txt";
String stageSetupFile = "stagesetupdata.txt";

import oscP5.*;
import netP5.*;
import spout.*;

OscP5 oscP5, oscP5reso;
NetAddress resoOSCaddr;
Spout spout;

PVector raw1 = new PVector(0,0,0);
PVector raw2 = new PVector(0,0,0);

easyVec3 user1 = new easyVec3();
easyVec3 user2 = new easyVec3();

boolean debugText = true;

//resolume layer numbers
int layerU1 = 5;
int layerU2 = 4;


void setup(){
        size(1280, 800, P3D);
        frameRate(30);

        oscP5 = new OscP5(this,"239.0.0.1", 6666); //multicast
        oscP5reso = new OscP5(this, 5555); //local
        resoOSCaddr = new NetAddress("127.0.0.1",7000);
        //spout
        spout = new Spout(this);
        spout.createSender("Spout Processing");

        data = new Scenes();
        data.loadSetupFromFile(stageSetupFile);
        data.loadZonesFromFile(zonesFile);

}

void draw(){
        clear();
        float u1x = float(mouseX);
        float u1y = float(mouseY);
        float u2x = float(mouseY);
        float u2y = float(mouseX);
        fill(255,60,60,60);
        ellipse(u1x, u1y, 10, 10);
        fill(60,255,60,60);
        ellipse(u2x, u2y, 10, 10);

        data.updateZones(currentSceneIndex);
        data.interactZones(currentSceneIndex, u1x, u1y, u2x, u2y);
        data.oscZones(currentSceneIndex, false);

        if(zonesEditingMode) {
                fill(255);
                text("editing scene number "+(currentSceneIndex+1) +" index "+ currentSceneIndex, 20, 20);
                text(" numbers to select, arrows to move, =/- to resize, a to de/activate, ,. to change reso layer", 20,40);
        }

        if(stageSetupMode>0){
          fill(255);
          text("Stage setup mode:", 20, 20);
          switch(stageSetupMode){
            case 1:
            text("min X and Y, use arrows, minX: "+str(data.minX)+" minY: "+str(data.minY), 20, 40);
            break;
            case 2:
            text("max X and Y, use arrows, maxX: "+str(data.maxX)+" maxY: " +str(data.maxY) , 20, 40);
            break;
            case 3:
            text("angle, arrows: "+str(data.angle), 20, 40);
            break;
          }
        }


                //user1

                if(debugText) {
                        fill(80,50,200, 100);
                        float[] real1 = toFloatSpace(int(raw1.x), int(raw1.y), int(raw1.z));
                        ellipse(real1[0]*width, height-(real1[1]*height), 50,50);

                        fill(255);
                        String pos = "U1 age " +user1.age+" "+ nf(real1[0],1,2)+", "+nf(real1[1],1,2)+", "+nf(real1[2],1,2);
                        text(pos, real1[0]*width, height-(real1[1]*height));
                }

                fill(50,50,250, 100-(user1.age));
                float[] real1 = toFloatSpace(int(raw1.x), int(raw1.y), int(raw1.z));
                ellipse(user1.x*width, height-(user1.y*height), 100,100);
                resoPosF(resoNorm(int(user1.x*width), width), resoNorm(int(height-(user1.y*height)), height),user1.age, layerU1);
                resoPosF(resoNorm(int(user1.x*width), width), 0.5,user1.age, 7);

                //user2
                if(debugText) {
                        fill(50,80,150,100);
                        float[] real2 = toFloatSpace(int(raw2.x), int(raw2.y), int(raw2.z));
                        ellipse(real2[0]*width, height-(real2[1]*height), 50,50);

                        fill(255);
                        String pos2 = "U2 age " +user2.age+" "+nf(real2[0],1,2)+", "+nf(real2[1],1,2)+", "+nf(real2[2],1,2);
                        text(pos2, real2[0]*width, height-(real2[1]*height));
                }

                fill(250,50,0, 100-(user2.age));
                float[] real2 = toFloatSpace(int(raw2.x), int(raw2.y), int(raw2.z));
                ellipse(user2.x*width, height-(user2.y*height), 100,100);
                resoPosF(resoNorm(int(user2.x*width), width), resoNorm(int(height-(user2.y*height)), height),user2.age, layerU2);


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




                spout.sendTexture();
                if(debugText) {println("U1 age: "+ user1.age+ ", U2 age: "+user2.age);};


};


void keyPressed(){
        switch(key) {
        case 'z':
                zonesEditingMode = !zonesEditingMode;
                println("Zones editing mode togle");
                break;
        case 's':
                println("Saving data to file...");
                data.saveZonesToFile(zonesFile);
                break;
        case 'l':
                println("Loading data from file...");
                data.loadZonesFromFile(zonesFile);
                //data.oscZones(currentSceneIndex, true);
                break;
        case 'p':
                println("stage setup mode "+stageSetupMode);
                stageSetupMode = (stageSetupMode+1)%4;
                break;
        case 't':
                debugText = !debugText;
                break;

        // case '=':
        //         data.angle+=0.05;
        //         println("angle:"+data.angle);
        //         data.oscZones(currentSceneIndex, true);
        //         break;
        // case '-':
        //         data.angle-=0.05;
        //         println("angle:"+data.angle);
        //         data.oscZones(currentSceneIndex, true);
        //         break;
        }

///Zones editing mode / scene switching
        if(zonesEditingMode) {

                //switch zones editing flag
                if(key>='1' & key<='9') {
                        int num=min(int(str(key))-1, data.zones[currentSceneIndex].length-1);
                        data.zones[currentSceneIndex][num].editing = !data.zones[currentSceneIndex][num].editing;
                        selectedZone=num;
                        println("toggle edit for zone index "+num);
                }
                //arrows
                if(key == CODED) {
                        //println("code: "+ keyCode);
                        switch(keyCode) {
                        case UP:
                                data.zones[currentSceneIndex][selectedZone].y--;
                                break;
                        case DOWN:
                                data.zones[currentSceneIndex][selectedZone].y++;
                                break;
                        case RIGHT:
                                data.zones[currentSceneIndex][selectedZone].x++;
                                break;
                        case LEFT:
                                data.zones[currentSceneIndex][selectedZone].x--;
                                break;
                        }
                } else {
                        //noncoded
                        switch(key) {
                        case '-':
                                data.zones[currentSceneIndex][selectedZone].d--;
                                break;
                        case '=':
                                data.zones[currentSceneIndex][selectedZone].d++;
                                break;
                        case ',':
                                data.zones[currentSceneIndex][selectedZone].layer--;
                                break;
                        case '.':
                                data.zones[currentSceneIndex][selectedZone].layer++;
                                break;
                        case 'a':
                                data.zones[currentSceneIndex][selectedZone].active = !data.zones[currentSceneIndex][selectedZone].active;
                                break;
                        }
                }



        } else {
                if(key>='1' & key<='9') {
                        int num=int(str(key))-1;
                        currentSceneIndex = min(num, data.zones.length-1);
                        println("Switching to scene index "+num);
                        //data.oscZones(currentSceneIndex, true);
                }
        }

        if(stageSetupMode>0){
          switch(stageSetupMode){
            case 1:
            switch(keyCode){
                case UP:
                  data.minY+=1;
                break;
                case DOWN:
                  data.minY-=1;
                break;
                case RIGHT:
                  data.minX+=1;
                break;
                case LEFT:
                  data.minX-=1;
                break;
              }
            break;

            case 2:
            switch(keyCode){
                case UP:
                  data.maxY+=1;
                break;
                case DOWN:
                  data.maxY-=1;
                break;
                case RIGHT:
                  data.maxX+=1;
                break;
                case LEFT:
                  data.maxX-=1;
                break;
              }
            break;

            case 3:
            switch(keyCode){
                case UP:
                  data.angle+=0.01;
                break;
                case DOWN:
                  data.angle-=0.01;
                break;
                case RIGHT:
                //  data.minX+=0.05;
                break;
                case LEFT:
                //  data.minX-=0.05;
                break;
              }
            break;

          }

        }



///END zones editing mode / scene switching

        //println("char: "+ key+" int: "+ int(key)+" str: "+str(key));

        // //arrows
        // if(key == CODED){
        //   println("code: "+ keyCode);
        //   switch(keyCode){
        //     case UP:
        //       println("UP");
        //     break;
        //     case DOWN:
        //       println("DOWN");
        //     break;
        //     case RIGHT:
        //       println("DOWN");
        //     break;
        //     case LEFT:
        //       println("DOWN");
        //     break;
        //   }
        // }

data.oscZones(currentSceneIndex, true);
}

void mouseDragged(){
  if(zonesEditingMode){
    data.zones[currentSceneIndex][selectedZone].x = mouseX;
    data.zones[currentSceneIndex][selectedZone].y = mouseY;
  }
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

                        if (id == 1 ) {
                                PVector prev1 = new PVector(raw1.x, raw1.y, raw1.z);
                                raw1.set(x,y,z);
                                if (raw1==prev1) {user1.age++;}else{user1.age=0;};
                        }
                        if (id > 1 ) {
                                PVector prev2 = new PVector(raw2.x, raw2.y, raw2.z);
                                raw2.set(x,y,z);
                                if (raw2==prev2) {user2.age++;}else{user2.age=0;};
                        }
                        //println(" values: "+id+", "+x+", "+y+" "+z);
                        return;
                }
        }

}


void resoPosF(float X, float Y, float opacity,int layer){
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
        oscP5reso.send(myBundle, resoOSCaddr);
        ///composition/layers/5/video/opacity
}

float resoNorm(int X, int max){
        return (X - (max / 2) + 16384) / 32768f;
}



void exit(){
  data.saveSetupToFile(stageSetupFile);
  println("saved setup, exitig..");
  super.exit();
}

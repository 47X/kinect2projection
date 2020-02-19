//class to hold all zones data and serialization etc

import oscP5.*;
import netP5.*;

class Scenes {

public Zone[][] zones = new Zone[9][9];

float minX, minY, maxX, maxY, angle;

OscP5 oscP5ResoZones;
NetAddress resoAddress = new NetAddress("127.0.0.1",7000);

Scenes(){
        for(int j = 0; j<zones.length; j++) {
                for(int i = 0; i<zones[j].length; i++) {
                        zones[j][i] = new Zone((i+1)*80, (j+1)*80, (i+1)*(j+1)*10, (j*10)+i, i+2);
                }
        }
        oscP5ResoZones = new OscP5(this, 7777);
        angle = 0;
        minX = 0;
        minY =0;
        maxX=1280;
        maxY=800;
}

void updateZones(int currentSceneIndex){
        for(int i=0; i< zones[currentSceneIndex].length; i++) {
                zones[currentSceneIndex][i].update();
        }
}

void interactZones(int currentSceneIndex, float u1x, float u1y, float u2x, float u2y){
        for(int i=0; i< zones[currentSceneIndex].length; i++) {
                zones[currentSceneIndex][i].interact(u1x,u1y, u2x,u2y);
        }
}

void oscZones(int currentSceneIndex, boolean all){ //if all than send osc irrespectable to active/state
        for(int i=0; i< zones[currentSceneIndex].length; i++) {
                PVector pos = new PVector();
                pos = resoPositionMapped(zones[currentSceneIndex][i].x, zones[currentSceneIndex][i].y, minY, maxY, minX, maxX, angle);
                float st = zones[currentSceneIndex][i].state;
                int lay = zones[currentSceneIndex][i].layer;
                boolean active = zones[currentSceneIndex][i].active;
                boolean editing = zones[currentSceneIndex][i].editing;
                if((active&&(st>0))||editing) {
                        resoSend(pos.x,pos.y,st,lay);

                }
                if(all) {
                        resoSend(pos.x,pos.y,st,lay);
                }

        }
}


void resoSend(float X, float Y, float opacity,int layer){
        OscBundle myBundle = new OscBundle();
        //OscMessage myMessage = new OscMessage("/composition/layers/"+layer+"/clips/1/video/effects/transform/positionx");
        OscMessage myMessage = new OscMessage("/composition/layers/"+layer+"/video/effects/transform/positionx");
        myMessage.add(X);
        myBundle.add(myMessage);
        myMessage.clear();
        myMessage.setAddrPattern("/composition/layers/"+layer+"/video/effects/transform/positiony");
        myMessage.add(Y);
        myBundle.add(myMessage);
        myMessage.clear();
        myMessage.setAddrPattern("/composition/layers/"+layer+"/video/opacity");
        myMessage.add(opacity); //TEMP (opacity)
        myBundle.add(myMessage);
        oscP5ResoZones.send(myBundle, resoAddress);
        ///composition/layers/5/video/opacity
}

float resoNorm(int X, int max){
        return (X - (max / 2) + 16384) / 32768f;
}

//same as resoNorm but float
PVector resoPosition(float x, float y){
  PVector pos = new PVector();
  pos.x = norm((x-(1280/2))/2,-16384, 16384);
  pos.y = norm((y-(800/2))/2, -16384, 16384);
  return pos;
}


PVector resoPositionMapped(float x, float y, float minY, float maxY, float minX, float maxX, float angle){
  //calc angle
  float X = map(x, 0,1280, minX, maxX);
  float Y = map(y, 0,800, minY, maxY);
  float factor = 1- (((Y)/800)*angle);
  X = ((X-640)*factor)+640;
  //normalize
  PVector pos = new PVector();
  pos.x = norm((X-(1280/2))/2,-16384, 16384);
  pos.y = norm((Y-(800/2))/2, -16384, 16384);
  return pos;
}


void saveZonesToFile(String filename) {
        PrintWriter output = createWriter(filename);
        for (int y=0; y<zones.length; y++) {
                for(int i=0; i< zones[y].length; i++) {
                        output.println(zones[y][i].toString());
                }
        }
        output.flush(); // Writes the remaining data to the file
        output.close(); // Finishes the file
}

void saveSetupToFile(String filename) {
        PrintWriter output = createWriter(filename);
        output.println(minX+";"+maxX+";"+minY+";"+maxY+";"+angle);
        output.flush(); // Writes the remaining data to the file
        output.close(); // Finishes the file
}


void loadSetupFromFile(String filename) {
        String[] lines = loadStrings(filename);
        String line = lines[0];
        String[] pieces = split(line, ';');
        minX = float(pieces[0]);
        maxX = float(pieces[1]);
        minY = float(pieces[2]);
        maxY = float(pieces[3]);
        angle = float(pieces[4]);
}


void loadZonesFromFile(String filename) {
        String[] lines = loadStrings(filename);
        int li=0;
        for (int y=0; y<zones.length; y++) {
                for(int i=0; i< zones[y].length; i++) {
                        String line = lines[li];
                        String[] pieces = split(line, ';');
                        zones[y][i].x = int(pieces[0]);
                        zones[y][i].y = int(pieces[1]);
                        zones[y][i].d = int(pieces[2]);
                        zones[y][i].id = int(pieces[3]);
                        zones[y][i].active = boolean(pieces[4]);
                        zones[y][i].layer = int(pieces[5]);
                        li++;
                }
        }
        // try {
        //
        // }
        // catch (IOException e) {
        //   e.printStackTrace();
        // }
        // catch (ClassNotFoundException e) {
        //   e.printStackTrace();
        // }
  }
}

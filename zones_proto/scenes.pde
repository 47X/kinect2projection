//class to hold all zones data and serialization etc

import oscP5.*;
import netP5.*;

class Scenes {

public Zone[][] zones = new Zone[9][9];

OscP5 oscP5ResoZones;
NetAddress resoAddress = new NetAddress("127.0.0.1",7000);

Scenes(){
        println(" created zone id : ");
        for(int j = 0; j<zones.length; j++) {
                for(int i = 0; i<zones[j].length; i++) {
                        zones[j][i] = new Zone((i+1)*80, (j+1)*80, (i+1)*(j+1)*10, (j*10)+i, i+2);
                        print(zones[j][i].id+", ");
                }
        }
        println("\n zones randomly initialized , initializing OSC ...");
        oscP5ResoZones = new OscP5(this, 7777);
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

void oscZones(int currentSceneIndex){
        for(int i=0; i< zones[currentSceneIndex].length; i++) {
                float x = resoNorm(zones[currentSceneIndex][i].x, 1280); ///!!! SIZE
                float y = resoNorm(zones[currentSceneIndex][i].y, 800);
                float st = zones[currentSceneIndex][i].state;
                int lay = zones[currentSceneIndex][i].layer;
                boolean active = zones[currentSceneIndex][i].active;
                if(active) {
                        resoPosF(x,y,st,lay);
                        //println("sending "+x +" " +y +" "+st+" to layer "+lay);
                }
        }
}


void resoPosF(float X, float Y, float opacity,int layer){
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
        myMessage.add(1-(opacity/1025));
        myBundle.add(myMessage);
        oscP5ResoZones.send(myBundle, resoAddress);
        ///composition/layers/5/video/opacity
}

float resoNorm(int X, int max){
        return (X - (max / 2) + 16384) / 32768f;
}

void saveDataToFile(String filename) {
        PrintWriter output = createWriter(filename);
        for (int y=0; y<zones.length; y++) {
                for(int i=0; i< zones[y].length; i++) {
                        output.println(zones[y][i].toString());
                }
        }
        output.flush(); // Writes the remaining data to the file
        output.close(); // Finishes the file
}

void loadDataFromFile(String filename) {
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

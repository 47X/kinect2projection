import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class zones_proto extends PApplet {

int currentSceneIndex = 0; //current scene
boolean zonesEditingMode = false;
int selectedZone=0;

//int[][] scenes;

//Zone[][] zones;
Scenes data;
String filename = "testdata.txt";//new File (sketchPath("") + "mydata");



///P3D!!!!
public void setup(){
  
  frameRate(30);

  data = new Scenes();
  // //make 8 zones
  // zones = new Zone[5][8];
  // for(int j = 0; j<zones.length; j++){
  //   for(int i = 0; i<zones[j].length; i++){
  //     zones[j][i] = new Zone(int(random(1)*width), int(random(1)*height), int(50+random(1)*100), i+1);
  //   }
  // }

}

public void draw(){
  clear();
  data.updateZones(currentSceneIndex);


  if(zonesEditingMode){
    fill(255);
    text("editing scene number "+(currentSceneIndex+1) +" index "+ currentSceneIndex, 20, 20);
    text(" numbers to select, arrows to move, =/- to resize, a to de/activate", 20,40);
  }
};


 // void updateZones(){
 //   for(int i=0; i< zones[currentSceneIndex].length; i++){
 //     zones[currentSceneIndex][i].update();
 //   }
 // }

public void keyPressed(){
  switch(key){
    case 'z':
      zonesEditingMode = !zonesEditingMode;
      println("Zones editing mode togle");
      break;
    case 's':
      println("Saving data to file...");
      data.saveDataToFile(filename);
      break;
    case 'l':
      println("Loading data from file...");
      data.loadDataFromFile(filename);
      break;

  }

///Zones editing mode / scene switching
  if(zonesEditingMode){

    //switch zones editing flag
        if(key>='1' & key<='9'){
          int num=min(PApplet.parseInt(str(key))-1, data.zones[currentSceneIndex].length-1);
          data.zones[currentSceneIndex][num].editing = !data.zones[currentSceneIndex][num].editing;
          selectedZone=num;
          println("toggle edit for zone index "+num);
          }
    //arrows
    if(key == CODED){
      println("code: "+ keyCode);
      switch(keyCode){
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
      switch(key){
        case '-':
          data.zones[currentSceneIndex][selectedZone].d--;
        break;
        case '=':
          data.zones[currentSceneIndex][selectedZone].d++;
        break;
        case 'a':
          data.zones[currentSceneIndex][selectedZone].active = !data.zones[currentSceneIndex][selectedZone].active;
        break;
      }
    }



  } else {
          //implement scene switching here
          if(key>='1' & key<='9'){
            int num=PApplet.parseInt(str(key))-1;
            currentSceneIndex = min(num, data.zones.length-1);
            println("Switching to scene index "+num);
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
}
class Zone {//implements Serializable {

  int x, y, d;
  int id;
  boolean editing = false;
  boolean active = true;
  int c = color(100,100,100,100);

 Zone(int px, int py, int pd, int _id){
   x=px;
   y=py;
   d=pd;
   id=_id;
   c = color(random(1)*255, random(1)*255, random(1)*255, 100);
 }

 public void update(){
  if(editing){
    stroke(255);
    strokeWeight(5);
    if(active){fill(c);} else {fill(100,100,100,100);};
    ellipse(x,y,d,d);
    fill(255);
    textMode(CENTER);
    text("id:"+str(id), x, y);
  } else {
    if(active){
    noStroke();
    fill(c);
    ellipse(x,y,d,d);
    fill(255);
    textMode(CENTER);
    text("id:"+str(id), x, y);
    }
  }

 }

 public String toString(){
   String s =
     str(x) +";"+
     str(y) +";"+
     str(d) +";"+
     str(id) +";"+
     str(active) +";";
   return s;
 }


} //endclass
//class to hold all zones data and serialization etc

class Scenes {

public Zone[][] zones = new Zone[9][9];

  Scenes(){
      println(" created zone id : ");
      for(int j = 0; j<zones.length; j++){
        for(int i = 0; i<zones[j].length; i++){
          zones[j][i] = new Zone((i+1)*80, (j+1)*80, (i+1)*(j+1)*10, (j*10)+i);
          print(zones[j][i].id+", ");
        }
      }
  println("\n zones randomly initialized");
  }

    public void updateZones(int currentSceneIndex){
      for(int i=0; i< zones[currentSceneIndex].length; i++){
        zones[currentSceneIndex][i].update();
      }
    }

    public void saveDataToFile(String filename) {
    PrintWriter output = createWriter(filename);
    for (int y=0; y<zones.length; y++){
      for(int i=0; i< zones[y].length; i++){
        output.println(zones[y][i].toString());
          }
        }
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      }

      public void loadDataFromFile(String filename) {
        String[] lines = loadStrings(filename);
        int li=0;
        for (int y=0; y<zones.length; y++){
          for(int i=0; i< zones[y].length; i++){
            String line = lines[li];
            String[] pieces = split(line, ';');
            zones[y][i].x = PApplet.parseInt(pieces[0]);
            zones[y][i].y = PApplet.parseInt(pieces[1]);
            zones[y][i].d = PApplet.parseInt(pieces[2]);
            zones[y][i].id = PApplet.parseInt(pieces[3]);
            zones[y][i].active = PApplet.parseBoolean(pieces[4]);
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
  public void settings() {  size(640, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "zones_proto" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

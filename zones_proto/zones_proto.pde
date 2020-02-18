int currentSceneIndex = 0; //current scene
boolean zonesEditingMode = false;
int selectedZone=0;

//int[][] scenes;

//Zone[][] zones;
Scenes data;
String filename = "testdata.txt";//new File (sketchPath("") + "mydata");



///P3D!!!!
void setup(){
  size(640, 400);
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

void draw(){
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

void keyPressed(){
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
          int num=min(int(str(key))-1, data.zones[currentSceneIndex].length-1);
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
            int num=int(str(key))-1;
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

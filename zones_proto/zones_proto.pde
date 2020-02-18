int currentSceneIndex = 0; //current scene
boolean zonesEditingMode = false;
int selectedZone=0;

Scenes data;
String filename = "testdata.txt";


///P3D!!!!
void setup(){
        size(1280, 800, P3D);
        frameRate(30);

        data = new Scenes();

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
        data.oscZones(currentSceneIndex);

        if(zonesEditingMode) {
                fill(255);
                text("editing scene number "+(currentSceneIndex+1) +" index "+ currentSceneIndex, 20, 20);
                text(" numbers to select, arrows to move, =/- to resize, a to de/activate, ,. to change reso layer", 20,40);
        }
};


void keyPressed(){
        switch(key) {
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
                //implement scene switching here
                if(key>='1' & key<='9') {
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

void mouseDragged(){
  if(zonesEditingMode){
    data.zones[currentSceneIndex][selectedZone].x = mouseX;
    data.zones[currentSceneIndex][selectedZone].y = mouseY;
  }
}

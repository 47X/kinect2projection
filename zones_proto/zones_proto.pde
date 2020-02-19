int currentSceneIndex = 0; //current scene
boolean zonesEditingMode = false;
int selectedZone=0;

int stageSetupMode = 0; //0 false,  1 minXY, 2 maxXY, 3 angle

Scenes data;
String filename = "testdata.txt";


///P3D!!!!
void setup(){
        size(1280, 800, P3D);
        frameRate(30);

        data = new Scenes();
        //TODO load file

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
                //data.oscZones(currentSceneIndex, true);
                break;
        case 'p':
                println("stage setup mode "+stageSetupMode);
                stageSetupMode = (stageSetupMode+1)%4;
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

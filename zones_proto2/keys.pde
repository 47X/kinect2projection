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
                                data.zones[currentSceneIndex][selectedZone].d-=5;
                                break;
                        case '=':
                                data.zones[currentSceneIndex][selectedZone].d+=5;
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

        if(stageSetupMode>0) {
                switch(stageSetupMode) {
                case 1:
                        switch(keyCode) {
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
                        switch(keyCode) {
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
                        switch(keyCode) {
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
        if(zonesEditingMode) {
                data.zones[currentSceneIndex][selectedZone].x = mouseX;
                data.zones[currentSceneIndex][selectedZone].y = mouseY;
        }
}

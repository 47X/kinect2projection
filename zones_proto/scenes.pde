//class to hold all zones data and serialization etc

class Scenes {

public Zone[][] zones = new Zone[9][9];

  Scenes(){
      println(" created zone id : ");
      for(int j = 0; j<zones.length; j++){
        for(int i = 0; i<zones[j].length; i++){
          zones[j][i] = new Zone((i+1)*80, (j+1)*80, (i+1)*(j+1)*10, (j*10)+i, i+2);
          print(zones[j][i].id+", ");
        }
      }
  println("\n zones randomly initialized");
  }

    void updateZones(int currentSceneIndex){
      for(int i=0; i< zones[currentSceneIndex].length; i++){
        zones[currentSceneIndex][i].update();
      }
    }

    void interactZones(int currentSceneIndex, float u1x, float u1y, float u2x, float u2y){
      for(int i=0; i< zones[currentSceneIndex].length; i++){
        zones[currentSceneIndex][i].interact(u1x,u1y, u2x,u2y);
      }
    }

    void saveDataToFile(String filename) {
    PrintWriter output = createWriter(filename);
    for (int y=0; y<zones.length; y++){
      for(int i=0; i< zones[y].length; i++){
        output.println(zones[y][i].toString());
          }
        }
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      }

      void loadDataFromFile(String filename) {
        String[] lines = loadStrings(filename);
        int li=0;
        for (int y=0; y<zones.length; y++){
          for(int i=0; i< zones[y].length; i++){
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

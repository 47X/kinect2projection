import java.util.Arrays;

int x, y = 0;
int px, py = 0;
int nx, ny = 0;

int SMOOTH = 10;

//int[][] positions = new int[10][2];

ArrayList<Integer> xpositions = new ArrayList<Integer>();
ArrayList<Integer> ypositions = new ArrayList<Integer>();


void setup(){
size(400, 400);
frameRate(30);
background(0);
noStroke();

}


void draw(){
clear();
//store previous positions in array
xpositions.add(x);
ypositions.add(y);
if (xpositions.size() > SMOOTH){
  xpositions.remove(0);
  ypositions.remove(0);
}; 
 
//update positions with dummy data 
x = int(mouseX + (random(1)*10));
y = int(mouseY + (random(1)*10));
//calculate smoothed
nx = avg(xpositions);
ny = avg(ypositions);

fill(255,80,80);
ellipse(x,y,100,100);

fill(80,80,255);
ellipse(nx,ny,50,50);

//println(xpositions);
}




private int avg(ArrayList <Integer> marks) {
  Integer sum = 0;
  if(!marks.isEmpty()) {
    for (Integer mark : marks) {
        sum += mark;
    }
    return sum / marks.size();
  }
  return sum;
}

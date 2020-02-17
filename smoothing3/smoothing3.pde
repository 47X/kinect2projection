/**
 * Easing. 
 * 
 * Move the mouse across the screen and the symbol will follow.  
 * Between drawing each frame of the animation, the program
 * calculates the difference between the position of the 
 * symbol and the cursor. If the distance is larger than
 * 1 pixel, the symbol moves part of the distance (0.05) from its
 * current position toward the cursor. 
 */
 
//PVector easpos = new PVector(0,0);
//PVector rawpos = new PVector(0,0);

//float easing = 0.08;

easyVec2 pos = new easyVec2();

void setup() {
  size(640, 360); 
  noStroke();  
}

void draw() { 
  clear();
  pos.raw.set(mouseX+ (random(1)*10), mouseY+ (random(1)*10));
  pos.update();
  pos.easing = 0.08;
  

}//endloop

class easyVec2{
  PVector easy = new PVector(0,0);
  PVector raw = new PVector(0,0);
  float x, y;
  float easing = 0.08;
  
  easyVec2(){
  }
  
  void update(){
  PVector d = PVector.sub(raw, easy);
    d.mult(easing);
    easy = PVector.add(easy ,d); 
    x = easy.x;
    y = easy.y;
  }

}//endclass

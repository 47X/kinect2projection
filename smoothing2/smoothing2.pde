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
 
PVector easpos = new PVector(0,0);
PVector rawpos = new PVector(0,0);

float easing = 0.08;

void setup() {
  size(640, 360); 
  noStroke();  
}

void draw() { 
  background(51);
  
  rawpos.set(mouseX, mouseY);
  PVector d = PVector.sub(rawpos, easpos);
  d.mult(easing);
  easpos = PVector.add(easpos ,d);
  
  //float dx = targetX - x;
  //x += dx * easing;
  
  //float targetY = int(mouseY + (random(1)*10));
  //float dy = targetY - y;
  //y += dy * easing;
  
  fill(255,80,80,80);
  ellipse(easpos.x, easpos.y, 66, 66);
  fill(80,255,80,80);
  ellipse(rawpos.x, rawpos.y, 30, 30);
}

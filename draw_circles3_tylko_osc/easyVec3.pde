class easyVec3{
  PVector easy = new PVector(0,0,0);
  PVector raw = new PVector(0,0,0);
  PVector prev = new PVector(0,0,0);
  float x, y, z;
  float easing = 0.08;
  int age = 0;
  
  easyVec3(){
  }
  
  void update(){
  PVector d = PVector.sub(raw, easy);
    d.mult(easing);
    easy = PVector.add(easy ,d); 
    x = easy.x;
    y = easy.y;
    y = easy.z;
  }

}//endclass

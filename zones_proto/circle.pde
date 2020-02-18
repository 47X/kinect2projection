class Zone {//implements Serializable {

  int x, y, d;
  int id;
  boolean editing = false;
  boolean active = true;
  color c = color(100,100,100,100);
  //inetraction with stage
  float state = 0f; //is user over this?
  float speed = 0.05; //how fast it changes state
  int layer;


 Zone(int px, int py, int pd, int _id, int _layer){
   x=px;
   y=py;
   d=pd;
   id=_id;
   layer = _layer;
   c = color(random(1)*255, random(1)*255, random(1)*255, 100);
 }

 void update(){
  if(editing){
    stroke(255);
    strokeWeight(5);
    if(active){fill(c);} else {fill(100,100,100,100);};
    ellipse(x,y,d,d);
    fill(255);
    textMode(CENTER);
    text("id:"+str(id), x, y);
    text("layer:"+str(layer), x, y+10);
  } else {
    if(active){
    noStroke();
    fill(c);
    ellipse(x,y,d,d);
    fill(200, 200, 200, 100);
    ellipse(x,y,d*state,d*state);
    fill(255);
    textMode(CENTER);
    text("id:"+str(id), x, y);
    text("layer:"+str(layer), x, y+10);
    }
  }

 }

 void interact(float u1x, float u1y, float u2x, float u2y){
   float dist1 = dist( u1x, u1y, x, y);
   float dist2 = dist( u2x, u2y, x, y);
   if((dist1<(d/2))||(dist2<(d/2))){
     state = min(state + speed, 1);
   } else {
     state = max(state - speed, 0);
   }
 }

 void sendToReso(){
   
 }

 String toString(){
   String s =
     str(x) +";"+
     str(y) +";"+
     str(d) +";"+
     str(id) +";"+
     str(active) +";"+
     str(layer) +";";
   return s;
 }


} //endclass

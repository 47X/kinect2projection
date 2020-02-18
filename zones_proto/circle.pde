class Zone {//implements Serializable {

  int x, y, d;
  int id;
  boolean editing = false;
  boolean active = true;
  color c = color(100,100,100,100);

 Zone(int px, int py, int pd, int _id){
   x=px;
   y=py;
   d=pd;
   id=_id;
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
  } else {
    if(active){
    noStroke();
    fill(c);
    ellipse(x,y,d,d);
    fill(255);
    textMode(CENTER);
    text("id:"+str(id), x, y);
    }
  }

 }

 String toString(){
   String s =
     str(x) +";"+
     str(y) +";"+
     str(d) +";"+
     str(id) +";"+
     str(active) +";";
   return s;
 }


} //endclass

import java.util.Arrays;

class easyVec3{
  PVector easy = new PVector(0,0,0);
  PVector raw = new PVector(0,0,0);
  PVector prev = new PVector(0,0,0);
  float x, y, z;
  float easing = 0.15;
  int aging = 25;

  int age = 0;

  private int index = 0;
  private float[] hist = {0,0,0};

  //ArrayList<PVector> hist = new ArrayList<PVector>();

  easyVec3(){
  }

  void update(){
    //calc easing
    PVector d = PVector.sub(raw, easy);
    d.mult(easing);
    easy = PVector.add(easy ,d);
    x = easy.x;
    y = easy.y;
    y = easy.z;



    ////fill history and trim it
    hist[index] = raw.x;
    index = (index+1)%3;

    //calc hist avg
    float sum = 0;
    for(int i = 0; i < hist.length; i ++){
      sum = sum + hist[i];
    }


    if(sum/hist.length==raw.x){
      age = age + aging;
      //println("Age is: "+ age);
    } else {
      age = age - (10*aging);
    }

    if (age<0){
      age =0;
    }

    if (age>1024){
      age = 1024;
    };

    ////fill history and trim it
    //hist.add(raw);
    //if (hist.size() > 5) {
    //  hist.remove(0);
    //}
    //PVector oldpos = hist.get(hist.size()-1);
    ////PVector old2pos = hist.get(2);
    ////PVector old3pos = hist.get(1);
    ////println(hist);

    ////increase age if position stalled
    //if(hist.size()>3 && oldpos.x==raw.x){
    //  age ++;
    //  //println("Age is: "+ age);
    //} else {
    //  age = 0;
    //}

    //hist.trimToSize();
  }


}//endclass

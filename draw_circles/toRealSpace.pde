//maps sensorspace values to worldspace values, for horizontal only, passes vertival as is
//
//assuming kinect v1 horizontal fov of 57deg tan(57/2)=0,5429556996
//maps to 0-1


float[] toRealSpace(int x, int y, int z){
  
  //tangens of horizontal fov bisecting angle
  final float htan = 0,5429556996;
  
  //normalize input assuming input data is in pixels for x and y, centimeters for z
  float h = norm(x, 0, 640);
  float v = norm(y, 0, 480);
  float d = norm(z, 0, 600);
 
  
  
  
  
  //calculates max x at given distance
  
  
  
  //return
  float[] ret;
  ret[0]=1;
  ret[1]=1;
  ret[2]=1;
  return vals; 
}

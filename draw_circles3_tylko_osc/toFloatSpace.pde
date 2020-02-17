//maps sensorspace values to worldspace values, for horizontal only, passes vertival as is
//
//assuming kinect v1 horizontal fov of 57deg tan(57/2)=0,5429556996
//maps to 0-1


float[] toFloatSpace(int x, int y, int z){
  
  //tangens of horizontal fov bisecting angle
  final float htan = 0.5429556996;
  
  //normalize input assuming input data is in pixels for x and y, centimeters for z
  float h = norm(x, 0, 640);
  float v = norm(y, 0, 480);
  float d = norm(z, 0, 460); //max real distance on stage
 
  //calculates max x at given distance
  //float maxX = d* htan;
  float maxX = 0.5;
  
  float firstXpoint = 0.5 - maxX;
  float lastXpoint = 0.5 +maxX;
  float positionX = map(h,0,1,firstXpoint, lastXpoint);
  
  //return
  float[] ret = {0,0,0};
  ret[0]=positionX;
  ret[1]=d;
  ret[2]=v;
  return ret; 
}

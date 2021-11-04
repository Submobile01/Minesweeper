class Firework{
  float cenX = 400;
  float cenY = 200;
  int size = 30;
  float angle;
  float rSpeed;
  float xSpeed;
  float ySpeed;
  float gravity = -0.44;
  color col;
  public Firework(float rs, float xs, float ys, int r, int gr, int b){
    angle = 0;
    rSpeed = rs;
    xSpeed = xs;
    ySpeed = ys;
    col = color(r,gr,b);
  }
  void drawIt(){
    int halfH = size/2;
    int halfW = size/5;
    noStroke();
    fill(col);
    quad(cenX-halfH*sin(angle),cenY+halfH*cos(angle),
         cenX-halfW*cos(angle),cenY-halfW*sin(angle),
         cenX+halfH*sin(angle),cenY-halfH*cos(angle), 
         cenX+halfW*cos(angle),cenY+halfW*sin(angle));
    quad(cenX-halfH*sin(angle+PI/3),cenY+halfH*cos(angle+PI/3),
         cenX-halfW*cos(angle+PI/3),cenY-halfW*sin(angle+PI/3),
         cenX+halfH*sin(angle+PI/3),cenY-halfH*cos(angle+PI/3), 
         cenX+halfW*cos(angle+PI/3),cenY+halfW*sin(angle+PI/3));
    quad(cenX-halfH*sin(angle+2*PI/3),cenY+halfH*cos(angle+2*PI/3),
         cenX-halfW*cos(angle+2*PI/3),cenY-halfW*sin(angle+2*PI/3),
         cenX+halfH*sin(angle+2*PI/3),cenY-halfH*cos(angle+2*PI/3), 
         cenX+halfW*cos(angle+2*PI/3),cenY+halfW*sin(angle+2*PI/3));
    cenX+=xSpeed;
    cenY+=ySpeed;
    ySpeed-=gravity;
    angle+=rSpeed;
  }
  
  boolean inBound(){
    if(cenY > height || cenX<0 || cenX>width) return false;
    return true;
  }
}

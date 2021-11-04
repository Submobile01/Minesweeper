public class Block {
  public int posX;//start with 0
  public int posY;
  public int sideL;
  public boolean colorCode;
  public int state;//0-orig; 1-flag; 2-revealed(num/bomb)
  public color col;
  public final color green = color(0,255,0);
  public final color darkGreen = color(0,230,50);
  public final color grey = color(140);
  public final color white = color(240);
  public final color red = color(255,0,0);
  public int number;//surrounding mines(0-empty, -1-mine)
  public PFont f = createFont("Arial", 16, true);
    public Block(int x, int y, int l) {
      sideL = l;
      posX = x*sideL;
      posY = y*sideL;
      number = 0;
      if(((posX+posY)/sideL)%2 == 0) colorCode = true;
      else colorCode = false;
      state = 0;
    }
    public void drawIt(){
      noStroke();
      switch(this.state){//0-orig; 1-flag; 2-revealed(num/bomb); 3-pressed
              case 0: 
                if(this.colorCode) col = green; 
                else col = darkGreen; 
                fill(col);
                rect(posX,posY,sideL,sideL);
                break;
              case 1: 
                if(this.colorCode) col = green; 
                else col = darkGreen;
                fill(col);
                rect(posX,posY,sideL,sideL);
                drawFlag();
                break;
              case 2: 
                if(this.colorCode) col = white; 
                else col = grey;
                fill(col);
                rect(posX,posY,sideL,sideL);
                if(number != -1) drawNumber();
                else{
                  drawBomb();
                }
                break;
              case 3: 
                if(this.colorCode) col = color(100,255,100); 
                else col = color(20,245,20); 
                fill(col);
                rect(posX,posY,sideL,sideL);
                break;
            }
      
    }
    private void drawNumber(){
        if(number != 0){
          textFont(f,20);
          fill(0);
          text(number, posX+sideL*0.35, posY+sideL*0.62);
        }
    }
    private void drawFlag(){
        fill(0);
        rect(posX+sideL/3, posY+sideL/6, 0.2, sideL*2/3);
        fill(red);
        triangle(posX+sideL/3, posY+sideL/6,
                  posX+sideL/3, posY+sideL/2,
                    posX+sideL*2/3, posY+sideL/3);
    }
    private void drawBomb(){
        fill(color(0));
        circle(posX+sideL/2, posY+sideL/2,sideL*0.4);
        line(posX+sideL*0.6, posY+sideL/3, posX+sideL*0.8, posY+sideL/8);
        drawSpark(posX+sideL*0.8, posY+sideL/8,sideL/10);
    }
    private void drawSpark(float cenX, float cenY, float size){
        fill(red);
        triangle(cenX, cenY-size, cenX-0.85*size, cenY+0.5*size, cenX+0.85*size, cenY+0.5*size);
        triangle(cenX, cenY+size, cenX-0.85*size, cenY-0.5*size, cenX+0.85*size, cenY-0.5*size);
    }
    public void drawCross(){
      stroke(255);
      line(posX+sideL/10,posY+sideL/10,posX+sideL*9/10,posY+sideL*9/10);
      stroke(255);
      line(posX+sideL*9/10,posY+sideL*9/10,posX+sideL/10,posY+sideL/10);
    }
    /*private void drawM(){
        textFont(f,20);
        fill(0);
        text("M", posX+sideL/4, posY+sideL/2);
    }*/
    
    void setState(int n){
        state = n;
        this.drawIt();
        //return number;
    }
    void setColor(float r, float g, float b){
        col = color(r,g,b);
    }
    void setNumber(int n){
        number = n;
    }
    int getState(){
        return state;
    }
    int getNumber(){
        return number;
    }
}

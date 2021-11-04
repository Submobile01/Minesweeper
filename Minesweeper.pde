import processing.sound.*;
int rows;
int columns;
int sideL;
Block[][] blocks;
boolean skip = false;
public PFont f;
SoundFile chu;
SoundFile yes;
SoundFile hua;
SoundFile bang;
SoundFile wow;
SoundFile ding; 
int gameStage;//1-game, 2-gameOver, 3-youWon
int startTime;
int endTime;
int clickCount = 0;
int numMine;
float densMine = 0.16;
int flagCount;
int blockCount;
int buttonCount;
int bestTime;
ArrayList<Firework> fireworks;
void setup(){
  size(800,600);
  rows = 15;
  columns = 20;
  restart();
  chu = new SoundFile(this, "chu.wav");
  yes = new SoundFile(this, "yes.wav");
  hua = new SoundFile(this, "hua.wav");
  bang = new SoundFile(this, "bang.wav");
  wow = new SoundFile(this, "wow.wav");
  ding = new SoundFile(this, "ding.wav");
}

void draw(){
    if(gameStage == 1){
       
    }
    else if(gameStage == 2){
      //drawRestart();
      //drawAllMines();
    }
    else{
      for(int i=0; i<rows; i++){
        for(int j=0; j<columns; j++){
          blocks[i][j].drawIt();
        }
      }
      drawWinBoard();
      for(int i=0; i<fireworks.size(); i++) if(fireworks.get(i).inBound()) fireworks.get(i).drawIt();
    }
}

void mouseMoved(){
  /*Block theBlock = blocks[mouseY/40][mouseX/40];
  float[] rgb ={theBlock.col >> 16 & 0xFF, theBlock.col & 0xFF, theBlock.col >> 8 & 0xFF};
  theBlock.setColor(rgb[0]+20,rgb[1]+20,rgb[2]+20);*/
}
void mouseClicked(){
    
  
}

void mousePressed(){
  if(gameStage == 1){
    int y = mouseY/sideL;
    int x = mouseX/sideL;
    Block theBlock = blocks[y][x];
    if(mouseButton == LEFT){
      buttonCount++;
      lightBlock(y,x,3);
    }
    else if(mouseButton == RIGHT) buttonCount++;
    if(buttonCount == 2 && theBlock.getState() == 2){
      lightAround(y,x,3);
    }
  }
}

void mouseReleased(){
  //when playing
  if(gameStage == 1){
    int y = mouseY/sideL;
    int x = mouseX/sideL;
    Block theBlock = blocks[y][x];
    if(mouseButton == LEFT){
      buttonCount--;
      lightBlock(y,x,0);
    }
    else if(mouseButton == RIGHT){
      buttonCount--;
    }
    if(buttonCount == 1 && theBlock.getState() == 2 && ( countFlags(y,x) == theBlock.getNumber() ) ){
      flipAround(y,x);
    }
    else if(buttonCount == 1 && theBlock.getState() == 2){
      lightAround(y,x,0);
    }

    if(theBlock.getState() != 2){
      if(mouseButton == LEFT){
        //first click stuff
        //println(clickCount);
        if(clickCount == 0){
          startTime = hour()*3600 + minute()*60 + second();
          while(blocks[y][x].getNumber() != 0){ reGenBlocks();/*println(blocks[y][x].getNumber());*/}
        } theBlock = blocks[y][x];
        clickCount++;
        activateBlock(y,x);
      }   
      else if(mouseButton == RIGHT){
        chu.play();
        if(theBlock.getState() == 1){theBlock.setState(0); flagCount--;}
        else{theBlock.setState(1);flagCount++;}
      }
      /*else if(mouseButton == CENTER){
        if(theBlock.getState() == 2) flipAround(y,x);
      }*/
      //theBlock.drawIt();
      
    }
    if(blockCount == rows*columns-numMine){
      yes.play();
      gameStage = 3;
      for(int i=0; i<8; i++){
        int ranSign = 1;
        if(random(2)>1) ranSign = -1;
        float xs = random(10)*ranSign;
        float ys = -6-random(8);
        float rs = xs*0.05;
        int re = 140 + (int)random(100);
        int gr = 100 + (int)random(90);
        int bl = 100 + (int)random(90);
        fireworks.add(new Firework(rs,xs,ys,re,gr,bl));
      }
      endTime = hour()*3600 + minute()*60 + second();
    }
  }
  
  //when gameOver
  if(gameStage == 2){
      drawAllMines();
      drawRestart();
      if(mouseX>(width*0.45) && mouseX<(width*0.55)
        && mouseY>(height*0.56) && mouseY<(height*0.66))restart();
  }
  if(gameStage == 3){

      if(mouseX>(width*0.45) && mouseX<(width*0.55)
        && mouseY>(height*0.56) && mouseY<(height*0.66))restart();
      else hua.play();
      for(int i=0; i<8; i++){
        int ranSign = 1;
        if(random(2)>1) ranSign = -1;
        float xs = random(10)*ranSign;
        float ys = -6-random(8);
        float rs = xs*0.05;
        int re = 140 + (int)random(100);
        int gr = 100 + (int)random(90);
        int bl = 100 + (int)random(90);
        fireworks.add(new Firework(rs,xs,ys,re,gr,bl));
    }
  }
  println(rows*columns-numMine-blockCount);
}
private void genField(int numMine){
  int[][] f = new int[rows][columns];
  for(int i=0; i<numMine; i++){
    int ran = (int)(Math.random()*rows*columns);
    int row = ran/columns;
    int column = ran%columns;
    if(f[row][column] == 0){
      f[row][column] = -1;
    }
    else i--;
  }
  for(int i=0; i<rows; i++){
    for(int j=0; j<columns; j++){
      if(f[i][j] == -1){
        blocks[i][j].number = -1;
        //blocks[i][j].state = 3;
      }
    }
  }
  getNumbers();
}
    
private void getNumbers(){
  for(int i=0; i<rows; i++){
    for(int j=0; j<columns; j++){
      if(blocks[i][j].number!=-1){
        //not left most
        if(i!=0){
          if(j!=0){
            if(blocks[i-1][j-1].number == -1) blocks[i][j].number++;
          }
          if(j!=columns-1){
            if(blocks[i-1][j+1].number == -1) blocks[i][j].number++;
          }
            if(blocks[i-1][j].number == -1) blocks[i][j].number++;
        }
        //not right most
        if(i!=rows-1){
          if(j!=0){
            if(blocks[i+1][j-1].number == -1) blocks[i][j].number++;
          }
          if(j!=columns-1){
            if(blocks[i+1][j+1].number == -1) blocks[i][j].number++;
          }
            if(blocks[i+1][j].number == -1) blocks[i][j].number++;
        }
        //neutral
          if(j!=0){
            if(blocks[i][j-1].number == -1) blocks[i][j].number++;
          }
          if(j!=columns-1){
            if(blocks[i][j+1].number == -1) blocks[i][j].number++;
          }
      }
      //if(blocks[i][j].number>=0) blocks[i][j].state = 2;(toTest)
    }
  }
}

void triggerZero(int i, int j){
    if(blocks[i][j].getState() == 0 || blocks[i][j].getState() == 3){
        blocks[i][j].setState(2);blockCount++;/*println(blockCount)*/;
        if(blocks[i][j].getNumber() == 0){
          if(i!=0){
            if(j!=0){
              triggerZero(i-1,j-1);
            }
            if(j!=columns-1){
              triggerZero(i-1,j+1);
            }
              triggerZero(i-1,j);
          }
          //not right most
          if(i!=rows-1){
            if(j!=0){
              triggerZero(i+1,j-1);
            }
            if(j!=columns-1){
              triggerZero(i+1,j+1);
            } 
              triggerZero(i+1,j);
          }
          //neutral
            if(j!=0){
              triggerZero(i,j-1);
            }
            if(j!=columns-1){
              triggerZero(i,j+1);
            }
        }
        //println(1); (ToTest)
    }
}
int countFlags(int i, int j){
  int count = 0;
  if(i!=0){
    if(j!=0){
      if(blocks[i-1][j-1].getState() == 1) count++;
    }
    if(j!=columns-1){
      if(blocks[i-1][j+1].getState() == 1) count++;
    }
      if(blocks[i-1][j].getState() == 1) count++;
  }
  //not right most
  if(i!=rows-1){
    if(j!=0){
      if(blocks[i+1][j-1].getState() == 1) count++;
    }
    if(j!=columns-1){
      if(blocks[i+1][j+1].getState() == 1) count++;
    } 
      if(blocks[i+1][j].getState() == 1) count++;
  }
  //neutral
    if(j!=0){
      if(blocks[i][j-1].getState() == 1) count++;
    }
    if(j!=columns-1){
      if(blocks[i][j+1].getState() == 1) count++;
    }
    return count;
}

void flipAround(int i, int j){
  if(i!=0){
    if(j!=0){
      activateBlock(i-1,j-1);
    }
    if(j!=columns-1){
      activateBlock(i-1,j+1);
    }
      activateBlock(i-1,j);
  }
  //not right most
  if(i!=rows-1){
    if(j!=0){
      activateBlock(i+1,j-1);
    }
    if(j!=columns-1){
      activateBlock(i+1,j+1);
    } 
      activateBlock(i+1,j);
  }
  //neutral
    if(j!=0){
      activateBlock(i,j-1);
    }
    if(j!=columns-1){
      activateBlock(i, j+1);
    }
}

void lightAround(int i, int j, int state){
  if(i!=0){
    if(j!=0){
      lightBlock(i-1,j-1,state);
    }
    if(j!=columns-1){
      lightBlock(i-1,j+1,state);
    }
      lightBlock(i-1,j,state);
  }
  //not right most
  if(i!=rows-1){
    if(j!=0){
      lightBlock(i+1,j-1,state);
    }
    if(j!=columns-1){
      lightBlock(i+1,j+1,state);
    } 
      lightBlock(i+1,j,state);
  }
  //neutral
    if(j!=0){
      lightBlock(i,j-1,state);
    }
    if(j!=columns-1){
      lightBlock(i, j+1,state);
    }
}

private void drawAllMines(){//and bad flags
  for(int i=0; i<rows; i++){
      for(int j=0; j<columns; j++){
          Block theBlock = blocks[i][j];
          if(theBlock.getNumber() == -1){
            if(theBlock.getState() == 0){
              theBlock.setState(2);
            }
          }
          else{
            if(theBlock.getState() == 1) theBlock.drawCross();
          }
      }
  }
  skip = false;      
}

void activateBlock(int i, int j){
   Block theBlock = blocks[i][j];
   if(theBlock.getState() == 0 || theBlock.getState() == 3){
     if(theBlock.getNumber() == -1){
        gameStage = 2;
        
        bang.play();
        endTime = hour()*3600 + minute()*60 + second();
     }
     else if(blockCount == rows*columns - numMine){
     }
     else if(theBlock.getNumber() == 0){
       triggerZero(i,j);
       wow.play();
     }
     else{
       blockCount++;
       ding.play();
     }
     //println(blockCount);
     theBlock.setState(2);
   }
}

void lightBlock(int i, int j, int state){
   Block theBlock = blocks[i][j];
   if(theBlock.getState() != state && theBlock.getState() != 2 && theBlock.getState() != 1){
     theBlock.setState(state);
   }
}

void drawRestart(){
  //the rectangle
  fill(130,130,210,130);
  noStroke();
  rect(width/3, height/4, width/3, height/2,55);
  
  //the words
  String bestTimeString;
  if(bestTime == 0) bestTimeString = "--";
  else bestTimeString = bestTime+"";
  f  = createFont("Arial", width/16, true);
  fill(0);
  text("Time: " + "--",width*0.35, height*0.35);
  text("Best Time: " + bestTimeString,width*0.35, height*0.42);
  
  //restart Button
  
  fill(color(60));
  noStroke();
  rect(width*0.45,height*0.56, width/10, height*0.1);
  fill(160,70,70,200);
  text("Restart",width*0.46, height*0.62);
}

void restart(){//reset everything
  //size(800,600);
  gameStage = 1;
  flagCount = 0;
  blockCount = 0;
  clickCount = 0;
  numMine = round(rows*columns*densMine);
  sideL = height/rows;
  blocks = new Block[rows][columns];
  fireworks = new ArrayList<Firework>();
  background(0);
  //instantiate each Block
  for(int i=0; i<rows; i++){
    for(int j=0; j<columns; j++){
      blocks[i][j] = new Block(j,i,height/rows);
    }
  }
  //generate mines and numbers
  genField(numMine);
  
  //draw the initial
  for(int i=0; i<rows; i++){
    for(int j=0; j<columns; j++){
      blocks[i][j].drawIt();
    }
  }
}

void reGenBlocks(){//reset everything
  //instantiate each Block
  for(int i=0; i<rows; i++){
    for(int j=0; j<columns; j++){
      blocks[i][j] = new Block(j,i,height/rows);
    }
  }
  //generate mines and numbers
  genField(numMine);
}

private void drawWinBoard(){
    //the rectangle
  fill(color(130,130,210,130));
  noStroke();
  rect(width/3, height/4, width/3, height/2,55);
  
  //the words
  String bestTimeString;
  int thisTime = endTime-startTime;
  if(thisTime<bestTime || bestTime == 0){//newRecord maybe flowers?
    bestTime = thisTime;
  }
  
  if(bestTime == 0) bestTimeString = "--";
  else bestTimeString = bestTime+"";
  f = createFont("Times New Roman", width/48, true);
  fill(40);
  textFont(f);
  text("Click Anywhere for more FUN", width*0.38, height*0.29);
  f  = createFont("Arial", (int)(width/36.0), true);
  fill(44,66,132);
  textFont(f);
  text("Time: " + thisTime,width*0.35, height*0.35);
  text("Best Time: " + bestTimeString,width*0.35, height*0.42);
  
  //restart Button
  
  fill(color(60,200));
  noStroke();
  rect(width*0.45,height*0.56, width/10, height*0.1);
  fill(0);
  text("Restart",width*0.46, height*0.62);
}

void drawMenu(){
  background(200);
}

PImage fhLogo;

void setup(){
  background(0);
  size(1600,900);
  //load image
  fhLogo = loadImage ("logo.jpg");
  sourceXStart = 250;
  sourceXEnd = width-100;
  sourceYStart = 100;
  sourceYEnd = height-100;
  xIncrement = (sourceXEnd-sourceXStart)/15;
  yIncrement = (sourceYEnd-sourceYStart)/15;
  dayIncrement = 90/15;
  
  //read in custom font
  PFont font;
  font = createFont("BebasNeue.otf",18);
  textFont (font);
  
  //read data into the subsIncrease ArrayList
  String[] strSubsIncrease = loadStrings("funhausSubIncrease.csv");
  for(int i=0;i<strSubsIncrease.length;i++){
    subsIncrease.add(Float.parseFloat(strSubsIncrease[i]));
    
  }//end for
  
  
}//end setup
//declare ArrayList to hold subscriber increase values
ArrayList<Float> subsIncrease = new ArrayList<Float>();
float sourceXStart, sourceXEnd, sourceYStart, sourceYEnd;
float xIncrement, yIncrement, dayIncrement;
int menuPosition;

void draw(){
  background(0);
  image(fhLogo, 0,0);
  textSize(18);
  textAlign(CENTER);
  text("Funhaus Subscriber\nIncrease\n31-07-15 ->28/10/15\nPeriod of 90 days", 100,220);
  float balance = xIncrement/6;
  stroke(255);
  //draw graph axis
  //y axis
  line(sourceXStart,sourceYStart,sourceXStart, sourceYEnd);
 
  //x axis
  line(sourceXStart, sourceYEnd,sourceXEnd-balance, sourceYEnd);
  
  //draw notches
  //x axis notches
  int loopVal=0;
  for(float i=sourceXStart; i<sourceXEnd+1; i+=xIncrement){
    
    if(loopVal == 0){
      text(1, i, sourceYEnd+20);
      
    }//end if
    else{
      line(i-balance, sourceYEnd+5,i-balance, sourceYEnd-5);
      stroke(50);
      line(i-balance,sourceYStart,i-balance, sourceYEnd-5);
      text(int(loopVal*dayIncrement) , i-balance, sourceYEnd+20);
      
    
    }//end else 
    loopVal+=1;
    
  }//end for
  
  stroke(255);
  //y axis notches
  loopVal = 0;
  for(float i=sourceYEnd; i>sourceYStart-1; i-=yIncrement){
    line(sourceXStart-5, i, sourceXStart+5, i);
    text(200*loopVal,sourceXStart-25,i);
    loopVal+=1;
  
  }//end for
  
  //
  
  //Draw lines
  int prevPoint;
  float xSegment= (sourceXEnd-sourceXStart)/subsIncrease.size();
  float ySegment= (sourceYEnd-sourceYStart)/15;
  for(int i=0;i<subsIncrease.size()-1;i++){
    float yPointCur;
    float yPointNext;
    
    //calculate current y point
    float curSubVal = subsIncrease.get(i);
    int multTwoHun=0;
    while(curSubVal>200){
      curSubVal-=200;
      multTwoHun+=1;
      
    }//end while
    curSubVal=(curSubVal/200)*yIncrement;
    yPointCur=yIncrement*multTwoHun + curSubVal;
    
    //calculate the next y point
    float nextSubVal = subsIncrease.get(i+1);
    multTwoHun = 0;
    while(nextSubVal>200){
      nextSubVal-=200;
      multTwoHun+=1;
      
    }//end while
    nextSubVal=(nextSubVal/200)*yIncrement;
    yPointNext = yIncrement*multTwoHun + nextSubVal;
    
    stroke(252,128,2);
    //draw the line between the points
    line(sourceXStart+(xSegment*i),sourceYEnd-(yPointCur), sourceXStart + (xSegment*(i+1)),sourceYEnd-(yPointNext));
    
  }//end for
  
  text("Subscriber\nIncrease", 150,520);
  text("Days", width-(sourceXStart+sourceXEnd)/2, sourceYEnd+50);
  
}//end draw

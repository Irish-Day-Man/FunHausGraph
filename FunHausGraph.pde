//imports for camera library
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

//import for gui
import controlP5.*;

//import swing for the warning message
import javax.swing.*;

//imports for music
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//objects to hold images
PImage fhLogo;
PImage theHaus;
PImage hausLive;

//PImage object to hold background image
PImage background;

//controlp5 objects
ControlP5 cp5;
ControlP5 cp6;

//array list for video objects
ArrayList<Video> videos = new ArrayList<Video>();

//Declare variables related to music
Minim minim;
AudioPlayer player;
int muteValue=0;

//variable for activating and de-activating the use of the 3d camera where necessary
boolean camActive=false;

//variable for activating and deactivating the slider and button for displaying info
boolean statsDisplay = false;

//variable for storing data based off of videoNo
String videoData="";

//variable for holding video Number
int videoNumber = 1;

//begin setup
void setup(){
  
  //reset background
  background(233,233,231);
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this);
  
  //setup cp5 buttons for navigating
  cp5.addButton("drawLineGraph").setValue(10).setPosition(100,height-40).setSize(80,20).setLabel("Line Graph");
  cp5.addButton("draw3Dgraph").setValue(2).setPosition(200,height-40).setSize(80,20).setLabel("3D Graph");
  cp5.addButton("displayStatistics").setValue(3).setPosition(300, height-40).setSize(80,20).setLabel("Data Statistics");
  cp5.addButton("changeSong").setValue(4).setPosition(400,height-40).setSize(80,20).setLabel("Change Song");
  cp5.addButton("muteMusic").setValue(5).setPosition(500,height-40).setSize(80,20).setLabel("Mute Music");
  cp5.addButton("controls").setValue(6).setPosition(600,height-40).setSize(80,20).setLabel("Display Controls");
  cp5.addButton("about").setValue(7).setPosition(700, height-40).setSize(80,20).setLabel("About This Project");
  
  //setup cp6 items for the data statistics page
  cp6.addButton("displayVidStat").setValue(8).setPosition(825, height-75).setSize(80,20).setLabel("Display Statistics");
  cp6.addSlider("videoNumber").setValue(1).setSize(width/4,10).setPosition(400,height-70).setRange(1,90).setLabel("");  
  
  //set cp5 to not draw the objects automatically
  cp5.setAutoDraw(false);
  
  //set cp6 to not autodraw automatically
  cp6.setAutoDraw(false);
  
  //make 3D environment
  size(1600,900,P3D);
  
  //load images into variables
  background = loadImage("background.jpg");
  fhLogo = loadImage ("logo.png");
  theHaus = loadImage("theHaus.jpg");
  hausLive = loadImage("funhausLive.png");
  
  //draw the background image
  image(background,0,0);
  
  //set custom song to play
  minim = new Minim(this);
  player = minim.loadFile("openHausTheme.mp3",2048);
  player.loop();
  
  //read in custom font
  PFont font;
  font = createFont("BebasNeue.otf",18);
  textFont (font);
  textSize(20);
  fill(0);
  textAlign(CENTER);
  
  //display start page message
  text("Note, it is recommended that you use a mouse with a middle click button, rather than a trackpad, for this program",width/2,100);
  
  //read in the dataset
  readInData();
  
  //create new camera
  camera = new PeasyCam(this, width/2, height/2 , 750, 50);  
  camActive = false;
  
}//end setup

//declare variables to be used to calculate averages, highest, lowest and standard deviations
float standardDev, highest, lowest, average;
int highestIndex, lowestIndex;

//declare variables to be used to draw Linegraph
float sourceXStart, sourceXEnd, sourceYStart, sourceYEnd;
float xIncrement, yIncrement, dayIncrement;
int menuPosition;

//variable used to determine which song should be playing 
int song=0;

//create camera
PeasyCam camera;

//start draw method
void draw(){
  
  //if 3d camera is active, draw the 3d graph --!May be redudant code!!!!
  if(camActive==true){
    draw3Dgraph();
    
  }//end 
  
  //if statsDisplay displayStats
  if(statsDisplay==true){
    displayStatistics();
    text(videoData, 150, 650);
    
  }//end statsDisplay if
  
  //draw the gui
  gui();
  
}//end draw

//gui function
void gui(){
  //create and draw the hud
  camera.beginHUD();
  cp5.draw();
  camera.endHUD();
  
}//end gui

void readInData(){
  
  //set up data related variables
  float standardDevValueHolder, total;
  total = 0;
  average=0;
  highest=-10000;
  lowest=10000;
  standardDev = 0;
  
  //read in the data  
  String[] lines = loadStrings("data.txt");
  for(int i = 0;i<lines.length;i++){
    
    //add objects into the array list based on the data 
    Video vid = new Video(lines[i]);
    videos.add(vid);
    
    //increment the total subscribers
    total+=vid.getSubscribers();
    
    //check if the value that was just read in is the lowest value in the list
    if(vid.getSubscribers()<lowest){
      lowest = vid.getSubscribers();
      lowestIndex = i;
      
    }//end if
    
    //check to see if the value that was just entered is the new highest value in the arrayList
    if(vid.getSubscribers()>highest){
      highest = vid.getSubscribers();
      highestIndex = i;
      
    }//end if
    
  }//end for
  
  //calculate the average
  average= total/videos.size();
  
  //for loop to read in numbers, subtract the mean and square them for the standard deviation
  for(int i = 0;i<videos.size();i++){
    Video vidTemp = videos.get(i);
    standardDevValueHolder = vidTemp.getSubscribers();
    standardDevValueHolder-=average;
    standardDevValueHolder*=standardDevValueHolder;
    standardDev+=standardDevValueHolder;
    
  }//end for
  
  //get the mean of the numbers
  standardDev= standardDev/videos.size();
  
  //square root for std. dev
  standardDev= sqrt(standardDev);  
  
}//end readInData

//function for drawing line graph
void drawLineGraph(){
  
  //disable the statistics page
  statsDisplay = false;
  //disable the 3d camera
  camActive=false;
  camera.reset(1);
  
  //reset the background
  background(233,233,231);
  
  //initialize variables used for placing the graph
  sourceXStart = 250;
  sourceXEnd = width-100;
  sourceYStart = 100;
  sourceYEnd = height-100;
  xIncrement = (sourceXEnd-sourceXStart)/15;
  yIncrement = (sourceYEnd-sourceYStart)/15;
  dayIncrement = 90/15;
  
  //place the funhaus logo
  image(fhLogo, 0,0);
  
  //write the title out
  textSize(18);
  fill(0);
  textAlign(CENTER);
  text("Funhaus Subscriber\nIncrease\n31-07-15 ->28/10/15\nPeriod of 90 days", 100,220);
  float balance = xIncrement/6;
  stroke(0);
  
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
      stroke(100);
      line(i-balance,sourceYStart,i-balance, sourceYEnd-5);
      text(int(loopVal*dayIncrement) , i-balance, sourceYEnd+20);
      
    }//end else 
    loopVal+=1;
    
  }//end for
  
  stroke(0);
  //y axis notches
  loopVal = 0;
  for(float i=sourceYEnd; i>sourceYStart-1; i-=yIncrement){
    line(sourceXStart-5, i, sourceXStart+5, i);
    text(200*loopVal,sourceXStart-25,i);
    loopVal+=1;
  
  }//end for
  
  //Draw lines
  
  //code for printing the average line
  int prevPoint;
  float xSegment= (sourceXEnd-sourceXStart)/videos.size();
  float yAveragePoint = getYPoint(average);
  stroke(255,0,0);
  line(sourceXStart, sourceYEnd- yAveragePoint, sourceXEnd-balance, sourceYEnd-yAveragePoint);
  textAlign(LEFT);
  text("Average Sub.\nGain Per Day\n(" + average + ")", sourceXEnd, sourceYEnd-yAveragePoint);
  
  //code for printing the standard deviaton line
  float standardDevPoint = getYPoint(standardDev);
  stroke(0,255,0);
  line(sourceXStart, sourceYEnd- standardDevPoint, sourceXEnd-balance, sourceYEnd-standardDevPoint);
  text("Standard Dev.\nof Subscriber\nGains\n(" + standardDev + ")", sourceXEnd, sourceYEnd-standardDevPoint);
  
  textAlign(CENTER);
  
  //code for printing the lines of the graph  
  for(int i=0;i<videos.size()-1;i++){
    float yPointCur;
    float yPointNext;
    
    //calculate current y point
    Video tempVideo = videos.get(i);
    float curSubVal = tempVideo.getSubscribers();
    yPointCur = getYPoint(curSubVal);
    
    //calculate the next y point
    Video nextVid = videos.get(i+1);
    float nextSubVal = nextVid.getSubscribers();
    yPointNext = getYPoint(nextSubVal);
    
    stroke(252,128,2);
    //draw the line between the points
    line(sourceXStart+(xSegment*i),sourceYEnd-(yPointCur), sourceXStart + (xSegment*(i+1)),sourceYEnd-(yPointNext));
    
  }//end for
  
  //display the titles
  text("Subscriber\nIncrease", 150,520);
  text("Days", width-(sourceXStart+sourceXEnd)/2, sourceYEnd+50);
  
}//end drawLineGraph

void draw3Dgraph(){
  statsDisplay = false;
  
  //activate the 3d camera
  camActive = true;
  
  //reset the background
  background(233,233,231);
  stroke(255);
  
  //begin matrix for drawing the 3D graph
  pushMatrix();
  //translate the graph so that it positions the central point of the graph in front of where the camera starts
  translate(-3800,1000,0);
  pushMatrix();
  stroke(0);
  
  for(int i=0;i<videos.size();i++){
    
    Video temp = videos.get(i);
    translate(100,0,0);
    
    if(i==0){
      textSize(150);
      textAlign(CENTER);
      
      fill(0);
      text("\nLength over " + videos.size() + " days",(100*videos.size())/2,100,75);
      textAlign(RIGHT);
      text("\nSubscribers\nGained",-400,-highest/2);
    }//end if
    
    fill(252,128,2);
    pushMatrix();
    translate(0,-temp.getSubscribers()/2,0);
    box(100,temp.getSubscribers(),100);
    fill(0);
    popMatrix();
    
  }//end for
  popMatrix();
  popMatrix();
  
}//end draw3DGraph

void changeSong(){
  song+=1;
  
  //load default funhaus theme song
  if(song%2==0){
    player.pause();
    player = minim.loadFile("openHausTheme.mp3",2048);
    player.loop();
  
  }//end if  
  
  //load funhaus impromptu dance music song
  else{
    player.pause();
    player = minim.loadFile("funhausDance.mp3",2048);
    player.loop();
    
  }//end else
  
}//end changeSong

//used to toggle between mute and playing
void muteMusic(){
  if(muteValue==0){
    player.pause();
    muteValue=1;
  }//end if
  
  else{
    player.loop();
    muteValue=0;
  }//end else
  
}//end muteMusic

void controls(){
  statsDisplay = false;
  camActive=false;
  camera.reset(0);
  background = loadImage("background.jpg");
  background(233,233,231);
  image(background,0,0);
  

  textSize(32);
  fill(0);
  textAlign(LEFT);
  text("--3D Camera Controls for 3D Bar Chart--\n- Hold Left Click + Mouse : Look around\n- Hold Right Click and Mouse to zoom\n- Hold Middle Click and mouse to pan across the graph\n- Double Left Click - Reset Camera to default position\n\nIf a page looks distorted, click on the graphs menu icon twice and it should appear normally", 100,100);
}//end controls

void about(){
  
  //disable booleans
  statsDisplay = false;
  camActive = false;
  
  //reset camera and page
  camera.reset(0);
  background(233,233,231);
  
  //change textSize for title
  textSize(32);
  fill(0);
  textAlign(CENTER);
  text("About the Funhaus Graph", width/2, 100);
  
  //print out about info and picture
  textSize(18);
  textAlign(LEFT);
  text("This graph is designed to show daily subscriber growth for the youtube channel: \"Funhaus\"\nFunhaus are self described as: \"A bunch of dudes who play games. Does that mean we\n only play games? No - we've also got podcasts and fan Q's&A's\n...about games.\"\n\nThey are made up of (from left to right): \n- Sean 'Spoole' Poole\n- Laurence Sonntag\n- Matt Peake\n- Joel Rubin\n- Adam Kovic\n- James Willems\n- Bruce Greene\n\nThis graph details their subscriber gain over the course of 90 days\nin the form of a line graph and a 3D bar chart", 200, 300);
  image(theHaus,width/2,height/3);
  
}//end about

void displayStatistics(){
  
  //set stats display to true to allow for cp6 items to work properly
  statsDisplay = true;
  
  //disable 3d camera
  camActive = false;
  
  //reset page
  camera.reset(0);
  background(233,233,231);
  
  //set text options for title
  textSize(40);
  fill(0);
  textAlign(CENTER);
  text("Graph Statistics", width/2, 100);
  
  //set text options for page info
  textSize(20);
  textAlign(LEFT);
  Video highTemp = videos.get(highestIndex);
  Video lowestTemp = videos.get(lowestIndex);
  text("Highest Subscriber Growth:" +highTemp.toString() + "\n\nLowest Subscriber Growth:" + lowestTemp.toString() + "\n\nAverage Subscriber Growth: " + average + "\n\nStandard Deviation of Subscriber Growth: " + standardDev, 150, 300);
  
  //setup option print data depending on day
  text("See data for video released on day: ",150 , height-60);
  cp6.draw();
  image(hausLive, width/2, height/4);
  
}//end displayStatistics

//custom function to map data on the y axis
float getYPoint(float value){
  int multTwoHun=0;
  float yLine = value;
  float yPoint=value;
  //draw average line
  while(yLine>200){
    yLine-=200;
    multTwoHun+=1;
    
  }//end while
  yLine=(yLine/200)*yIncrement;
  yPoint=yIncrement*multTwoHun + yLine;
  
  return yPoint;
  
}//end getYPoints

//controlEvent to handle events
void controlEvent(ControlEvent theEvent){
  
  //if the event is for displayVidStat button
  if(theEvent.controller().getName()=="displayVidStat"){
    int value = ceil(cp6.getController("videoNumber").getValue()-1);
    
    //set program to output data based on the slider
    Video vidTemp = videos.get(value);
    videoData = vidTemp.toString();
    
  }//end if   
  
}//end controlEvent

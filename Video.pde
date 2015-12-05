class Video{
  
  float subscribers;
  String vidTitle;
  String vidCategory;
  String vidAirDate;
  
  private Video(String line){
    String[] parts= line.split("\t");
    subscribers=float(parts[0]);
    vidTitle = parts[1];
    vidCategory= parts[2];
    vidAirDate=parts[3];
    
    
  }//end constructor
  
  float getSubscribers(){
    return subscribers;
    
  }//end getSubscribers
  
  String getVidTitle(){
    return vidTitle;
    
  }//end getVidTitle
  
  String getVidCategory(){
    return vidCategory;
    
  }//end getVidCategory
  
  String getVidAirDate(){
    return vidAirDate;
    
  }//end getVidAirDate
  
  String toString(){
    return "\nSubscribers Gained on Video Release: " + subscribers + "\nVideo Title: " + vidTitle + "\nVideo Category: " + vidCategory + "\nAir Date: " + vidAirDate;
    
  }//end toString
  
  
}//end class video

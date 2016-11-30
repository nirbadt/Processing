ArrayList<PVector> stars = new ArrayList<PVector>();
import processing.video.*;
import processing.serial.*;
Capture cam;
PImage img;
Serial myPort;
float value;
int val;
int cellsize = 4; // Dimensions of each cell in the grid
int cols, rows;   // Number of columns and rows in our system

void setup()
{
  size(640, 340, P3D);
  cols = width/cellsize;
  rows = height/cellsize;
  
  img = createImage(width, height, RGB);
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0){
    println("no cameras available");
    exit();
  } else {
    println("cameras available:");
    for (int i = 0; i<cameras.length; i++){
      println(cameras[i]);
    }
    
    cam = new Capture(this, cameras[3]);
    cam.start();
  }
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
}

void draw()
{
  if (cam.available() == true){   
    img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
    img.updatePixels();
    cam.read();
  }
  
  loadPixels();
  cam.loadPixels();
  img.loadPixels();
  int val=int(value);
  for ( int i = 0; i < cols;i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows;j++) {
      int x = i*cellsize + cellsize/2; // x position
      int y = j*cellsize + cellsize/2; // y position
      int loc = x + y*width;           // Pixel array location
      color c = img.pixels[loc];       // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (value/(float)width) * brightness(img.pixels[loc]) - 100.0;
      //float z = random(1, 100);
      
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x,y,z);
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0,0,cellsize,cellsize);
      popMatrix();
      
    }
  }  
  
}
void serialEvent(Serial p) {
  // get message till line break (ASCII > 13)
  String message = myPort.readStringUntil(13);
  if(message != null){
    value = float(message);
    /*print(mouseX);
    print(" , ");
    println(mouseY);
    */
    
  }
  println(value);
}
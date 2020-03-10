Solar_system ss;
Spaceship ship;
float rotation = 0;
float rotation_speed = 0.001;
PImage bg;
String view = "general"; // [general/1st_person]

void setup() {
  size(800,600, P3D);
  ss = new Solar_system();
  ship = new Spaceship();
  bg = loadImage("resources/Space.jpg");
  bg.resize(800,600);
}
  
void draw() {
  //BACKGROUND
  background(bg);
  
  if (view == "general") {
    //MODEL TRANSFORMATIONS
    translate(width/2, height/2);
    rotateX(-0.5);
      
    //MODEL ROTATION
    rotateY(rotation);
    rotation = (rotation + rotation_speed) % TWO_PI;
  }
  else { //view == 1st_person
    //SPHERIAL TO CARTESIAN http://tutorial.math.lamar.edu/Classes/CalcIII/SphericalCoords.aspx
    //eye coordinates
    float x = ship.r * sin(ship.rotation) * cos(ship.slope);
    float y = ship.r * sin(ship.rotation) * sin(ship.slope);
    float z = ship.r * cos(ship.rotation);
    
    //center coordinates
    float cx = ship.r * sin(ship.rotation + PI/4 + ship.look_vertical) * cos(ship.slope + ship.look_horizontal);
    float cy = ship.r * sin(ship.rotation + PI/4 + ship.look_vertical) * sin(ship.slope + ship.look_horizontal);
    float cz = ship.r * cos(ship.rotation + PI/4 + ship.look_vertical);
  
    camera(x,y,z,cx,cy,cz,0,1,0);  
  }
  
    
  //SENSORS
  readMouse();
  //keyPressed independent from loop
  
  //MECHANIC ELEMENTS
  ss.move();
  ss.display();
  
  ship.move();
  ship.display();  
}

void keyPressed() {
  if (key == 'Z' || key =='z') {
    view = view == "1st_person" ? "general" : "1st_person";
  }
  else if (key == CODED) {
    if (keyCode == UP) {
      ship.change_position("horizontal", true);
    } 
    else
    {
      if (keyCode == DOWN) {
        ship.change_position("horizontal", false);
        
      }
      else
      {
        if (keyCode == LEFT) {
          ship.change_position("vertical", false);  
        } 
        else
        {
          if (keyCode == RIGHT) {
            ship.change_position("vertical", true);
          } 
        }
      }
    }
  } 
}

void readMouse() {
  ship.change_look("horizontal", mouseX);
  ship.change_look("vertical", mouseY);
}

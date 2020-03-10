class Spaceship {
  
  float rotation;
  float rotation_speed;
  float r;
  float r_change;
  float slope;
  float slope_change;
  boolean clockwise;
  float look_vertical;
  float look_horizontal;
  float look_change;
  
  public Spaceship() {
    rotation = 0;
    rotation_speed = 0.02;
    r = 150;
    r_change = 10;
    slope = 0;
    slope_change = 0.1;
    clockwise = true;
    look_vertical = 0;
    look_horizontal = 0;
    look_change = 0.5;
  }
  
  public void move() {
    rotation = (rotation + rotation_speed) % TWO_PI;
  }
  
  public void display() {
    pushMatrix();    
    rotateX(slope);
    rotateY(rotation);
    translate(r,0);
    fill(200,0,0);
    sphere(20);
    popMatrix();
  }
  
  // mode [horizontal/vertical], value of the mouse position
  public void change_look(String mode, float value) {
    if (mode == "horizontal")
      look_horizontal = map(value, 0, width, -PI/2, PI/2);  
    else
      look_vertical = map(value, 0, height, -PI/2, PI/2);  
  }
  
  // mode [horizontal/vertical], positive true if value added, ie. movement to the right/up   
  public void change_position(String mode, boolean positive) {
    if (mode == "horizontal") {
      float new_r = r;
      new_r += positive ? r_change : -r_change;
      if (new_r < 300 && new_r > 110) r = new_r;
    }
    else {
      slope += positive ? slope_change : -slope_change;
      slope %= TWO_PI;
    }
  }
  
  
}


 

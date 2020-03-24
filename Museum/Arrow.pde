class Arrow {
  
  float a=8, b=20, c=30, d=50;
  PShape arrow;
  Player player;
  color white = color(255,255,255,255);
  color red = color(255,150,150,0);
  color dark = color(0,255,0,0);
  int false_click_timer = 0, false_click = 30; // timer after unallowed direction clicked 
  
  public Arrow(Player player) {
    this.player = player;
    arrow = createShape();
    arrow.scale(0.4);
    arrow.rotateY(-PI/2);
    arrow.setStroke(false);
    arrow.setFill(white);
    arrow.beginShape();
    arrow.vertex(a,0,0);
    arrow.vertex(a,0,c);
    arrow.vertex(b,0,c);
    arrow.vertex(0,0,d);
    arrow.vertex(-b,0,c);
    arrow.vertex(-a,0,c);
    arrow.vertex(-a,0,0);
    arrow.endShape();   
  }
  
  public void display() {
    if (player.can_move()) {
      arrow.setFill(white);
    } else if (false_click_timer != 0) {
      false_click_timer--;
      arrow.setFill(red);
    } else {
      arrow.setFill(dark);
    }    
    drawArrow();
  }
  
  private void drawArrow() {
    float lookX = map(mouseX, 0, width, -PI, PI);
    float r = 150;
    float x = r * sin(PI/2) * cos(lookX);
    float z = r * sin(PI/2) * sin(lookX);
    
    pushMatrix();
    translate(player.x + x, -30, player.z + z);
    float div = (mouseX + width/8) / (width /4);
    rotateY(-div * PI/2);
    shape(arrow);
    popMatrix();
  }
  
  public void set_false_click() {
    false_click_timer = false_click;
  }
  
  public void cancel_false_click() {
    false_click_timer = 0;
  }
}

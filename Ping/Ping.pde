/*
version 2 using separate drawing areas PGraphics
displayed texts: cooltext.com, Neon Text Generator
sound effects: Douglas Vicente, License: Attribution 3.0, http://soundbible.com/1750-Hitting-Metal.html

Author: Anna Zawadzka
*/

//AREAS
PGraphics menu_bar;
PGraphics table;
PGraphics end_screen;

//ELEMENTS
Ball ball;
RacketA rA;
RacketB rB;

//SIZES OF SCREEN ELEMENTS
int w = 600, h = 470; //table
int bar_h = 30;

//GAME FLOW
int max_dead = 5;
int time1 = 40, time2 = 20;
int count = 0;
boolean player_A_starts = true;
boolean game_on = false;
boolean game_over = false;

//COLORS GLOBAL VARIABLES
color theme_bg = color(20,20,20,255);
color theme_1 = color(255,255,255,255);
color theme_2 = color(255,165,0,255);
color red = color(255,0,0,255);
color ball_col = theme_1;
color current_ball_col = ball_col; //changes to red when lose
color dead_col = theme_2;
color racket_col = theme_1;
color bg_col = theme_bg;
color bar_col = theme_bg;
color line_col = theme_2;
color net_col = theme_1;

void setup() {
  noCursor();
  size(600, 500);
  
  menu_bar = createGraphics(w,bar_h);
  table = createGraphics(w,h);
  end_screen = createGraphics(w,h);
 
  ball = new Ball(table, player_A_starts);
  rA = new RacketA(table);
  rB = new RacketB(table);
  ball.addCollision(rA);
  ball.addCollision(rB);
}

void draw() {
  if (game_over) delay(1000000); 
  
  if (count > 0) { //one player has died, entering special flow
    rA.move();
    rB.move();
    if (count > time2) {
      ball.move();
    }
    if (count == 1) { // ball reseted
      game_over = checkGameOver();
      player_A_starts = !player_A_starts;
      ball = new Ball(table, player_A_starts);
      ball.addCollision(rA);
      ball.addCollision(rB);
    }
    count--;
  } else if (!game_on) {
    rA.move();
    rB.move();
    if (ball.hasBeenHit()) game_on = true;
  } else { // normal flow
    rA.move();
    rB.move();
    ball.move();
    if (ball.hasDead()) {
      count = time1;
      game_on = false;
    }
  }
    
  draw_menu_bar();
  draw_table();
  
  ball.paint();
  rA.paint();
  rB.paint();
  
  //paint areas
  image(menu_bar,0,0);
  image(table,0,bar_h);
  image(end_screen,0,bar_h);
}

void draw_table() {
  int space = 30;
  int middle = table.width / 2;
  table.beginDraw();
  table.background(bg_col);
  table.stroke(theme_2);
  for (int i = space; i < table.height - space; i += 8) {
    table.line(middle-2, i-2, middle+2, i+2);
    table.line(middle+2, i-2, middle-2, i+2);
  }
  table.stroke(theme_1);
  for (int i = 3; i < h - 3; i += 6) {
    table.line(Racket.line_offset, i, Racket.line_offset, i+1);
    table.line(table.width - Racket.line_offset, i, table.width - Racket.line_offset, i+1);
  }
  table.endDraw();
}

void draw_menu_bar() {
  menu_bar.beginDraw();
  menu_bar.noStroke();
  menu_bar.fill(bar_col);
  menu_bar.rect(0,0, w,bar_h);
  menu_bar.stroke(line_col);
  menu_bar.line(0, menu_bar.height-1, w, menu_bar.height-1);
  menu_bar.fill(theme_1);
  menu_bar.noStroke();
  if (player_A_starts) menu_bar.triangle(0,4,0,menu_bar.height-4,12,menu_bar.height/2);
  else menu_bar.triangle(menu_bar.width,4,menu_bar.width,menu_bar.height-4,menu_bar.width-12,menu_bar.height/2);
  int space = 10;
  int ball_size = 20;
  for (int i=1; i<=max_dead; i++) {
    if (i <= rA.getLives()) { 
      menu_bar.noStroke();
      menu_bar.fill(dead_col);
      menu_bar.ellipse(i * (space + ball_size), menu_bar.height / 2, ball_size, ball_size);
    } else {
      menu_bar.stroke(dead_col);
      menu_bar.noFill();
      menu_bar.ellipse(i * (space + ball_size), menu_bar.height / 2, ball_size, ball_size);
    }
    if (i <= rB.getLives()) { 
      menu_bar.noStroke();
      menu_bar.fill(dead_col);
      menu_bar.ellipse(menu_bar.width - i * (space + ball_size), menu_bar.height / 2, ball_size, ball_size);
    } else {
      menu_bar.stroke(dead_col);
      menu_bar.noFill();
      menu_bar.ellipse(menu_bar.width - i * (space + ball_size), menu_bar.height / 2, ball_size, ball_size); 
    }
  }
  menu_bar.endDraw();
}

boolean checkGameOver() {
  if (rA.getLives() == 0) {
    displayGameOver('a');
    return true;
  }
  else if (rB.getLives() == 0) {
    displayGameOver('b');
    return true;
  }
  return false;
}

void displayGameOver(char c) {
  end_screen.beginDraw();
  PImage img_game_over = loadImage("resources/gameover.png");
  String loser = c == 'a' ? "resources/B.png" : "resources/A.png"; 
  PImage img_loser = loadImage(loser);
  end_screen.image(img_game_over, end_screen.width / 2 - img_game_over.width / 2, 100);
  end_screen.image(img_loser, end_screen.width / 2 - img_loser.width / 2, 250);
  end_screen.endDraw();
}

class Ball {
  private PGraphics t;
  private ArrayList<Racket> collisions;
  
  private int x, y; //position of ball
  private int dx, dy; //change in ball position per frame
  private color col;
  
  public static final int init_offset = 100;
  public static final int size = 20, half_size = size / 2;
  
  public Ball(PGraphics table, boolean side) {
    this.t = table;
    collisions = new ArrayList();
    this.x = side ? init_offset : t.width - init_offset;
    this.y = table.height / 2;
    this.dx = int(random(3,6)); 
    this.dx = side ? this.dx : -this.dx;
    this.dy = int(random(3,6));
    this.col = ball_col;
  }
  
  public void addCollision(Racket r) {
    this.collisions.add(r);
  }
  
  public void paint() {
    t.beginDraw();
    t.noStroke();
    t.fill(col);
    t.ellipse(x, y, size, size);
    t.endDraw();
  }
  
  public boolean hasDead() {
    for (Racket r : collisions) {
      if (r.dead(x)) { //<>//
        col = red;
        return true;
      }
    }
    return false;
  }
  
  public boolean hasBeenHit() {
    for (Racket r : collisions) {
      if (ballOnRacketHorizontal(r.y()) && (ballOnRacketVertical(r.x()))) {
        return true;
      }
    }
    return false;
  }
  
  public void move() {       
    x += dx;
    y += dy;
      
    if (x > t.width - half_size) {
      x = 2 * t.width - 2 * half_size - x;
      reverseHorizontal();
    }
    if (x < 0 + half_size) {
      x = 2 * half_size - x;
      reverseHorizontal();
    }
    if (y > t.height - half_size) {
      y  = 2 * t.height - 2 * half_size - y;
      reverseVertical();
    }
    if (y < 0 + half_size) {
      y = 2 * half_size - y;
      reverseVertical();
    }
    
    for (Racket r : collisions) {
      reactCollision(r);
    }
  }
  
  private void reactCollision(Racket r) {
    if (ballOnRacketHorizontal(r.y()) && (ballOnRacketVertical(r.x()))) { 
      if ((x - r.x()) * dx < 0) { //only hit if the direction is different  
        reverseHorizontal();
      } else {
        x += r.x() - r.prev_x();
        y += r.y() - r.prev_y();
        if (y <= half_size) y = half_size + 1;
        if (y >= t.height - half_size) y = t.height - half_size - 1;
      }
    }
  }
  
  private void reverseVertical() { dy *= -1; }
  
  private void reverseHorizontal() { dx *= -1; }
  
  private boolean ballOnRacketVertical(int racket_x) { 
    return x > racket_x - half_size && x < racket_x + Racket.racket_w + half_size; 
  }
  
  private boolean ballOnRacketHorizontal(int racket_y) { 
    return y > racket_y - half_size && y < racket_y  + Racket.racket_h + half_size; 
  }
}


abstract class Racket {
  protected PGraphics t;
  protected int x, y, prev_x, prev_y;
  protected int lives = max_dead;
  protected int correction = 3;
  public static final int player_offset = 60;
  public static final int line_offset = 30;
  public static final int racket_w = 10, racket_h = 60; //in vertical position
  
  public Racket(PGraphics table) {
    this.t = table;
  }
  
  public abstract void move();
  public abstract boolean dead(int ball_x);
  
  public void paint() {
    t.beginDraw();
    t.noStroke();
    t.fill(racket_col);
    t.rect(x, y, racket_w, racket_h);
    t.endDraw();
  }
  
  public int getLives() { return lives; }  
  public int x() { return x; }
  public int y() { return y; }
  public int prev_x() { return prev_x; }
  public int prev_y() { return prev_y; }
}

class RacketA extends Racket {
  
  public RacketA(PGraphics table) {
    super(table);
    this.x = player_offset;
    this.y = t.height / 2 - Racket.racket_h / 2;
  }
  
  public void move() {
    prev_x = x;
    prev_y = y;
    
    x = mouseX;
    if (x > t.width / 2 - racket_w / 2) x = t.width / 2 - racket_w / 2 - 2*correction;
    y = mouseY;
    if (y > t.height - racket_h) y = t.height - racket_h; 
  }
  
  public boolean dead(int ball_x) {
    if (ball_x <= line_offset) {
      lives--;
      return true;
    }
    return false;
  }
}

class RacketB extends Racket {
  
  private int dx = 8, dy = 8; //change in position in each frame
  private boolean keys[];
  
  public RacketB(PGraphics table) {
    super(table);
    this.x = t.width - Racket.player_offset;
    this.y = t.height / 2 - Racket.racket_h / 2;
    keys = new boolean[]{false,false,false,false}; 
  }
  
  public void move() {
    prev_x = x;
    prev_y = y;
    
    if (keys[0]) {
      y -= dy;
      if (y < 0) y = 0;
    }
    if (keys[1]) {
      y += dy;
      if (y > t.height - racket_h) y = t.height - racket_h;
    }
    if (keys[2]) {
      x -= dx;
      if (x < t.width/2 + correction) x = t.width / 2 + correction; 
    }
    if (keys[3]) {
      x += dx;
      if (x > t.width - racket_w) x = t.width - racket_w;
    }
  }  
  
  public boolean dead(int ball_x) {
    if (ball_x >= t.width - line_offset) {
      lives--;
      return true;
    }
    return false;
  }
  
  public void keyPressed() {
    if (key == CODED) {
      if (keyCode == UP) keys[0] = true;
      else if (keyCode == DOWN) keys[1] = true;
      else if (keyCode == LEFT) keys[2] = true;
      else if (keyCode == RIGHT) keys[3] = true;
    }
  }
  
  public void keyReleased() {
    if (key == CODED) {
      if (keyCode == UP) keys[0] = false;
      else if (keyCode == DOWN) keys[1] = false;
      else if (keyCode == LEFT) keys[2] = false;
      else if (keyCode == RIGHT) keys[3] = false; 
    }
  } //<>// //<>//
}

// GLOBAL FUNCTIONS ALLOW KEYBOARD STEERING INSIDE OBJECTS
void keyPressed() {
  rB.keyPressed();
}

void keyReleased() {
  rB.keyReleased();
}

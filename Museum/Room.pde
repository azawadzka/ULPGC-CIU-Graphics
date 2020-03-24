class Room {
  
  Board board;
  
  PShape floor;
  PImage tex_floor, tex_wall, tex_ceiling;
  
  float tile = 150; 
  float b; // board size
  float p; // floor texture proportion
  float h = -500; 
  
  public Room(Board board) {
    this.board = board;
    this.b = board.size * tile;
    this.p = board.size;
    
    tex_floor = loadImage("resources/floor.jpg");
    tex_wall = loadImage("resources/wall.jpg");
    tex_ceiling = loadImage("resources/wall.jpg");
  }
  
  public void display() {
    display_floor();
    display_walls();
    display_ceiling();
    display_figures();
  }
  
  private void display_floor() {
    // PShape doesn't support texture wrap
    beginShape();
    vertex(0,0,0,0,0);
    vertex(0,0,b,0,p);
    vertex(b,0,b,p,p);
    vertex(b,0,0,p,0);
    texture(tex_floor);
    textureWrap(REPEAT);
    endShape(); 
  }
  
  private void display_ceiling() {
    // PShape doesn't support texture wrap
    beginShape();
    vertex(0,h,0,0,0);
    vertex(0,h,b,0,p);
    vertex(b,h,b,p,p);
    vertex(b,h,0,p,0);
    texture(tex_ceiling);
    textureWrap(REPEAT);
    endShape(); 
  }
  
  private void display_walls() {
    beginShape();
    vertex(0,0,0,0,0);
    vertex(0,h,0,0,1);
    vertex(b,h,0,p,1);
    vertex(b,0,0,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
    
    beginShape();
    vertex(b,0,0,0,0);
    vertex(b,h,0,0,1);
    vertex(b,h,b,p,1);
    vertex(b,0,b,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
    
    beginShape();
    vertex(b,0,b,0,0);
    vertex(b,h,b,0,1);
    vertex(0,h,b,p,1);
    vertex(0,0,b,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
    
    beginShape();
    vertex(0,0,b,0,0);
    vertex(0,h,b,0,1);
    vertex(0,h,0,p,1);
    vertex(0,0,0,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
  }
  
  private void display_figures() {
    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.board[i][j] != null) {
          pushMatrix();
          translate(i * tile + tile/2, 0, j * tile + tile/2);
          shape(board.board[i][j]);
          popMatrix();
        }
      }
    }
  }
  
  
}

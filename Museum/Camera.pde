class Camera {
  
  Player player;
  Room room;
  Board board;
  float view_height, tile;
  float view_length = 10000;
  
  public Camera(Player player) {
    this.player = player;
    this.room = player.room;
    this.board = room.board;
    this.view_height = -100;
    this.tile = room.tile;
  }
  
  public void cam() {
    
    float lookX = map(mouseX, 0, width, -PI, PI); 
    
    float x = view_length * sin(PI/2) * cos(lookX);
    float z = view_length * sin(PI/2) * sin(lookX);
    
    camera(player.x,view_height,player.z,x,view_height,z,0,1,0);
  }
  
}

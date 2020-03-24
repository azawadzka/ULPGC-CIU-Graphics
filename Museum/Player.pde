class Player {
  
  Room room;
  Board board;
  
  float x, z;
  int p, r; //coordinates on the board
  int timer = 0, move_time = 30;
  int move_p = 0, move_r = 0;
  
  public Player(Room room) {
    this.room = room;
    this.board = room.board;
    this.x = room.tile/2;
    this.z = room.tile/2;
    this.p=0; 
    this.r=0;
  }
  
  public boolean request_move() {
    int[] val = get_direction();
    if (can_move()) {
      p += val[0];
      r += val[1];
      move_p = val[0];
      move_r = val[1];
      timer = move_time;
      return true;
    }
    return false;
  }
  
  public boolean can_move() {
    int[] val = get_direction();
    return board.can_move(p + val[0], r + val[1]);
  }
  
  public boolean ready_to_move() {
    return timer == 0;
  }
  
  public void move() {
    if (timer != 0) {
      x += move_p * room.tile/move_time;
      z += move_r * room.tile/move_time;
      timer--;
    }    
  }
  
  public int[] get_direction() {
    float angle = map(mouseX, 0, width, -PI, PI);
    int mp, mr;
    if (angle < -PI*3/4 || angle > PI*3/4) {
        mp = -1;
        mr = 0;
    } else if (angle < -PI/4) {
        mp = 0;
        mr = -1;
    } else if (angle < PI/4) {
        mp = 1;
        mr = 0;
    } else {
        mp = 0;
        mr = 1;
    }
    return new int[] {mp, mr};
  }
}

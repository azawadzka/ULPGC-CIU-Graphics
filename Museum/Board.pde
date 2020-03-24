class Board {
  
  int size;
  PShape[][] board;
  
  public Board() {
    this.size = 8;
    board = new PShape[size][size];
    board[0][0] = new PShape(); // player initial
  }
  
  public boolean can_move(int p, int r) {
    if (p < 0 || p >= size) return false;
    if (r < 0 || r >= size) return false;
    if (board[p][r] != null) return false;
    return true;
  }
  
  public void allocate_random(PShape shape) {
    int p, r;
    do {
      p = int(random(8)); 
      r = int(random(8));
    }
    while (board[p][r] != null);
    board[p][r] = shape;
  }
  
}

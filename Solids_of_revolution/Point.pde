public class Point {
  public int x, y, z;
  
  public Point(int x, int y) {
    this.x = x;
    this.y = y;
    this.z = 0;
  }
  
  public Point(int x, int y, int z) {
    this.x = x ;
    this.y = y;
    this.z = z;
  }
  
  public boolean equals(Point p) {
    return this.x == p.x && this.y == p.y && this.z == p.z;
  }
  
  public void translateX() {
    x -= width/2;
  }
}

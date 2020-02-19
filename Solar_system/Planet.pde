class Planet {
  
  private int radius;
  private int distance;
  private String name;
  private float rotation = random(0, TWO_PI);
  private float rotation_speed;
  private float angle;
  ArrayList<Planet> moons;
  PShape shape;
  PImage texture;
  
  public Planet(String name, int radius, int distance, float rotation_speed, float angle, int nr_moons) {
    this.name = name;
    this.radius = radius;
    this.distance = distance;
    this.rotation_speed = rotation_speed;
    this.angle = angle;
    
    texture = loadImage("resources/" + name + ".jpg");
    
    shape = createShape(SPHERE, radius);
    shape.setTexture(texture);
    shape.setStroke(false);
    
    moons = new ArrayList();
    for (int i = 0; i < nr_moons; i++) {
      moons.add(new Planet("Moon", (int)random(3,7), radius+(int)random(10,20), random(-0.05,0.05), random(-2,2), 0));
    }
  }
  
  public void display() {
    pushMatrix();
    rotateX(angle);
    rotateY(rotation);
    rotation = (rotation + rotation_speed) % TWO_PI;
    translate(distance,0);
    shape(shape);
    
    //display moons
    for (Planet m : moons) {
      pushMatrix();
      m.display();
      popMatrix();
    } 
    popMatrix();
  }
}

/*
Photo by Aperture Vintage on Unsplash
Planet textures source: https://www.solarsystemscope.com/textures/, license: Attribution 4.0
*/

class Solar_system {
  
  ArrayList<Planet> planets;
    
  public Solar_system() {
    planets = new ArrayList();
    planets.add(new Planet("Sun", 100, 0, 0.0, 0.0, 0));
    planets.add(new Planet("Mercury", 10, 160, 0.02, -0.5, 0));
    planets.add(new Planet("Venus", 15, 180, 0.012, 0.6, 0));
    planets.add(new Planet("Earth", 20, 200, 0.015, 0.1, 1));
    planets.add(new Planet("Mars", 15, 220, 0.01, 0.25, 1));
    planets.add(new Planet("Jupyter", 35, 270, 0.005, -0.3, 2));
    planets.add(new Planet("Saturn", 30, 300, 0.005, 0.2, 2));
    planets.add(new Planet("Uranus", 15, 350, 0.01, -0.4, 1));
    planets.add(new Planet("Neptune", 15, 370, 0.015, 0.15, 0));
  }
  
  void move() {
    //MOVE PLANETS
    for (Planet p : planets) {
      p.move();
    } 
  }
  
  void display() {    
    //DRAW PLANETS
    for (Planet p : planets) {
      p.display();
    } 
  }
}

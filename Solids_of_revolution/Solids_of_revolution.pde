final int NR_SEGMENTS = 10;

PShape pointer;
PShape pointer_dot;
PShape outline;
PShape outline_points;
PShape solid;
ArrayList<Point> list;

String stage = "draw"; // possible stages: draw/display

void setup() {
  size(800, 600, P3D);
  noCursor();
  list = new ArrayList();
  
  createPointer();
}

void draw() {
  drawBackground();
  if (stage == "draw") {
    createOutline();
    drawOutline();
    drawPointer();
  } else if (stage == "display") {
    createSolid();
    drawSolid();
  }
}

void drawBackground() {
  background(50);
  stroke(150);
  if (stage == "draw") line(width/2, 0, width/2, height);
  stroke(100);
  text("[Esc] to exit", 10,20);
  text("[Enter] to start new", 10,40);
}

void drawPointer() {
  translate(mouseX, mouseY);
  shape(pointer_dot);
  translate(mouseX < width/2 ? width/2 - mouseX : 0, 0);
  shape(pointer);
}

void createPointer() {
  pointer = createShape();
  pointer.beginShape(LINES);
  pointer.stroke(200);
  pointer.vertex(0, 13);
  pointer.vertex(11, 13);
  pointer.vertex(15, 13);
  pointer.vertex(26, 13);
  pointer.vertex(13, 0);
  pointer.vertex(13, 11);
  pointer.vertex(13, 15);
  pointer.vertex(13, 26);
  pointer.translate(-13,-13);
  pointer.endShape();
  
  pointer_dot = createShape();
  pointer_dot.beginShape(POINTS);
  pointer_dot.stroke(255, 250, 0);
  pointer_dot.strokeWeight(3);
  pointer_dot.vertex(0,0);
  pointer_dot.endShape();
}

void createOutline() {
  outline_points = createShape();
  outline_points.beginShape(POINTS);
  outline_points.stroke(255, 255, 255);
  outline_points.strokeWeight(3);
  
  outline = createShape();
  outline.beginShape();
  outline.noFill();
  outline.stroke(255, 255, 255);
  outline.strokeWeight(1);
  
  for (Point p : list) {
    outline_points.vertex(p.x, p.y);
    outline.vertex(p.x, p.y);
  }
  
  outline_points.endShape();
  outline.endShape();
}

void drawOutline() {
  shape(outline_points);
  shape(outline);
}

void createSolid() {
  ArrayList<Point> curr = list;
  ArrayList<Point> prev;
  
  solid = createShape();
  solid.beginShape(TRIANGLES);
  //solid.noFill();
  solid.fill(250);
  solid.stroke(255,0,0);
  solid.strokeWeight(1);
  
  float angle = TWO_PI / NR_SEGMENTS;
  float revolution = 0;
  // calculate the next set of rotated points and draw triis
  for (float i = 0; i < NR_SEGMENTS; i += 1) {
    revolution += angle;
    prev = curr;
    curr = new ArrayList();
    // apply matrix
    for (Point p : list) {
      curr.add(new Point(
        round(p.x * cos(revolution) - p.z * sin(revolution)), 
        p.y, 
        round(p.x * sin(revolution) + p.z * cos(revolution))));
    }
    
    // draw triis between two sets of rotated points
    for (int j = 0; j < curr.size() - 1; j++) {    
      //upper trii
      if (!curr.get(j).equals(prev.get(j))) {
        solid.vertex(prev.get(j).x, prev.get(j).y, prev.get(j).z);
        solid.vertex(curr.get(j).x, curr.get(j).y, curr.get(j).z);
        solid.vertex(prev.get(j+1).x, prev.get(j+1).y, prev.get(j+1).z);
      }
      //lower trii
      if (!curr.get(j+1).equals(prev.get(j+1))) {
        solid.stroke(255,0,0);
        solid.vertex(curr.get(j).x, curr.get(j).y, curr.get(j).z);
        solid.vertex(prev.get(j+1).x, prev.get(j+1).y, prev.get(j+1).z);
        solid.vertex(curr.get(j+1).x, curr.get(j+1).y, curr.get(j+1).z);
      }
    }
  }
  
  solid.translate(0,-height/2,0);
  solid.endShape();
}

void drawSolid() {
  translate(mouseX, mouseY);
  rotateY(PI/2);
  shape(solid);
}

void mouseClicked() {
  if (stage == "draw") {
    if (mouseButton == LEFT) {
      list.add(new Point(mouseX < width/2 ? width/2 : mouseX, mouseY));
    } else if (list.size() >= 3) {
      
      for (Point p : list) p.translateX();
      stage = "display";
    }
  }
}

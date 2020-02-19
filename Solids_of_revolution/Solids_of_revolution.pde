final int NR_SEGMENTS = 10;

PShape pointer;
PShape pointer_dot;
PShape outline;
PShape outline_points;
PShape solid;
PShape prev_solid;
ArrayList<Point> list;

String stage = "draw"; // possible stages: draw/display/previous/message_prev/message_no

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
    drawSolid(solid);
  } else if (stage == "previous") {
    drawSolid(prev_solid);
  } else if (stage == "message_no") {
    fill(155,0,0);
    text("No previous solid to show!", 10, 80);
  } else if (stage == "message_prev") {
    fill(155,0,0);
    text("Only one solid is stored in memory", 10, 80);
    drawSolid(prev_solid);
  }
}

void drawBackground() {
  background(50);
  stroke(150);
  if (stage == "draw") line(width/2, 0, width/2, height);
  fill(150);
  text("[N] to start new", 10,20);
  text("[P] to display previous solid", 10,40);
  text("[Esc] to exit", 10,60);
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
  solid.stroke(0,255,0);
  solid.strokeWeight(1);
  
  float angle = TWO_PI / NR_SEGMENTS;
  float revolution = 0;
  // calculate the next set of rotated points and draw triangles
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
    
    // draw triangles between two sets of rotated points
    for (int j = 0; j < curr.size() - 1; j++) {    
      //upper triangle
      if (!curr.get(j).equals(prev.get(j))) {
        solid.vertex(prev.get(j).x, prev.get(j).y, prev.get(j).z);
        solid.vertex(curr.get(j).x, curr.get(j).y, curr.get(j).z);
        solid.vertex(prev.get(j+1).x, prev.get(j+1).y, prev.get(j+1).z);
      }
      //lower triangle
      if (!curr.get(j+1).equals(prev.get(j+1))) {
        solid.vertex(curr.get(j).x, curr.get(j).y, curr.get(j).z);
        solid.vertex(prev.get(j+1).x, prev.get(j+1).y, prev.get(j+1).z);
        solid.vertex(curr.get(j+1).x, curr.get(j+1).y, curr.get(j+1).z);
      }
    }
  }
  
  solid.translate(0,-height/2,0);
  solid.endShape();
}

void drawSolid(PShape s) {
  translate(mouseX, mouseY);
  shape(s);
}

void mouseClicked() {
  if (stage == "draw") {
    if (mouseButton == LEFT) {
      list.add(new Point(mouseX < width/2 ? width/2 : mouseX, mouseY));
    } else if (list.size() >= 3) {
      for (Point p : list) p.translateX();
      createSolid();
      stage = "display";
    }
  }
}

void keyPressed() {
  if (key == 'p') {
    if (stage == "previous" || stage == "message_prev") 
      stage = "message_prev";
    else if (prev_solid == null) 
      stage = "message_no";
    else 
      stage = "previous";
  } else if (key == 'n') {
    restart();
    stage = "draw";
  }
}

void restart() {
  prev_solid = solid;
  solid = null;
  list = new ArrayList();
}

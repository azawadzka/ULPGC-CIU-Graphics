//https://free3d.com/3d-model/-archery-target-v1--937026.html
//https://free3d.com/3d-model/wooden-chair-541103.html
//https://free3d.com/3d-model/cinema4d-table-66762.html
//https://free3d.com/3d-model/gun-bot-78928.html

void createObjects() {
  noStroke();
  
  PImage tex_wood = loadImage("resources/wood.jpg");
  PImage tex_wood_dark = loadImage("resources/wood_dark.jpg");
  PImage tex_crate = loadImage("resources/crate.jpg");
  
  PShape obj1 = createShape(BOX, 100);
  obj1.translate(0,-50,0);
  obj1.setTexture(tex_wood_dark);
  board.allocate_random(obj1);
  
  PShape obj2 = createShape(BOX, 100);
  obj2.translate(0,-50,0);
  obj2.setTexture(tex_crate);
  board.allocate_random(obj2);
 
  PShape bot = loadShape("resources/bot.obj");
  bot.setSpecular(color(200, 190, 252));
  board.allocate_random(bot);
  
  PShape chair = loadShape("resources/chair.obj");
  chair.scale(2.5);
  chair.setTexture(tex_wood);
  board.allocate_random(chair);
  
  PShape chair2 = loadShape("resources/chair.obj");
  chair2.scale(2.5);
  chair2.rotateY(PI/2);
  chair2.setTexture(tex_wood);
  board.allocate_random(chair2);
  
  PShape table = loadShape("resources/table.obj");
  table.scale(0.7);
  table.setFill(color(54, 0, 0));
  board.allocate_random(table);
  
  PShape column1 = loadShape("resources/column1.obj");
  column1.setSpecular(color(78, 76, 78));
  board.allocate_random(column1);
  
  PShape column2 = loadShape("resources/column2.obj");
  column2.scale(2);
  column2.setSpecular(color(78, 76, 78));
  board.allocate_random(column2);
  
  PShape venus = loadShape("resources/venus82k.obj");
  venus.setFill(0xffffffff);
  venus.setShininess(10.0);
  venus.scale(1.5);
  board.allocate_random(venus);  
}

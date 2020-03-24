//https://www.myminifactory.com/object/3d-print-venus-aphrodite-is-the-goddess-of-love-she-was-depicted-in-the-nude-or-in-various-stages-of-nudity-and-painted-the-figure-is-executed-in-the-hellenistic-style-and-famed-for-its-sensuous-appearance-it-supposedly-lost-its-arms-in-a-struggle-arising-b-25162
//https://opengameart.org/

Board board;
Room room;
Player player;
Camera camera;
Torch torch;
Arrow arrow;

void setup() {
  size(1000,700, P3D);
  board = new Board();
  room = new Room(board);
  player = new Player(room);
  camera = new Camera(player);
  arrow = new Arrow(player);
  torch = new Torch(player);
  createObjects();
  smooth(8);
  //noCursor();
}

void draw() {  
  hint(ENABLE_DEPTH_TEST);
  lightFalloff(1.0, 0.001, 0.0);
  lightSpecular(100,100,100);
  directionalLight(1, 0, 0, 0, 1, 0);
  torch.light();
  camera.cam();
  player.move();
  room.display();
  
  hint(DISABLE_DEPTH_TEST);
  arrow.display();
}

void mouseClicked() {
  if (player.ready_to_move() && player.request_move()) {
    arrow.cancel_false_click();
  } else {
    arrow.set_false_click();
  } 
}

import cvimage.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.video.*;

Capture cam;
CVImage img, pimg, auximg;

int viewport_w = 640;
int viewport_h = 360;

FLuidSystem fluidsystem;

ArrayList<Point> pts;

public void settings() {
  size(viewport_w, viewport_h, P2D);
  smooth(4);
}

public void setup() {
  frameRate(60);
  pts = new ArrayList();
  
  //Camera
  cam = new Capture(this, viewport_w, viewport_h);
  cam.start(); 
  
  // OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  pimg = new CVImage(cam.width, cam.height);
  auximg = new CVImage(cam.width, cam.height);
    
  // PixelFlow
  DwPixelFlow context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  fluidsystem = new FLuidSystem(0, context, viewport_w, viewport_h, 1, img);
  fluidsystem.fluid.param.dissipation_velocity = 0.99f;
}
  

public void draw() {
  background(100);
  // mirror mode
  scale(-1,1);
  translate(-width,0);
  
  // Camera
  if (cam.available()) {
    cam.read();
    
    // Matrix operations
    
    // take the current and the previous frames in greyscale and find their difference
    img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, img.width, img.height);
    img.copyTo();
    Mat gris = img.getGrey();
    Mat pgris = pimg.getGrey();
    Core.absdiff(gris, pgris, gris);
    
    // hold the result as CVImage
    cpMat2CVImage(gris,auximg);
    
    // get distinctive points from the matrix of differences
    pts = getMovementPoints(gris);
    
    // hold current frame as previous 
    pimg.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
    pimg.copyTo();
    gris.release();
    
    // Fluid
    fluidsystem.setPosition(0, 0);
    fluidsystem.update();
    fluidsystem.display();  
  }
}


class FLuidSystem {
  
  CVImage backgroundImage;

  int IDX;
  int px = 0;
  int py = 0;
  
  int w, h, fluidgrid_scale;
  
  DwPixelFlow glscope;
  DwFluid2D fluid;
  MyFluidData cb_fluid_data;

  PGraphics2D pg_fluid;
  PGraphics2D pg_obstacles;
  
  FLuidSystem(int IDX, DwPixelFlow glscope, int w, int h, int fluidgrid_scale, CVImage backgroundImage){
    this.IDX = IDX;
    this.glscope = glscope;
    this.w = w;
    this.h = h;
    this.fluidgrid_scale = fluidgrid_scale;
    this.backgroundImage = backgroundImage;
   
    fluid = new DwFluid2D(glscope, w, h, fluidgrid_scale);
    
    fluid.param.dissipation_density     = 0.99f;
    fluid.param.dissipation_velocity    = 0.85f;
    fluid.param.dissipation_temperature = 0.99f;
    fluid.param.vorticity               = 0.00f;
    fluid.param.timestep                = 0.25f;
    fluid.param.num_jacobi_projection   = 80;
    
    fluid.addCallback_FluiData(new MyFluidData(this));

    pg_fluid = (PGraphics2D) createGraphics(w, h, P2D);
    pg_fluid.smooth(4);
    
    pg_obstacles = (PGraphics2D) createGraphics(w, h, P2D);
    pg_obstacles.smooth(4);
    pg_obstacles.beginDraw();
    pg_obstacles.clear();
    pg_obstacles.fill(64);
    pg_obstacles.noStroke();
    pg_obstacles.ellipse(w/2, 2*h/3f, 100, 100);
    pg_obstacles.endDraw();
  }
  
  void update() {
    fluid.addObstacles(pg_obstacles);
    fluid.update();

    pg_fluid.beginDraw();
//      pg_fluid.clear();
    pg_fluid.background(backgroundImage);
    pg_fluid.endDraw();
    
    fluid.renderFluidTextures(pg_fluid, 0);
  }

  public void setPosition(int px, int py){
    this.px = px;
    this.py = py;
  }

  public void display(){
    image(pg_fluid    , px, py);
    image(pg_obstacles, px, py);
  }
}


class MyFluidData implements DwFluid2D.FluidData{
  
  FLuidSystem system;
  
  MyFluidData(FLuidSystem system){
    this.system = system;
  }
  
  @Override
  // this is called during the fluid-simulation update step.
  public void update(DwFluid2D fluid) {

    float px, py, vx, vy, radius, vscale, temperature;

    int w = system.w;
    int h = system.h;
    
    if(system.IDX == 0){
      temperature = 0.5f;
      vscale = 15;
      px     = w/2-0;
      py     = 0;
      radius = h/6f;
      fluid.addDensity (px, py, radius, 1.0f, 0.0f, 0.40f, 1f, 1);
      radius = w/6f;
      fluid.addTemperature(px, py, radius, temperature);
    }
    
    if(system.IDX == 1){
      temperature = 1.5f;
      vscale = 15;
      px     = w/2-0;
      py     = 0;
      radius = h/6f;
      fluid.addDensity (px, py, radius, 0.0f, 0.4f, 1.00f, 1f, 1);
      radius = w/6f;
      fluid.addTemperature(px, py, radius, temperature);
    }
    
    // using the points extracted from the difference matrix as fluid stream interruptions
    vscale = 15;
    for (Point p : pts) {
      px = (float)p.x;
      py = height - (float)p.y;
      vx = 30 * +vscale * randomSign();
      vy = 0 * -vscale;
      
      // shift by relative position
      px -= system.px;
      py -= system.py;
      
      radius = 10;
      fluid.addVelocity(px, py, radius, vx, vy);
    }
  }
}

//Copia unsigned byte Mat a color CVImage
void  cpMat2CVImage(Mat in_mat,CVImage out_img)
{    
  byte[] data8 = new byte[cam.width*cam.height];
  
  out_img.loadPixels();
  in_mat.get(0, 0, data8);
  
  // Cada columna
  for (int x = 0; x < cam.width; x++) {
    // Cada fila
    for (int y = 0; y < cam.height; y++) {
      // Posición en el vector 1D
      int loc = x + y * cam.width;
      //Conversión del valor a unsigned basado en 
      //https://stackoverflow.com/questions/4266756/can-we-make-unsigned-byte-in-java
      int val = data8[loc] & 0xFF;
      //Copia a CVImage
      out_img.pixels[loc] = color(val);
    }
  }
  out_img.updatePixels();
}

ArrayList<Point> getMovementPoints(Mat img) {    
  int square_size = 10;
  int threshold = 50;
  Imgproc.threshold(img, img, threshold, 255, Imgproc.THRESH_BINARY);
  
  ArrayList<Point> points = new ArrayList();
  
  for (int x = 0; x < cam.width; x += square_size) {
    for (int y = 0; y < cam.height; y += square_size) {
      Mat submat = img.submat(new Rect(x, y, square_size, square_size));
      int sum = Core.countNonZero(submat);
      if (sum > square_size * square_size * 0.3) points.add(new Point(x + square_size/2, y + square_size/2));
    }
  }
  return points; 
}

public int randomSign() {
  return random(1) > .5 ? +1 : -1;
}

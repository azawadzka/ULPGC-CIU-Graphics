## Creating User Interfaces 
Universidad de Las Palmas de Gran Canaria, spring 2020<br>
Author: Anna Zawadzka<br>
Processing
---
### 7. Tuner
The gif shows pulling each string of a tuned guitar (EBGDAE).

<img src="/Tuner/imgs/v.gif" width="300"> <img src="/Tuner/imgs/p1.png" width="300">

The tuner selects the dominant wave frequency from input and compares it to note frequencies given in an external file. 
Then it displays the closest note and the distance [Hz] from the pure pitch.

Minim library for sound processing was used. 

The background range image and the hand of the tuner were made using GIMP. 
The data about note frequencies comes from [pages.mtu.edu/~suits/notefreqs.html](https://pages.mtu.edu/~suits/notefreqs.html) 
#### Code highlights:
Frequency input grabbing:
```java
in = minim.getLineIn(Minim.MONO, 4096, 44100);
fft = new FFT(in.left.size(), 44100);
```
Finding the dominant frequency:
```java
for(int i = 0; i < 20000; i++) {
    amplitude = fft.getFreq(i);
    if (amplitude > highestAmp){
       highestAmp = amplitude;
       frequency = i;
    }
} 
```
Finding the closest note:
```java
for (int i = 0; i < notes.length; i++) {
     if (abs(frequency - frequencies[i]) < abs(frequency - frequencies[maxIdx])) {
       maxIdx = i;
     }
}
```

Background: [Photo by bharath g s on Unsplash](https://unsplash.com/photos/aLGiPJ4XRO4)

### 6. Dust
<img src="/Dust/imgs/v.gif" width="300"><img src="/Dust/imgs/i.png" width="300"> 

A manipulation of live capture from the webcam. 
A stream of colorful dust is constantly pushed from the bottom of the view.
Movements within the area of the capture can influence the flow of the dust. 
  
Use of **OpenCV 4.0.0** (downloaded from an [external source]() and replacing the default OpenCV library), **system of particles** PixelFlow, **matrix calculations**.
#### Algorithm
[References to the code]

The algorithm takes two consecutive frames in greyscale and subtracts one from the other to get a matrix of differences [1].
Then it does thresholding [2] on that matrix. 
The matrix gets split in squares sized 10x10 pixels and the amount of white fields inside each area is summed [4].
If a square contains more than a certain percent of white fields, then it is qualified to push the fluid from its area, since a noticeable movement has been detected. 
The point in the middle of that square is further passed to the observing part of the particle system.
The particle system disperses the fluid in random horizontal direction from the collected points and constantly upwards [3].


#### Code
Parts of the code were adapted from the course material examples: 
[[1] Camera Difference](https://github.com/otsedom/CIU/blob/master/P6/p6_camdiff/p6_camdiff.pde)    
and [[2] Camera Threshold](https://github.com/otsedom/CIU/blob/master/P6/p6_camthreshold/p6_camthreshold.pde),
and the PixelFlow library example [[3] Fluid2D/Multiple Fluids](https://github.com/diwi/PixelFlow/blob/master/examples/Fluid2D/Fluid_MultipleFluids/Fluid_MultipleFluids.java).
The algorithm for the extraction of distinctive points from the matrix of differences between frames (function getMovementPoints) was written by me [4].

[gifs a completar] 

### 5. Museum
<img src="/Museum/imgs/v1.gif" width="300"> <img src="/Museum/imgs/p1.png" width="300">

Scene of a room full of simple objects and one valuable sculpture of Venus de Milo. The user may walk through the room to find the sculpture. The room is dark and the user can see objects pointing a torch at them.

The 3D objects were edited in Blender to reduce their computational complexity. The number of faces of the key object, Venus de Milo, was reduced from 274,000 to 82,000 (or 14,000 in case that is too power consuming -> requires minor change in code: change filename "venus82k" to "venus14k"). Other objects have up to 1000 faces. The figures were saved upside down due to inconsistency in axes turn (in graphics editors the Y axis increments upwards, while in Processing downwards). 

Steering:
- <b>horizontal</b> movement of mouse to <b>look around</b>
- <b>vertical</b> movement of mouse to <b>point the torch</b> in Y axis
- a <b>click</b> of mouse while pointing in certain direction causes <b>walking</b> in that direction, if possible (not blocked by an object or facing a wall). The player moves in two axes, as on a chessboard.
- the arrow shows the possible movement direction

The steering algorithm takes the mapping of mouse X position to one full circle that corresponds all possible views while looking around. Then the direction is decided basing on which slice of the circle is considered, as in the sketch:

<img src="/Museum/imgs/view.png">

The function get_direction() **converts** the mouse input (x position) that controls the **player rotation into** a pair of (mp,mr) values that represent the **change of position** (p,r) on the chessboard that the user can make given the input (as values {-1, 0, 1}): 
```java
// Player.pde
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
```
The function request_move() takes the desired change of position from the previous function and applies it if possible (ie. if there is no other object or wall in the desired position):
```java
// Player.pde
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
```
```java
// Player.pde
public boolean can_move() {
    int[] val = get_direction();
    return board.can_move(p + val[0], r + val[1]);
  }
```  
```java
// Board.pde
public boolean can_move(int p, int r) {
    if (p < 0 || p >= size) return false;
    if (r < 0 || r >= size) return false;
    if (board[p][r] != null) return false;
    return true;
}
```
The lights in the scene are: <b>directional light</b> from the top making it possible to see the scene, <b>specular light</b> and <b>spot light</b> used as the torch. The center of the spot light is below the camera and the direction is forward wherever the user is looking. The user can point higher or lower using mouse in Y axis. The spotlight goes along a chosen axis, so when the user moves around the axes change dynamically. To solve this I used the mapping of user rotation to values of axes in the range [-1,1]. User rotation is also bound to the width so that one full circle equals the value of screen width. 
<img src="/Museum/imgs/mappings.png">

Finding the vertical position of the torch, implementing the curve to find x and z direction and setting up the light:
```java
// Torch.pde
lookY = map(mouseY, 0, height, -300, 00);
...
x = player.x;
y = lookY;
z = player.z;

if (mouseX < width/2) {
    direction_x = map(mouseX, 0, width/2, -1, 1);
} else {
    direction_x = map(mouseX, width/2, width, 1, -1);
}

if (mouseX < width/4) {
    direction_z = map(mouseX, 0, width/4, 0, -1);
} else if (mouseX < width*3/4) {
    direction_z = map(mouseX, width/4, width*3/4, -1, 1);
} else {
    direction_z = map(mouseX, width*3/4, width, 1, 0);
}
    
spotLight(255, 255, 200, x, y, z, direction_x, 0, direction_z, PI/12, concentration);
```

To be corrected: encapsulation of rotation reading, displaying red arrow more visibly when the movement is not possible

Reference to the article <a href="https://medium.com/@behreajj/3d-models-in-processing-7d968a7cede5">3D Models In Processing</a><br>
Textures: 
<a href="https://opengameart.org">opengameart.org</a><br>
Objects:
<a href="https://www.myminifactory.com/object/3d-print-venus-aphrodite-is-the-goddess-of-love-she-was-depicted-in-the-nude-or-in-various-stages-of-nudity-and-painted-the-figure-is-executed-in-the-hellenistic-style-and-famed-for-its-sensuous-appearance-it-supposedly-lost-its-arms-in-a-struggle-arising-b-25162">Venus de Milo</a>, Public Domain License;
<a href="https://free3d.com/3d-model/-ionic-column--160091.html">Ionic column</a>, 
<a href="https://free3d.com/3d-model/-doric-column--353773.html">Doric column</a>,
<a href="https://free3d.com/3d-model/wooden-chair-541103.html">Chair</a>,
<a href="https://free3d.com/3d-model/cinema4d-table-66762.html">Table</a> and
<a href="https://free3d.com/3d-model/gun-bot-78928.html">Gun bot</a>, Personal Use License

### 4. Space navigation
<img src="/Space_navigation/imgs/v1.gif" width="300"> <img src="/Space_navigation/imgs/p1.png" width="300">

The project introduces a spaceship to the previous model of the solar system. The spaceship has the capacity of moving in two dimensions and the possibility of viewing it comes as a general perspective and the 1st person perspective (uses spherical coordinates).

Steering: 
- Up/down arrows - go closer/further from the Sun
- Left/right arrows - change angle. Allowed to go upside down
- Mouse - look around
- Z - change viewing mode (general/1st person)
 
Changes in code respect to the anterior version of Solar system:
- the solar system has been converted into a class. It consists of a set of planets, their movements and the movement of the system. The dislocations of the system have been kept outside as they are not an internal feature of it and should also apply to other elements in the scene.
- the movement capacity of elements has been separated out of display() method into the new move() method

A new class Spaceship has been introduced. 
Temporarily the spaceship has the form of a red sphere.  

#### Code highlights:
First person camera view. Calculations to convert parameters from spherical coordinates which are more convenient to manipulate to cartesian coordinates which are taken by the camera:
```java
// Space_navigation.pde
float x = ship.r * sin(ship.rotation) * cos(ship.slope);
float y = ship.r * sin(ship.rotation) * sin(ship.slope);
float z = ship.r * cos(ship.rotation);
    
//center coordinates
float cx = ship.r * sin(ship.rotation + PI/4 + ship.look_vertical) * cos(ship.slope + ship.look_horizontal);
float cy = ship.r * sin(ship.rotation + PI/4 + ship.look_vertical) * sin(ship.slope + ship.look_horizontal);
float cz = ship.r * cos(ship.rotation + PI/4 + ship.look_vertical);
  
camera(x,y,z,cx,cy,cz,0,1,0);  
```
Change spaceship position (slope, distance from the center of the installation) based on user input processed and passed as arguments:
```java
// Space_navigation.pde
void readMouse() {
    ship.change_look("horizontal", mouseX);
    ship.change_look("vertical", mouseY);
}
```
```java
// Spaceship.pde
public void change_position(String mode, boolean positive) {
    if (mode == "horizontal") {
        float new_r = r;
        new_r += positive ? r_change : -r_change;
        if (new_r < max_reach && new_r > min_reach) r = new_r;
    }
    else {
        slope += positive ? slope_change : -slope_change;
        slope %= TWO_PI;
    }
}
```

### 3. Solar system
<img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solar_system/imgs/v1.gif" width="300"> <img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solar_system/imgs/p1.jpg" width="300">

A simplified model of the planets' movement around the Sun. The planets move along a circular orbit with fixed speed. The orbits are inclined. Aditionally the model rotates slowly. Some planets are accompanied by one or more moons.  

Each planet is an instance of a Planet class which helps to encapsulate the parameters giving and visualization process. If a planet has moons, they are a list of Planet objects in a given Planet and they behave exactly the same way (moons could have moons but have to be careful to avoid endless recurrention). The moons' parameters are random. All planets are textured.

The rotations and translations in the model operate on the global matrix and matrix pushing and popping is used. All code is <100 lines long.
#### Code highlights: 
Planet object constructor and instantiation:
```java
public Planet(String name, int radius, int distance, float rotation_speed, float angle, int nr_moons) {
    ...
    texture = loadImage("resources/" + name + ".jpg");
    
    shape = createShape(SPHERE, radius);
    shape.setTexture(texture);
    ...
    
    // Adding moons with random parameters in constructor 
    moons = new ArrayList();
    for (int i = 0; i < nr_moons; i++) {
         moons.add(new Planet("Moon", (int)random(3,7), radius+(int)random(10,20), random(-0.05,0.05), random(-2,2), 0));
    }
}
```
```java
ArrayList<Planet> planets;
planets.add(new Planet("Earth", 20, 200, 0.015, 0.1, 1));
```
Planet movement:

```java
public void display() {
    pushMatrix();
    rotateX(angle);
    rotateY(rotation);
    rotation = (rotation + rotation_speed) % TWO_PI;
    translate(distance,0);
    shape(shape);
    
    //display moons
    for (Planet m : moons) {
        m.display();
    } 
    popMatrix();
}
```  

Background photo by Aperture Vintage on Unsplash

Planet textures source: https://www.solarsystemscope.com/textures/, license: Attribution 4.0

---
### 2. Solids of revolution
Create a 3D solid of revolution out of a flat profile. Use the mouse to draw the profile and right-click to convert it into a 3D object. The object is moveable. Use N key to start a new project. Use P key to display one previous object stored in memory.

The outline is rotated and triangulation is performed between two consequent sets of rotated points. The matrix of 3D rotation is used.

<img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solids_of_revolution/imgs/v1.gif" width="300"> <img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solids_of_revolution/imgs/i1.png" width="300">

<img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solids_of_revolution/imgs/i2.png" width="300"> <img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solids_of_revolution/imgs/i3.png" width="300">

---
### 1. Ping
Two-players 2D game. The gameflow allows multiple deaths before one player wins. The player is allowed to move in 2D within their part of game area. The ball collides with game area walls and the rackets. Additionally, when the ball is hit and pushed by the player it will follow the movement of the racket.

Use of PGraphics areas, sound effects, collisions detection (taking widths into consideration), keys and mouse position detection.

Partial use of OOP (Ball, Rackets) to facilitate spatial control of elements and collisions detection.    

<img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Ping/imgs/p1small.gif" width="300"> <img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Ping/imgs/p1i1.png" width="300">

---
References:

- Course manual
- Processing reference: https://processing.org/reference/
- Spherical to cartesian coordinates conversion: http://tutorial.math.lamar.edu/Classes/CalcIII/SphericalCoords.aspx
- 3D Models In Processing, Medium: https://medium.com/@behreajj/3d-models-in-processing-7d968a7cede5
- OpenCV Mat structure: https://docs.opencv.org/2.4/doc/tutorials/core/mat_the_basic_image_container/mat_the_basic_image_container.html
- OpenCV Core: https://docs.opencv.org/3.4/javadoc/org/opencv/core/Core.html
## Creating User Interfaces 
Universidad de Las Palmas de Gran Canaria, spring 2020<br>
Author: Anna Zawadzka<br>
Processing
---
### 7. Tuner

The tuner selects the dominant wave frequency from input and compares it to note frequencies given in an external file. 
Then it displays the closest note and the distance [Hz] from the pure pitch.

Minim library for sound processing was used. 

The background range image and the hand of the tuner were made using GIMP. 
The data about note frequencies comes from [pages.mtu.edu/~suits/notefreqs.html](https://pages.mtu.edu/~suits/notefreqs.html) 

The gif shows pulling each string of a tuned guitar (EBGDAE).

<img src="/Tuner/imgs/v.gif" width="300"> <img src="/Tuner/imgs/p1.png" width="300">

Background: [Photo by bharath g s on Unsplash](https://unsplash.com/photos/aLGiPJ4XRO4)

### 5. Museum
Scene of a room full of simple objects and one valuable sculpture of Venus de Milo. The user may walk through the room to find the sculpture. The room is dark and the user can see objects pointing a torch at them.

The 3D objects were edited in Blender to reduce their computational complexity. The number of faces of the key object, Venus de Milo, was reduced from 274,000 to 82,000 or 14,000, in case that is too power consuming (requires minor change in code: change filename "venus82k" to "venus14k"). Other objects have up to 1000 faces. The figures were saved upside down due to inconsistency in axes turn (in graphics editors the Y axis increments upwards, while in Processing downwards). 

Steering:
- <b>horizontal</b> movement of mouse to <b>look around</b>
- <b>vertical</b> movement of mouse to <b>point the torch</b> in Y axis
- a <b>click</b> of mouse while pointing in certain direction causes <b>walking</b> in that direction, if possible (not blocked by an object or facing a wall). The player moves in two axes, as on a chessboard.
- the arrow shows possible movement direction

The steering algorithm takes the mapping of mouse X position to one full circle that corresponds all possible views while looking around. Then the direction is decided basing on which slice of the circle is considered, as in the sketch:
<img src="/Museum/imgs/view.png">
  
The lights in the scene are: <b>directional light</b> from the top making it possible to see the scene, <b>specular light</b> and <b>spot light</b> used as the torch. The center of the spot light is below the camera and the direction is forward wherever the user is looking. The user can point higher or lower using mouse in Y axis. The spotlight goes along a chosen axis, so when the user moves around the axes change dynamically. To solve this I used the mapping of user rotation to values of axes in the range [-1,1]. User rotation is also bound to the width so that one full circle equals the value of screen width. 
<img src="/Museum/imgs/mappings.png">

<img src="/Museum/imgs/v1.gif" width="300"> <img src="/Museum/imgs/p1.png" width="300">

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
The project introduces a spaceship to the previous model of the solar system. The spaceship has the capacity of moving in two dimensions and the possibility of viewing it comes as a general perspective and the 1st person perspective.

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

<img src="/Space_navigation/imgs/v1.gif" width="300"> <img src="/Space_navigation/imgs/p1.png" width="300">

### 3. Solar system
A simplified model of the planets' movement around the Sun. The planets move along a circular orbit with fixed speed. The orbits are inclined. Aditionally the model rotates slowly. Some planets are accompanied by one or more moons.  

Each planet is an instance of a Planet class which helps to encapsulate the parameters giving and visualization process. If a planet has moons, they are a list of Planet objects in a given Planet and they behave exactly the same way (moons could have moons but have to be careful to avoid endless recurrention). The moons' parameters are random. All planets are textured.

The rotations and translations in the model operate on the global matrix and matrix pushing and popping is used. All code is <100 lines long.  

<img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solar_system/imgs/v1.gif" width="300"> <img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Solar_system/imgs/p1.jpg" width="300">

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
- 3D Models In Processing, Medium https://medium.com/@behreajj/3d-models-in-processing-7d968a7cede5
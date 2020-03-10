## Creating User Interfaces 
Universidad de Las Palmas de Gran Canaria, spring 2020<br>
Author: Anna Zawadzka<br>
Processing
---

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

<img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Space_navigation/imgs/v1.gif" width="300"> <img src="https://raw.githubusercontent.com/azawadzka/ULPGC-CIU-Graphics/master/Space_navigation/imgs/p1.png" width="300">
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
- https://processing.org/reference/

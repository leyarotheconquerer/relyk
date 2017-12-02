# Relyk

A game about defending a monolith from an army of broken robots.

## Concept

You play as a defending team of diverse robots, arranged around a monolith of
power, defending it from the horde of broken robots that seek to tear it down.

* You manage three types of robots whose power is spread among them.
* Each type has a pool of power that is equally divided among the robots of
  that type.
* You can combine robots of one type to upgrade a robot of another type.
* Each robot type is best at destroying a broken robot of its own type.
* Shared power is proportional to the robot's starting attack, so while upgraded
  robots share a pool with lesser robots, their attacks will unilaterally be
  better.

### Key Gameplay Elements
* Controlling robots of each type
* Enemy robots spawn
* Robots can attack enemies
* Enemy robots try to attack the monolith
* Robots of each type share power (displayed and combat effective)
* Robots can be combined to upgrade other types
* Robots are better at attacking their own type

### Non-essential Gameplay Elements
* Robot upgrades spawn enemies of corresponding types

## Assets Needed
* Player Robots
	* Cuboid - Red (#FF350A)
		* Attack animations
		* Transform animations
		* Death animations?
	* Spheroid - Orange (#FF790A)
		* Attack animations
		* Transform animations
		* Death animations?
	* Pyramoid - Yellow (#FFCD0A)
		* Attack animations
		* Transform animations
		* Death animations?
* Enemy robots
	* Cuboid - Red
		* Attack animations
		* Death animations
		* Transform animations
	* Spheroid - Orange
		* Attack animations
		* Death animations
		* Transform animations
	* Pyramoid - Yellow
		* Attack animations
		* Death animations
		* Transform animations
* Monolith - (#3B21CD)
	* With particles (#07BEBE)
	* With damage?
* Map
	* Occasional rocks?
	* Slight hill leading to dias for Monolith
* UI
	* Bars for each type
	* Health bars
	* Button to upgrade of type
	* Unit icons to select for combination
	* *Selection mechanism somehow*
* Menu
	* Start new game
	* High score?
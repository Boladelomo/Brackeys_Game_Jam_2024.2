extends Node

enum AsteroidClass { MICRO, PROJECTILE, SHELTER }

const asteroid = preload("res://asteroid.tscn")
const ASTEROID_AMOUNT := 50
const SHELTER_AMOUUNT := 5

@onready var asteroids : Array[Area2D]
@onready var shelter_pool : Array[Area2D] : get = _get_asteroids

func _get_asteroids():
	pass

#TODO: list of asteroids of different sizes

#TODO: setting asteroid speed, rotation and spawn position, 

#TODO: storm patterns (timers, points of entry (plural?) and directions)

func _ready():
	asteroids.resize(ASTEROID_AMOUNT)
	print("Hello")

func fill_asteroid_array(array, length):
	for i in length:
		#array[i] = 
		pass

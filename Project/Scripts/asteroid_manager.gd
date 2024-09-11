extends Node

enum AsteroidClass { MICRO, PROJECTILE, SHELTER }

var asteroid = preload("res://Scenes/asteroid.tscn")
const ASTEROID_AMOUNT := 50
const MAX_SHELTER_AMOUNT := 5
const MIN_SHELTER_RADIUS := 75.0

@onready var asteroids : Array[Area2D] : get = _get_asteroids
#@onready var shelter_pool : Array[Area2D] : get = _get_asteroids

func _get_asteroids():
	return asteroids

#TODO: list of asteroids of different sizes

#TODO: setting asteroid speed, rotation and spawn position, 

#TODO: storm patterns (timers, points of entry (plural?) and directions)

func _ready():
	asteroids.resize(ASTEROID_AMOUNT)
	fill_asteroid_array(asteroids, ASTEROID_AMOUNT)
	print("Hello")

func fill_asteroid_array(array, length):
	for i in length:
		array[i] = asteroid.instantiate()
		print("asteroid " + str(i) + " radius = ")
		randomize_asteroid_values(array[i])

func randomize_asteroid_values(asteroid):
	#count large asteroids and prevent more than SHELTER_AMOUNT from spawning
	var shelter_count := 0
	var collider = asteroid.get_node("CollisionShape2D")
	for a in asteroids:
		if collider.shape.radius >= MIN_SHELTER_RADIUS:
			shelter_count += 1
	if shelter_count >= MAX_SHELTER_AMOUNT:
		collider.shape.radius = randf_range(asteroid.min_radius, asteroid.min_radius * 2.0)
	else:
	#if within shelter limit
		collider.shape.radius = randf_range(asteroid.min_radius, asteroid.max_radius)
	print(collider.shape.radius)

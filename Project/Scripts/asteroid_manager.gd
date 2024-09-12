extends Node

enum AsteroidClass { MICRO, PROJECTILE, SHELTER }

var asteroid = preload("res://Scenes/asteroid.tscn")
const ASTEROID_AMOUNT := 3
const MAX_SHELTER_AMOUNT := 5
const MIN_SHELTER_RADIUS := 75.0

@export var min_radius := 10.0
@export	var max_radius := 125.0

@onready var asteroids : Array[Area2D] : get = _get_asteroids
func _get_asteroids():
	return asteroids

#TODO: setting asteroid speed, rotation and spawn position, 
#TODO: storm patterns (timers, points of entry (plural?) and directions)

func _init() -> void:
	asteroids.resize(ASTEROID_AMOUNT)
	fill_asteroid_array(asteroids, ASTEROID_AMOUNT)
	print("Hello")

func _ready() -> void:
	for i in ASTEROID_AMOUNT:
		randomize_asteroid_values(asteroids[i])

func fill_asteroid_array(array, length):
	for i in length: #TODO: @Lowcunning: check out of index problems with these loops
		array[i] = asteroid.instantiate()
		

func randomize_asteroid_values(asteroid):
	#count large asteroids and prevent more than SHELTER_AMOUNT from spawning
	var shelter_count := 0
	var collider = asteroid.get_node("CollisionShape2D")
	for a in asteroids:
		if collider.shape.radius >= MIN_SHELTER_RADIUS:
			shelter_count += 1

	if shelter_count >= MAX_SHELTER_AMOUNT:
		#min to 2xmin size for non-shelter asteroids, TODO: needs playtesting
		asteroid._set_radius(randf_range(min_radius, min_radius * 2.0))
	else:
	#if within shelter limit
		asteroid._set_radius(randf_range(min_radius, max_radius))
	print("asteroid manager:")
	print(asteroid._get_radius())

extends Node2D
class_name StormSpawnManager

var asteroid_scene = preload("res://Scenes/asteroid.tscn")
var small_ast_resource = preload("res://Resources/asteroid_small.tres")
var medium_ast_resource = preload("res://Resources/asteroid_medium.tres")
var large_ast_resource = preload("res://Resources/asteroid_large.tres")
@onready var storm_spawn_timer: Timer = %StormSpawnTimer
@onready var storm_notification_timer: Timer = %StormSpawnTimer
@export var spawn_frequency:int = 2
@export var active:bool = true
@export var storm_unity_count:int = 10
@export var player:CharacterBody2D


var storm_array:Array = []
var storm_areas_array:Array = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start_storm_spawn()
	if !active:return
	storm_spawn_timer.wait_time = spawn_frequency
	var notification_headsup
	if spawn_frequency-8 > 0: notification_headsup = spawn_frequency-8
	else: notification_headsup = 1
	storm_notification_timer.wait_time = notification_headsup
	storm_spawn_timer.start()
	storm_notification_timer.start()
	storm_spawn_timer.timeout.connect(start_storm_spawn)
	storm_notification_timer.timeout.connect(storm_notification_start)


func start_storm_spawn():
	
	printt("STORM STARTED - RUN FOR YOUR LIFE")
	Globals.storm_has_started.emit()

	# Define Storm Spawn Areas
	for area in self.get_children():
		if area is Area2D:
			storm_areas_array.append(area)
	
	# Select a random storm area
	var random_area = storm_areas_array.pick_random()

	
	for a in storm_unity_count:
		# Create all Asteroids based on storm_unity_count
		var new_asteroid = asteroid_scene.instantiate()
		var collider = random_area.get_child(0)
		var rand_storm_offset_x = collider.shape.radius * cos(randf_range(0, 2*PI))
		var rand_storm_offset_y = collider.shape.radius * sin(randf_range(0, 2*PI))

		var storm_start_pos = Vector2(rand_storm_offset_x, rand_storm_offset_y) + collider.global_position
		new_asteroid.global_position = storm_start_pos
		storm_array.append(new_asteroid)
		get_parent().get_node("%SpawnedAsteroids").call_deferred("add_child", new_asteroid)

		# Set their direction and their type
		var astro_resource = randomize_asteroid_resource(false)
		new_asteroid.asteroid_class = astro_resource
		new_asteroid.is_part_of_storm = true #if false they all will be Small. We can change logic later
		var rand_player_offset_x = randi_range(-800, 800)
		var rand_player_offset_y = randi_range(-800, 800)
		# new_asteroid.move_speed = astro_resource.asteroid_speed
		new_asteroid.move_direction_vector = storm_start_pos.direction_to(player.global_position + Vector2(rand_player_offset_x, rand_player_offset_y))

func storm_notification_start():
	Globals.storm_notification.emit("ASTEROID STORM DETECTED!!!", Color.YELLOW)
	printt("STORM ABOUT TO START")
	pass


func randomize_asteroid_resource(random:bool = true) -> AsteroidClassResource:
	if random:
		var random_number = randi() % 10
		match random_number:
			0:return small_ast_resource
			1:return small_ast_resource
			2:return small_ast_resource
			3:return small_ast_resource
			4:return small_ast_resource
			5:return small_ast_resource
			6:return medium_ast_resource
			7:return medium_ast_resource
			8:return large_ast_resource
			_:return small_ast_resource
	else:
		return small_ast_resource

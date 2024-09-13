extends Node2D
class_name AsteroidSpawnManager
@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var asteroid_scene = preload("res://Scenes/asteroid.tscn")
var small_ast_resource = preload("res://Resources/asteroid_small.tres")
var medium_ast_resource = preload("res://Resources/asteroid_medium.tres")
var large_ast_resource = preload("res://Resources/asteroid_large.tres")
@onready var asteroid_spawn_timer: Timer = %AsteroidSpawnTimer
@export var active:bool = true
@export var spawn_frequency_timer:int = 2
@export_range(0.2, 1.4, 0.2) var spawn_area_scale: float = 0.2
@onready var spawn_area_scale_marker: Marker2D = $SpawnAreaScaleMarker
@export var player:CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !active:return
	asteroid_spawn_timer.wait_time = spawn_frequency_timer
	asteroid_spawn_timer.start()
	asteroid_spawn_timer.timeout.connect(spawn_asteroid)
	spawn_area_scale_marker.scale = Vector2(spawn_area_scale, spawn_area_scale)

func spawn_asteroid():
	if !active:return
	var new_asteroid = asteroid_scene.instantiate()
	path_follow_2d.progress_ratio = randf()
	new_asteroid.global_position = path_follow_2d.global_position

	get_parent().get_node("%SpawnedAsteroids").call_deferred("add_child", new_asteroid)

	var astro_resource = randomize_asteroid_resource()
	new_asteroid.asteroid_class = astro_resource	
	new_asteroid.is_part_of_storm = false

	var rand_player_offset_x = randi_range(-1400, 1400)
	var rand_player_offset_y = randi_range(-1400, 1400)

	new_asteroid.move_direction_vector = path_follow_2d.global_position.direction_to(player.global_position + Vector2(rand_player_offset_x, rand_player_offset_y))


func randomize_asteroid_resource() -> AsteroidClassResource:
	var random = randi() % 10
	match random:
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

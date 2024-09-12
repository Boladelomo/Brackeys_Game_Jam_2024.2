extends Node2D
@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var asteroid_scene = preload("res://Scenes/asteroid.tscn")
var small_ast_resource = preload("res://Resources/asteroid_small.tres")
var medium_ast_resource = preload("res://Resources/asteroid_medium.tres")
var large_ast_resource = preload("res://Resources/asteroid_large.tres")
@onready var asteroid_spawn_timer: Timer = %AsteroidSpawnTimer
@export var spawn_frequency_timer:int = 2
@export_range(0.2, 1.4, 0.2) var spawn_area_scale: float = 0.2
@onready var spawn_area_scale_marker: Marker2D = $SpawnAreaScaleMarker


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# spawn_asteroid()
	asteroid_spawn_timer.wait_time = spawn_frequency_timer
	asteroid_spawn_timer.start()
	asteroid_spawn_timer.timeout.connect(spawn_asteroid)
	spawn_area_scale_marker.scale = Vector2(spawn_area_scale, spawn_area_scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_asteroid():
	var new_asteroid = asteroid_scene.instantiate()
	path_follow_2d.progress_ratio = randf()
	new_asteroid.global_position = path_follow_2d.global_position

	add_child(new_asteroid)

	var astro_resource = randomize_asteroid_resource()
	new_asteroid.update_asteroid_from_resource(astro_resource)
	
	
	printt("SpawnedAsteroid", new_asteroid.name)

func randomize_asteroid_resource() -> AsteroidClassResource:
	var random = randi() % 3
	match random:
		0:return small_ast_resource
		1:return medium_ast_resource
		2:return large_ast_resource
		_:return small_ast_resource

extends Area2D
class_name Asteroid

@export var asteroid_class: AsteroidClassResource
@onready var sprite_2d: Sprite2D = $Sprite2D
var is_being_drilled: bool = false

var move_speed: float = 10.0
var move_direction_vector := Vector2(0, 0)

var safe_color := Color.AQUAMARINE
var empty_color := Color.WHITE
var damage_color := Color.CRIMSON
var current_color := empty_color

var has_collider_shape:= false
var collided:= false
var collision_object : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_asteroid_from_resource(asteroid_class)
	move_direction_vector.y = randi_range(-5, 5)
	move_direction_vector.x = randi_range(-5, 5)
	printt(move_direction_vector.y, move_direction_vector.x)

func _physics_process(delta):
	global_position += move_direction_vector * move_speed * delta
	

func update_asteroid_from_resource(astro_resource) -> void:
	var new_collider := CollisionShape2D.new()
	var sphere_shape = CircleShape2D.new()
	new_collider.shape = sphere_shape
	sprite_2d.texture = astro_resource.sprite_texture

	var asteroid_size = astro_resource.asteroid_size
	update_asteroid_size(asteroid_size)
	new_collider.shape.radius = 0
	var radius_var = update_asteroid_radius(asteroid_size)
	new_collider.shape.radius = radius_var
	move_speed = astro_resource.asteroid_speed

	for child in get_children():
		if child is CollisionShape2D:
			has_collider_shape = true

	if !has_collider_shape:
		add_child(new_collider)
	
	new_collider.global_position = self.global_position

	printt("SpawnedAsteroid", self.name, radius_var, move_speed, asteroid_size)


func update_asteroid_size(asteroid_size) -> void:
	match asteroid_size:
		2:sprite_2d.scale = Vector2(1, 1)
		1:sprite_2d.scale = Vector2(1.5, 1.5)
		0:sprite_2d.scale = Vector2(2, 2)


func update_asteroid_radius(asteroid_size) -> float:
	match asteroid_size:
		2:return 30.0
		1:return 100.0
		0:return 160.0
	return 0.0


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		collided = true
		collision_object = body
		if body.has_method("player_entered_safe_area"):
			body.player_entered_safe_area()


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		collided = false
		if body.has_method("player_left_safe_area"):
			body.player_left_safe_area()

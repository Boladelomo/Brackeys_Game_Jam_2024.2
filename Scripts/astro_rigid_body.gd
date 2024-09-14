extends RigidBody2D
var move_direction_vector := Vector2(0, 0)
var move_speed: float = 100
@onready var astro_area_2d: Area2D = %AstroArea2d
@onready var astro_resource: AsteroidClassResource = astro_area_2d.asteroid_class
# @onready var rigid_body_collider: CollisionShape2D = %RigidBodyCollider
@export var custom_mass:float = 20.0
@export var custom_inertia:float = 20.0
@export var custom_linear_velocity:Vector2
@onready var fire: Node2D = %Fire
# var reset_state = false
# var moveVector: Vector2
# var origin_position: Vector2

@onready var small_v_large: AudioStreamPlayer2D = $"Small v Large"
@onready var medium_vs_large: AudioStreamPlayer2D = $"Medium vs Large"
@onready var large_v_large: AudioStreamPlayer2D = $"Large v Large"

var has_collider_shape:= false
var collided:= false
var collision_object : CharacterBody2D

func _ready():
	fire.visible = false
	create_local_collider()
	custom_mass = update_asteroid_mass(astro_resource.asteroid_size)
	custom_inertia = update_asteroid_mass(astro_resource.asteroid_size)
	custom_linear_velocity = astro_resource.linear_velocity
	linear_velocity = custom_linear_velocity
	mass = custom_mass
	inertia = custom_inertia
	if astro_resource.asteroid_size == 2:
		fire.visible = true
	
	apply_central_impulse(move_direction_vector * move_speed) #Uses to apply an initial impulse once to the object / More mass more force required
	apply_torque_impulse(move_speed/2) #sets a one time force for initial rotation / More mass more force required

# func _integrate_forces(state):
	# var target_position = move_direction_vector
	# apply_central_force(target_position) # used to apply refular frame force

func update_asteroid_radius(asteroid_size) -> float:
	match asteroid_size:
		2:return 30
		1:return 65
		0:return 110
	return 0.0

func update_asteroid_mass(asteroid_size) -> float:
	match asteroid_size:
		2:return 20
		1:return 800
		0:return 500000
	return 20

func create_local_collider() -> void:
	var new_collider := CollisionShape2D.new()
	var sphere_shape = CircleShape2D.new()
	new_collider.shape = sphere_shape
	new_collider.shape.radius = update_asteroid_radius(astro_resource.asteroid_size)
	new_collider.debug_color = Color(1.0, 0.0, 0.5, 0.5)
	add_child(new_collider)

	


func _on_astro_area_2d_body_entered(body:Node2D) -> void:
	if body is CharacterBody2D and astro_resource.asteroid_size == 0:
		collided = true
		collision_object = body
		if body.has_method("player_entered_safe_area"):
			body.player_entered_safe_area()
	
	if body is CharacterBody2D and astro_resource.asteroid_size == 2:
		printt("Hit Player", body.name)
		if "take_damage" in body:
			body.take_damage(1)

	if body is RigidBody2D and astro_resource.asteroid_size == AsteroidClassResource.asteroid_group_sizes.LARGE:
		var size = body.astro_resource.asteroid_size
		match size:
			AsteroidClassResource.asteroid_group_sizes.SMALL:
				small_v_large.play()
			AsteroidClassResource.asteroid_group_sizes.MEDIUM:
				medium_vs_large.play()
			AsteroidClassResource.asteroid_group_sizes.LARGE:
				large_v_large.play()

func _on_astro_area_2d_body_exited(body:Node2D) -> void:
	if body is CharacterBody2D and astro_resource.asteroid_size == 0:
		collided = false
		if body.has_method("player_left_safe_area"):
			body.player_left_safe_area()

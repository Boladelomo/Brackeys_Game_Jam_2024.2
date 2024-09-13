extends RigidBody2D
var move_direction_vector := Vector2(0, 0)
var move_speed: float = 100
@onready var astro_area_2d: Area2D = %AstroArea2d
@onready var astro_resource: AsteroidClassResource = astro_area_2d.asteroid_class
@onready var rigid_body_collider: CollisionShape2D = %RigidBodyCollider
@export var custom_mass:float = 20.0
@export var custom_inertia:float = 20.0

func _ready():
	create_local_collider()
	custom_mass = update_asteroid_mass(astro_resource.asteroid_size)
	custom_inertia = update_asteroid_mass(astro_resource.asteroid_size)
	mass = custom_mass
	inertia = custom_inertia

func _physics_process(delta):
	global_position += move_direction_vector * move_speed * delta
	printt("Velo", move_direction_vector)

func update_asteroid_radius(asteroid_size) -> float:
	match asteroid_size:
		2:return 33
		1:return 65
		0:return 110
	return 0.0

func update_asteroid_mass(asteroid_size) -> float:
	match asteroid_size:
		2:return 20
		1:return 50
		0:return 500
	return 20

func create_local_collider() -> void:
	var new_collider := CollisionShape2D.new()
	var sphere_shape = CircleShape2D.new()
	new_collider.shape = sphere_shape
	new_collider.shape.radius = update_asteroid_radius(astro_resource.asteroid_size)
	new_collider.debug_color = Color(1.0, 0.0, 0.5, 0.5)
	add_child(new_collider)
	

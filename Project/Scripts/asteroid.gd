extends RigidBody2D

class_name Asteroid

@export var asteroid_class: AsteroidClassResource
@onready var sprite_2d: Sprite2D = $Sprite2D
var is_being_drilled: bool = false
@onready var label_speed: Label = $LabelSpeed
@onready var collider: CollisionShape2D = $CollisionShape2D
@export var MAX_LARGE_HP := 5
var current_hp = MAX_LARGE_HP

var move_speed: float = 10.0: 
	get:
		return move_speed
	set(value):
		move_speed = clamp(value, 0.0, asteroid_class.asteroid_speed) # (value

var move_direction_vector := Vector2(0, 0)
var is_part_of_storm:bool = false

var has_collider_shape:= false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_asteroid_from_resource(asteroid_class)
	# if !is_part_of_storm:#Set a random world position. 
	# 	move_direction_vector.y = randi_range(-1, 1)
	# 	move_direction_vector.x = randi_range(-1, 1)
	set_gravity_scale(0.0)
	print("asteroid size: " + str(asteroid_class.asteroid_size))
	queue_redraw()

func _physics_process(delta):
	var velo = move_direction_vector * move_speed * delta
	
	global_position += move_direction_vector * move_speed * delta
	label_speed.text = "Move:Speed:" +str(round(move_speed)) + "  Velo:" +str(round(velo)) + "  Dir:" + str(round(move_direction_vector))

# TODO: DEFINE A FUNCTION TO DESTOY THE ASTEROID
# TODO: DEFINE A FUNCTION THAT DISABLES ASTEROIDS FAR AWAY FROM PLAYER

func take_damage(is_killing_blow : bool) ->void:
	if is_killing_blow:
		current_hp = 0
	else:
		current_hp -= 1
		
	if current_hp <= 0:
		#TODO: 
		#add debris spawn function: cut asteroid asset, 
		#make pieces drift away from center, and fade away (alpha), no collsion
		print("asteroid dead!")
		queue_free()

func update_asteroid_from_resource(astro_resource) -> void:
	sprite_2d.texture = astro_resource.sprite_texture
	
	var asteroid_size = astro_resource.asteroid_size
	update_asteroid_size(asteroid_size)
	var radius_var = update_asteroid_radius(asteroid_size)
	collider.shape.radius = radius_var
	move_speed = astro_resource.asteroid_speed	

func update_asteroid_size(asteroid_size) -> void:
	match asteroid_size:
		2:sprite_2d.scale = Vector2(1, 1)
		1:sprite_2d.scale = Vector2(1.5, 1.5)
		0:sprite_2d.scale = Vector2(2, 2)


func update_asteroid_radius(asteroid_size) -> float:
	match asteroid_size:
		2:return 30.0
		1:return 60.0
		0:return 160.0
	return 0.0

func handle_asteroid_impact(other_size):
	#asteroids ignore same size, for now
	if other_size == asteroid_class.asteroid_size:
		print("same size collision")
		return
	if (other_size == AsteroidClassResource.asteroid_group_sizes.SMALL
	 and asteroid_class.asteroid_size == AsteroidClassResource.asteroid_group_sizes.LARGE):
		print("normal damage!")
		take_damage(false)
	elif (other_size == AsteroidClassResource.asteroid_group_sizes.MEDIUM
	 and asteroid_class.asteroid_size == AsteroidClassResource.asteroid_group_sizes.LARGE):
		print("killing blow!")
		take_damage(true)

func _on_body_entered(body: Node2D) -> void:
	queue_redraw()
	if body is CharacterBody2D:
		if body.has_method("player_entered_safe_area"):
			body.player_entered_safe_area()
	elif body is RigidBody2D:
		print(str(body.asteroid_class.asteroid_size))
		print(str(asteroid_class.asteroid_size))
		handle_asteroid_impact(body.asteroid_class.asteroid_size)
		
func _draw() -> void:
	draw_circle(collider.position, collider.shape.radius * 1.1, Color.RED, true)

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_method("player_left_safe_area"):
			body.player_left_safe_area()

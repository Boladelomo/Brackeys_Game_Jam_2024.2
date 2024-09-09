extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _physics_process(delta: float) -> void:
	# # Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	var direction = Input.get_vector("ui_left" , "ui_right" , "ui_up" , "ui_down")
	
	if direction:
		velocity = direction * SPEED

	if Input.is_action_just_pressed("ui_left"):
		animation_player.play("space_walk_left")
	
	if Input.is_action_just_pressed("ui_right"):
		animation_player.play("space_walk_right")
	
	if Input.is_action_just_pressed("ui_up"):
		animation_player.play("space_walk_up")
	
	if Input.is_action_just_pressed("ui_down"):
		animation_player.play("space_walk_down")
	
	if direction == Vector2.ZERO:
		velocity = direction * 0

	move_and_slide()

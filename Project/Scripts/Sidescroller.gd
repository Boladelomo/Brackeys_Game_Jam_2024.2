extends CharacterBody2D

@export var myBody : CharacterBody2D
@export var sprite : Sprite2D 

#UI
@export var label : Label

#directionment
var direction := Vector2.ZERO
var thrust_vector := Vector2.ZERO

const MAX_SPEED := 120.0
const MAX_THRUST := 12
@export var thrust := 4.5
@export var boost_thrust := 40.0

#Debugging
@onready var debug_label = label

func _physics_process(_delta):

	if Input.is_action_pressed("up"):
		thrust_vector.y += max(-thrust, -MAX_THRUST)

	if Input.is_action_pressed("down"):
		thrust_vector.y += min(thrust, MAX_THRUST)

	if Input.is_action_pressed("left"):
		thrust_vector.x += max(-thrust, -MAX_THRUST)

	if Input.is_action_pressed("right"):
		thrust_vector.x += min(thrust, MAX_THRUST)


	#cap thrust_vector
	thrust_vector.y = max(thrust_vector.y, -MAX_SPEED) if thrust_vector.y < 0.0 else min(thrust_vector.y, MAX_SPEED)
	thrust_vector.x = max(thrust_vector.x, -MAX_SPEED) if thrust_vector.x < 0.0 else min(thrust_vector.x, MAX_SPEED)




	#TODO: 'if boosting' logic, deplete boost meter but override max thrust with boost_thrust
	velocity.y = thrust_vector.y 
	velocity.x = thrust_vector.x
	
	if Input.is_action_pressed("jump"):
		boost()
		
	move_and_slide()

func _process(delta): 
	label.text = "thrustX: " + str(thrust_vector.x) + " thrustY: " + str(thrust_vector.y)

	var fps = Engine.get_frames_per_second()
	var lerpInterval = direction / fps
	var lerpPosition = global_transform.origin + lerpInterval

	if fps > 30:
		sprite.global_transform.origin = sprite.global_transform.origin.lerp(lerpPosition, 20 * delta)
	else :
		sprite.global_transform = global_transform

#TODO: replace with boost
func boost():
	velocity.x += boost_thrust * Input.get_axis("left", "right")
	print(velocity.x)
	velocity.y += boost_thrust * Input.get_axis("up", "down")
	print(velocity.y)


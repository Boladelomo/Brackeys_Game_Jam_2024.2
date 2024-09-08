extends CharacterBody2D

enum UnitState { IDLE, WALKING, ATTACKING, FALLING, JUMPING }

@export var myBody : CharacterBody2D
@export var sprite : Sprite2D 

#UI
@export var label : Label

#directionment
var direction := Vector2.ZERO
var thrust_vector := Vector2.ZERO

const MAX_SPEED := 60.0
const MAX_THRUST := 7
var thrust := 3.5

@export var jumpHeight : float
@export var jumpTimeToPeak : float
@export var jumpTimeToDescent : float

@onready var jumpVelocity : float = ((2.0 * jumpHeight) / jumpTimeToPeak) * -1.0 
@onready var jumpGravity : float = ((-2.0 * jumpHeight) / (jumpTimeToPeak * jumpTimeToPeak)) * -1.0 
@onready var fallGravity : float = ((-2.0 * jumpHeight) / (jumpTimeToDescent * jumpTimeToDescent)) * -1.0 

#combat
const MAX_ATTACK_TIME : float = 30.0
var attack_time : float = 0.0

var state : UnitState
#Debugging
@onready var debug_label = label

func _ready():
	print(jumpVelocity)
	print(jumpGravity)
	print(fallGravity)

func update_state():
	attack_time = attack_time - 1 if attack_time > 0.0 else 0.0	
	if is_on_floor():
		if attack_time > 0.0:
			state = UnitState.ATTACKING
		else:
			state = UnitState.IDLE if velocity.x == 0.0 else UnitState.WALKING
	else:
		state = UnitState.JUMPING if velocity.y < 0.0 else UnitState.FALLING

func _physics_process(delta):
	#vertical movement
	#velocity.y += get_gravity() * delta
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#jump()

	if Input.is_action_pressed("up"):
		thrust_vector.y += max(-thrust, -MAX_THRUST)
		
	if Input.is_action_pressed("down"):
		thrust_vector.y += min(thrust, MAX_THRUST)

	velocity.y = max(thrust_vector.y, -MAX_SPEED) if thrust_vector.y < 0.0 else min(thrust_vector.y, MAX_SPEED) 

	if Input.is_action_pressed("left"):
		thrust_vector.x += max(-thrust, -MAX_THRUST)
		
	if Input.is_action_pressed("right"):
		thrust_vector.x += min(thrust, MAX_THRUST)
	
	velocity.x = max(thrust_vector.x, -MAX_SPEED) if thrust_vector.x < 0.0 else min(thrust_vector.x, MAX_SPEED) 
	#TODO: action locks you in place, for dialogues	
	#Action logic
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack_time = MAX_ATTACK_TIME

	move_and_slide()

func _process(delta): 
	update_state()
	label.text = "thrustX: " + str(thrust_vector.x) + " thrustY: " + str(thrust_vector.y)
	#label.text = update_debug_text()
	var fps = Engine.get_frames_per_second()
	var lerpInterval = direction / fps
	var lerpPosition = global_transform.origin + lerpInterval

	if fps > 30:
		sprite.global_transform.origin = sprite.global_transform.origin.lerp(lerpPosition, 20 * delta)
	else :
		sprite.global_transform = global_transform

func get_gravity() -> float:
	return jumpGravity if velocity.y < 0.0 else fallGravity

#TODO: replace with boost
func jump():
	velocity.y = jumpVelocity

#TODO: moving this to its own node requires setup each time it's re added, turn on/off with devtools.
#TODO: disable for release
func update_debug_text() -> String:
	var s : String	
	match state:
		UnitState.IDLE:
			s = "Idle"
		UnitState.WALKING:
			s = "Walk"
		UnitState.ATTACKING:
			s = "Atacking"
		UnitState.FALLING:
			s = "Falling"
		UnitState.JUMPING:
			s = "Jumping"
		_:
			s = "<error>"
	return s

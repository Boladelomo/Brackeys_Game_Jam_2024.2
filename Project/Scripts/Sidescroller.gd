extends CharacterBody2D

enum UnitState { IDLE, WALKING, ATTACKING, FALLING, JUMPING }

@export var myBody : CharacterBody2D
@export var sprite : Sprite2D 

#UI
@export var label : Label

#directionment
var direction : Vector2 = Vector2.ZERO
const MaxSpeed : float = 300.0
@export var speed : float = MaxSpeed

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
	#vertical directionment
	velocity.y += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()	

	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack_time = MAX_ATTACK_TIME

	#horizontal directionment
	direction.x = Input.get_axis("left", "right")
	if direction.x:
		velocity.x = direction.x * speed 
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _process(delta): 
	update_state()
	label.text = update_debug_text()
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

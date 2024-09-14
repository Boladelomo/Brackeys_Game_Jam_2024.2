extends CharacterBody2D

@export var myBody : CharacterBody2D
@export var sprite : Sprite2D 
@onready var collider: CollisionShape2D = $CollisionShape2D : get = _get_player_collider
func _get_player_collider():
	return collider
	

#OXYGEN LOGIC VARIABLES  - START REGION
@onready var distance_lable = %DistanceTravelledLabel
var initial_position = Vector2(0, 0)
var distance_traveled: float = 0.0
var is_moving: bool = false
var is_on_safe_area:bool = false
@export var oxygen_move_consumption:float = 0.3
@export var oxygen_idle_consumption:float = 0.1
@export var oxygen_recovery_rate:float = 0.5
@export var idle_move_tolerance:float = 0.2
#OXYGEN LOGIC VARIABLES - END REGION

@onready var jetpack_fire:Sprite2D = %JetFire
var is_facing_left = true

#UI
@onready var label: Label = %Label

#directionment
var direction := Vector2.ZERO
var thrust_vector := Vector2.ZERO

const MAX_SPEED := 70.0
const MAX_THRUST := 12.0
const MAX_BOOSTED_SPEED := 160.0
@export var thrust := 4.5
@export var boost_thrust := 40.0

@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	stop_jet_pack()

func _physics_process(delta):
	#movement
	manage_player_movement(delta)
	
	if Input.is_action_pressed("jump"):
		boost()	
		

	move_and_slide()
	
	#region: OXYGEN CONTROL CODE - START REGION
	initial_position = self.position 

	move_and_slide()

	distance_traveled += self.position.distance_to(initial_position)
	distance_lable.text = "Distance travelled: " + str(distance_traveled)
	
	update_oxygen_bar(distance_traveled)

	#Check if we are not moving - if we almost stopped
	if self.position.distance_to(initial_position) <= idle_move_tolerance:
		is_moving = false
		distance_traveled = 0 # Reset the distance traveled and allows to replesnish oxygem
		# TODO: Add logic to only recover Oxygen when in certain condintions
		if is_on_safe_area:
			Globals.oxygen_changed.emit(oxygen_recovery_rate + oxygen_recovery_rate, false)
	else:
		is_moving = true
	#endregion: OXYGEN CONTROL CODE - END REGION
		

func manage_player_movement(_delta):
	stop_jet_pack()
	if Input.is_action_pressed("up"):
		animation_player.play("jetpack_up")
		thrust_vector.y += max(-thrust, -MAX_THRUST)
		fire_jet_pack()

	if Input.is_action_pressed("down"):
		animation_player.play("jetpack_down")
		thrust_vector.y += min(thrust, MAX_THRUST)
		fire_jet_pack()

	if Input.is_action_pressed("left"):
		# printt("Moving Left - No Drill")
		animation_player.play("jetpack_left")
		thrust_vector.x += max(-thrust, -MAX_THRUST)
		is_facing_left = true
		fire_jet_pack()
	

	
	if Input.is_action_pressed("right"):
		animation_player.play("jetpack_right")
		# printt("Moving Right - No Drill")
		thrust_vector.x += min(thrust, MAX_THRUST)
		is_facing_left = false
		fire_jet_pack()


	#cap thrust_vector
	thrust_vector.y = max(thrust_vector.y, -MAX_SPEED) if thrust_vector.y < 0.0 else min(thrust_vector.y, MAX_SPEED)
	thrust_vector.x = max(thrust_vector.x, -MAX_SPEED) if thrust_vector.x < 0.0 else min(thrust_vector.x, MAX_SPEED)

	#TODO: 'if boosting' logic, deplete boost meter but override max thrust with boost_thrust
	velocity.y = thrust_vector.y 
	velocity.x = thrust_vector.x

func update_oxygen_bar(_distance):
	var oxygen_depletion_value
	if !is_moving:
		oxygen_depletion_value = oxygen_idle_consumption
	else:
		oxygen_depletion_value = oxygen_idle_consumption + oxygen_move_consumption

	Globals.oxygen_changed.emit(oxygen_depletion_value, true)
	#printt("Bar:", str(oxygen_bar.value), "Consumption:", str(oxygen_depletion_value) , "Moving:", str(is_moving))

func take_damage(damage):
	Globals.player_health -= damage
	_play_hit_effect()

func _play_hit_effect():
	sprite.material.set_shader_parameter("progress", 0.7)
	#await get_tree().create_timer(0.2).timeout
	await _play_hit_pushback()
	sprite.material.set_shader_parameter("progress", 0.0)

func _play_hit_pushback():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	var start = global_position
	var end = self.global_position - Vector2(5, 0)
	tween.tween_property(self, "global_position", end, 0.2).from(start)
	# tween.tween_property(self, "global_position", start, 0.1).from(global_position)
	await tween.finished


func player_entered_safe_area():
	is_on_safe_area = true
	printt("Entered safe area")

func player_left_safe_area():
	is_on_safe_area = false
	printt("Left safe area")

func boost():
	velocity.x += boost_thrust * Input.get_axis("left", "right")
	velocity.y += boost_thrust * Input.get_axis("up", "down")


func stop_jet_pack() -> void:
	jetpack_fire.visible = false

func fire_jet_pack() -> void:
	jetpack_fire.visible = true

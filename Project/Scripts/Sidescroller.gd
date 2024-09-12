extends CharacterBody2D

@export var myBody : CharacterBody2D
@export var sprite : Sprite2D 
@onready var collider: CollisionShape2D = $CollisionShape2D : get = _get_player_collider

func _get_player_collider():
	return collider


#region OXYGEN LOGIC VARIABLES
@onready var oxygen_bar = %OxygenProgressBar
@onready var distance_lable = %DistanceTravelledLabel
var initial_position = Vector2(0, 0)
var distance_traveled: float = 0.0
var is_moving: bool = false
var is_on_safe_area:bool = false
@export var oxygen_move_consumption:float = 0.3
@export var oxygen_idle_consumption:float = 0.1
@export var oxygen_recovery_rate:float = 0.5
@export var idle_move_tolerance:float = 0.2
#endregion

@onready var jetpack_fire:Sprite2D = %JetFire
var is_facing_left = true

#UI
@export var label : Label

#directionment
var direction := Vector2.ZERO
var thrust_vector := Vector2.ZERO

const MAX_SPEED := 120.0
const MAX_THRUST := 12.0
const MAX_BOOSTED_SPEED := 160.0
@export var thrust := 4.5
@export var boost_thrust := 40.0

@onready var animation_player := $AnimationPlayer
#Debugging
@onready var debug_label = label

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
			oxygen_bar.value += oxygen_recovery_rate + oxygen_recovery_rate
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

	if Input.is_action_pressed("left") and !Input.is_action_pressed("action_gun"):
		# printt("Moving Left - No Drill")
		animation_player.play("jetpack_left")
		thrust_vector.x += max(-thrust, -MAX_THRUST)
		is_facing_left = true
		fire_jet_pack()
	
	if Input.is_action_pressed("left") and Input.is_action_pressed("action_gun"):	
		if animation_player.current_animation != "drill_left_loop":
			# printt("Moving Left - With Drill")
			animation_player.play("jetpack_drill_left")
			animation_player.queue("drill_left_loop")
		thrust_vector.x += max(-thrust, -MAX_THRUST)
		is_facing_left = true
		fire_jet_pack()
	
	if Input.is_action_pressed("right") and !Input.is_action_pressed("action_gun"):
		animation_player.play("jetpack_right")
		# printt("Moving Right - No Drill")
		thrust_vector.x += min(thrust, MAX_THRUST)
		is_facing_left = false
		fire_jet_pack()

	if Input.is_action_pressed("right") and Input.is_action_pressed("action_gun"):	
		if animation_player.current_animation != "drill_right_loop":
			# printt("Moving Right - With Drill")
			animation_player.play("jetpack_drill_right")
			animation_player.queue("drill_right_loop")
		thrust_vector.x += min(thrust, MAX_THRUST)
		is_facing_left = false
		fire_jet_pack()
	
	if Input.is_action_pressed("action_gun") and !Input.is_action_pressed("right") and !Input.is_action_pressed("left"): 
		if is_facing_left:
			# printt("Not moving - With Drill Left")
			if animation_player.current_animation != "drill_left_loop":
				animation_player.play("jetpack_drill_left")
				animation_player.queue("drill_left_loop")
				is_facing_left = true
		elif !is_facing_left:
			if animation_player.current_animation != "drill_right_loop":
				# printt("Not moving - With Drill Right")
				animation_player.play("jetpack_drill_right")
				animation_player.queue("drill_right_loop")
				is_facing_left = false

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

	oxygen_bar.value -= oxygen_depletion_value
	#printt("Bar:", str(oxygen_bar.value), "Consumption:", str(oxygen_depletion_value) , "Moving:", str(is_moving))

func player_entered_safe_area():
	is_on_safe_area = true
	printt("Entered safe area")

func player_left_safe_area():
	is_on_safe_area = false
	printt("Left safe area")

func _process(delta): 
	
	label.text = "thrustX: " + str(thrust_vector.x) + " thrustY: " + str(thrust_vector.y)
	#capping FPS logic
	var fps = Engine.get_frames_per_second()
	var lerpInterval = direction / fps
	var lerpPosition = global_transform.origin + lerpInterval

	if fps > 30:
		sprite.global_transform.origin = sprite.global_transform.origin.lerp(lerpPosition, 20 * delta)
	else :
		sprite.global_transform = global_transform

func boost():
	#TODO: puff of gas?
	velocity.x += boost_thrust * Input.get_axis("left", "right")
	velocity.y += boost_thrust * Input.get_axis("up", "down")



func stop_jet_pack() -> void:
	jetpack_fire.visible = false

func fire_jet_pack() -> void:
	jetpack_fire.visible = true

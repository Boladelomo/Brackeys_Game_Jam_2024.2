extends RigidBody2D
var move_direction_vector := Vector2(0, 0)
var move_speed: float = 100

# # Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	move_direction_vector.y = randi_range(-1, 1)
# 	move_direction_vector.x = randi_range(-1, 1)

func _physics_process(delta):
	var velo = move_direction_vector * move_speed * delta
	global_position += move_direction_vector * move_speed * delta

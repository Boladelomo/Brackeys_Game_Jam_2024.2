extends Node

@onready var camera : Camera2D = get_parent().return_camera()
@onready var level_bounds : PackedVector2Array
var screen_margin := 200.0

#TODO: list of asteroids of different sizes

#TODO: setting asteroid speed, rotation and spawn position, 

#TODO: storm patterns (timers, points of entry (plural?) and directions)
func set_outer_bounds():
	var temp = get_viewport().canvas_transform.origin

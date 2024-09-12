extends Node2D

@onready var game_manager: Node2D = $"."

#@onready var asteroid_manager: Node = $AsteroidManager : get = _get_asteroid_manager
	#
#func _get_asteroid_manager():
	#return asteroid_manager

func return_camera() -> Camera2D:

	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is Camera2D:
				print("camera found: " + grandchild.name)
				return grandchild
	return

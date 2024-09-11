extends Node2D

@onready var game_manager: Node2D = $"."

@onready var player_container: Node = $PlayerContainer : get = _get_player_container

func _get_player_container():
	return player_container

@onready var asteroid_manager: Node = $AsteroidManager : get = _get_asteroid_manager
	
func _get_asteroid_manager():
	return asteroid_manager

func return_camera() -> Camera2D:

	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is Camera2D:
				print("camera found: " + grandchild.name)
				return grandchild
	return

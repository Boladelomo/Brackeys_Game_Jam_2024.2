extends Control

func play():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
	
func quit():
	get_tree().quit()

extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_options.tscn")
	
func _on_debug_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

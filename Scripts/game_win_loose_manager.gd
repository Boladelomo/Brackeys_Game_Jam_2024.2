extends Node
class_name GameWinLooseManager


func _ready() -> void:
	Globals.health_depleated_death.connect(_on_game_over)
	Globals.oxygen_depleated_death.connect(_on_game_over)

func _on_ui_oxygen_bar_value_changed(value:float) -> void:
	#if value <= 0:
		#Globals.oxygen_depleated_death.emit(value)
		#Globals.game_over_msg = "You ran out of Oxygen"
		pass

func _on_game_over(value) -> void:
	if value <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	else:
		pass

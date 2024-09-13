extends Control

@onready var game_scene = preload("res://Scenes/game.tscn")
@onready var menu_main_scene = preload("res://Scenes/menu.tscn")
@onready var is_game_session_running:bool = false
@onready var is_game_paused:bool = false
@onready var menu_layer: CanvasLayer = %MenuLayer

@onready var play: Button = %Play
@onready var options: Button = %Options
@onready var debug: Button = %Debug
@onready var quit: Button = %Quit

func intiate_main_menu() -> void:
	show()
	menu_layer.show()
	play.grab_focus()

func _on_play_pressed() -> void:
	if !is_game_session_running:
		var game = game_scene.instantiate()
		is_game_session_running = true
		get_tree().get_root().add_child(game)	
		hide()
		menu_layer.hide()
	
	if is_game_paused:
		get_tree().paused = false
		hide()
		menu_layer.hide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		pause_game_and_show_menu()

func pause_game_and_show_menu() ->	void:
	intiate_main_menu()
	is_game_paused = true
	get_tree().paused = true

func _on_options_pressed() -> void:
	# get_tree().change_scene_to_file("res://scenes/menu_options.tscn")
	pass
	
func _on_debug_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()

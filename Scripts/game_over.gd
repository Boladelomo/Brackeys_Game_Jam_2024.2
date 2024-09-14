extends Control

@onready var game_scene = preload("res://Scenes/game.tscn")
@onready var menu_options_scene = preload("res://scenes/menu_options.tscn")
@onready var menu_main_scene = preload("res://Scenes/menu.tscn")
@onready var loading_menu = preload("res://Scenes/loading_scene.tscn")

@onready var is_game_session_running:bool = false
@onready var is_game_paused:bool = false
@onready var is_game_over:bool = false
@onready var menu_layer: CanvasLayer = %MenuLayer

@onready var restart: Button = %Restart
@onready var options: Button = %Options
@onready var debug: Button = %Debug
@onready var quit: Button = %Quit

@onready var label_msg: Label = $MenuLayer/MarginContainer/VBoxContainer/LabelMsg

func  _ready():
	is_game_over = true
	quit.grab_focus()
	label_msg.text = Globals.game_over_msg
	get_tree().paused = true


func _on_quit_pressed() -> void:
	get_tree().quit()


# func intiate_main_menu() -> void:
# 	show()
# 	menu_layer.show()
# 	restart.grab_focus()

# func _on_restart_pressed() -> void:
# 	if is_game_over:
# 		get_tree().reload_current_scene()
# 		var new_game = loading_menu.instantiate()
# 		get_tree().get_root().add_child(new_game)	


# 	# if !is_game_session_running:
# 	# 	var game = game_scene.instantiate()
# 	# 	is_game_session_running = true
# 	# 	get_tree().get_root().add_child(game)	
# 	# 	hide()
# 	# 	menu_layer.hide()
	
# 	# if is_game_paused:
# 	# 	get_tree().paused = false
# 	# 	hide()
# 	# 	menu_layer.hide()

# # func _unhandled_key_input(event: InputEvent) -> void:
# # 	if event.is_action_pressed("pause_menu"):
# # 		pause_game_and_show_menu()

# func pause_game_and_show_menu() ->	void:
# 	intiate_main_menu()
# 	is_game_paused = true
# 	get_tree().paused = true

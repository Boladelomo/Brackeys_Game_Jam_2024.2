extends Control
@onready var menu_main_scene = preload("res://Scenes/menu.tscn")

func _ready() -> void:
	Menu.intiate_main_menu()
	queue_free()
	

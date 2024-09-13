extends Node2D

@onready var news_panel_text_box: LineEdit = %NewsPanelTextBox
@onready var news_panel_bg_color: ColorRect = %NewsPanelBgColor
@onready var news_panel: PanelContainer = %NewsPanel
@onready var label_storm_number: Label = %LabelStormNumber
@onready var game_manager: Node2D = $"."
@onready var uioxygen_bar: ProgressBar = %UIOxygenBar
#@onready var asteroid_manager: Node = $AsteroidManager : get = _get_asteroid_manager
	#
#func _get_asteroid_manager():
	#return asteroid_manager
var storm_count:int=0

func _ready():
	Globals.oxygen_changed.connect(update_oxygen_bar)
	Globals.storm_has_started.connect(update_storm_ui_count)
	Globals.storm_notification.connect(update_news_panel_text)
	news_panel.visible = false

	startup_text()



func return_camera() -> Camera2D:

	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is Camera2D:
				print("camera found: " + grandchild.name)
				return grandchild
	return

func update_oxygen_bar(value, to_reduce_value) -> void:
	if to_reduce_value:
		uioxygen_bar.value -= value
	else:
		uioxygen_bar.value += value

func update_storm_ui_count() -> void:
	storm_count += 1
	label_storm_number.text = str(storm_count)

func startup_text() -> void:
	await get_tree().create_timer(3).timeout
		# Start Message
	await update_news_panel_text("Drill Large Asteroids to earn Oxygen", Color.WHITE)
	await update_news_panel_text("Avoid Small Asteroids, they are dangerous", Color.WHITE)
	await update_news_panel_text("Take shelter from the storm on large asteroids", Color.WHITE)
	await update_news_panel_text("Survive 10 Storms to Win", Color.WHITE)

func update_news_panel_text(text_to_update, bgcolor) -> void:
	news_panel.visible = true
	news_panel_bg_color.color = bgcolor
	news_panel_text_box.text = text_to_update

	await get_tree().create_timer(4).timeout
	news_panel.visible = false
	news_panel_bg_color.color = Color.WHITE
	news_panel_text_box.text = ""
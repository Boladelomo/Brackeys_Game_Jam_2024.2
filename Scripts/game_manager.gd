extends Node2D
class_name MainGameManager
@onready var hearts: Control = %Hearts
@onready var news_panel_text_box: LineEdit = %NewsPanelTextBox
@onready var news_panel_bg_color: ColorRect = %NewsPanelBgColor
@onready var news_panel: PanelContainer = %NewsPanel
@onready var label_heart: Label = %LabelHeart
@onready var label_storm_number: Label = %LabelStormNumber
@onready var game_manager: Node2D = $"."
@onready var uioxygen_bar: ProgressBar = %UIOxygenBar
var hearts_array : Array = []
#@onready var asteroid_manager: Node = $AsteroidManager : get = _get_asteroid_manager
	#
#func _get_asteroid_manager():
	#return asteroid_manager
var storm_count:int=0

func _ready():
	Globals.oxygen_changed.connect(update_oxygen_bar)
	Globals.storm_has_started.connect(update_storm_ui_count)
	Globals.storm_notification.connect(update_news_panel_text)
	Globals.health_updated.connect(update_health_bar)
	news_panel.visible = false

	startup_text()
	load_hearts()

func load_hearts() -> void:
	var index = 0
	for i in hearts.get_children():
		hearts_array.append(i)
		update_heart(index, Globals.player_health)
		index += 1
	
	label_heart.text = "Lifes: " +str( Globals.player_health )
	
	

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

func update_health_bar(value) -> void:
	label_heart.text = "Lifes: " + str( value )
	for i in hearts_array.size():
		update_heart( i, value )
		
		
func update_heart( index : int, hp : int ) -> void:
	var heart_value : int = clampi( hp - index * 2, 0, 2 )
	hearts_array[ index ].value = heart_value

func startup_text() -> void:
	await get_tree().create_timer(8).timeout
		# Start Message
	await update_news_panel_text("Mission Control: Kowalski, hang on! We didn't forget about you, the shuttle is coming back!!", Color.WHITE)
	await update_news_panel_text("The gravitational anomaly seems to be passing by, but asteroids are still crashing into each other!", Color.WHITE)
	await update_news_panel_text("Do your best to hide behind the larger stationary asteroids and remember...", Color.WHITE)
	await update_news_panel_text("Stay Calm before the Storm!™", Color.WHITE)

func update_news_panel_text(text_to_update, bgcolor) -> void:
	news_panel.visible = true
	news_panel_bg_color.color = bgcolor
	news_panel_text_box.text = text_to_update

	await get_tree().create_timer(4).timeout
	news_panel.visible = false
	news_panel_bg_color.color = Color.WHITE
	news_panel_text_box.text = ""

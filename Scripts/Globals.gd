extends Node

signal health_updated(value)
signal health_depleated_death(value)

signal oxygen_changed(value, reduce_value)
signal oxygen_depleated_death(value)

signal storm_has_started

signal storm_notification(text_to_update, bgcolor)

var game_over_msg: String = ""


var player_health = 6:
	set(value):
		player_health = value
		health_updated.emit(player_health)
		if player_health <= 0:
			health_depleated_death.emit(player_health)
			game_over_msg = "You lost all your lifes"

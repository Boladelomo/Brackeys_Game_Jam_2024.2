extends Node2D

@export var fragment_images : Array[Texture]
@export var death_image : Texture
@export var MAX_FRAGMENTS := 8

@onready var fragments : Array[Node2D]

func randomize_fragments():
	pass


#TODO: 10% fragments as actual projectiles? low enough to prevent chain reaction, adds flavour
#TODO: push fragments away from center
#TODO: flicker death_sprite for .2 sec (go from black to white by adjusting color a few times really fast)
#TODO: hooks for sfx logic
#TODO: random speed vectors for fragment nodes

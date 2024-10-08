@tool
extends Resource
class_name AsteroidClassResource

enum asteroid_group_sizes{LARGE, MEDIUM, SMALL}
@export var asteroid_size:= asteroid_group_sizes.MEDIUM : 
	get : return asteroid_size
@export var asteroid_speed : float = 20.0
@export var sprite_texture : Texture2D
@export var is_cover : bool = false
var sprite_scale : float
var asteroid_radius : float

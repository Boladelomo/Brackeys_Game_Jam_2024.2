extends Area2D

enum AsteroidState { EMPTY, USED, DAMAGED }

var is_being_drilled: bool = false
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var radius : get = _get_radius, set = _set_radius
func _get_radius():
	return radius
func _set_radius(value):
	radius = value

@export var safe_radius := 75.0

var safe_color := Color.AQUAMARINE
var empty_color := Color.WHITE
var damage_color := Color.CRIMSON
var current_color := empty_color

var collided:= false
var collision_object : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_radius(safe_radius)
	collider.shape.radius = _get_radius()
	collider.position = position
	queue_redraw()
	print("asteroid")
	print(str(_get_radius()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#TODO: OPTIONAL asteroid coloring (flickering between damage-safe or damage-empty for 500ms after a hit)
	if (collided):
		if check_player_overlap(collision_object):
			current_color = safe_color
		else:
			current_color = empty_color


func _draw() -> void:
	draw_circle(position, radius, current_color)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		collided = true
		collision_object = body
		if body.has_method("player_entered_safe_area"):
			body.player_entered_safe_area()
	queue_redraw()


func check_player_overlap(player: CharacterBody2D) -> bool:	
	var rect = player.find_child("CollisionShape2D").get_shape().get_rect()
	#TODO: change to "all corners inside circ collider"
	var top_right = Vector2(rect.size.x, rect.position.y)
	var bottom_left = Vector2(rect.position.x, rect.size.y)
	var center = collider.position
	
	#checks that every corner of the player collider is within radius 
	return (center.distance_to(rect.position) < radius
	and center.distance_to(rect.position) < radius
	and center.distance_to(top_right) < radius
	and center.distance_to(bottom_left) < radius
	)
	
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		collided = false
		if body.has_method("player_left_safe_area"):
			body.player_left_safe_area()
	queue_redraw()

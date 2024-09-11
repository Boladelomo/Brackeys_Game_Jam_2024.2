extends Area2D

enum AsteroidState { EMPTY, USED, DAMAGED }

@onready var collider: CollisionShape2D = $CollisionShape2D
@export var safe_radius := 75.0
@export var min_radius := 8.0
@export	var max_radius := 95.0

var safe_color := Color.AQUAMARINE
var empty_color := Color.WHITE
var damage_color := Color.CRIMSON

var current_color := empty_color

var collided:= false
var target_position : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#collider.shape.radius = safe_radius
	collider.position = position
	queue_redraw()
	#print(collider.shape.radius)
	#print(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#solve asteroid state
	# re draw after a change of state
	#asteroid coloring (flickering between damage-safe or damage-empty for 500ms after a hit)
	pass

func _draw() -> void:
	draw_circle(position, safe_radius, current_color)
	#draw_line(position, Vector2.UP * safe_radius, Color.WHITE, 2.0, false)
	#if collided and target_position:
		#draw_line(target_position, position, Color.RED, 4.0, false)

#TODO: change to full overlap of player collider (inside asteroid)
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		current_color = safe_color
		collided = true
		target_position = body.position
	queue_redraw()

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		current_color = empty_color
		collided = false
	queue_redraw()

extends Area2D

enum AsteroidState { EMPTY, USED, DAMAGED }

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var safe_radius := 50.0

var safe_color := Color.AQUAMARINE
var empty_color := Color.WHITE
var damage_color := Color.CRIMSON

var current_color := empty_color

var collided:= false
var target_position : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape_2d.shape.radius = safe_radius
	collision_shape_2d.position = position
	queue_redraw()
	print(collision_shape_2d.shape.radius)
	print(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#solve asteroid state
	# re draw after a change of state
	#asteroid coloring (flickering between damage-safe or damage-empty for 500ms after a hit)
	pass

func _draw() -> void:
	draw_circle(position, safe_radius, current_color)
	#draw_line(position, Vector2.UP * safe_radius, Color.WHITE, 2.0, false)
	if collided and target_position:
		draw_line(target_position, position, Color.RED, 4.0, false)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player": #TODO: use another way to ID the player, avoid hardcoded strings
		print("player X: " + str(body.position.x) + ", player Y: " + str(body.position.y))
		print("asteroid X: " + str(position.x) + ", asteroid Y: " + str(position.y))
		current_color = safe_color
		collided = true
		target_position = body.position
	queue_redraw()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		current_color = empty_color
		collided = false
	queue_redraw()

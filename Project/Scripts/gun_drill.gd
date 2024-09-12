extends Node2D

@onready var gun_hitbox_area :Area2D = %GunHitBoxArea2D
var is_drillgun_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivate_drilling_gun(true)
	gun_hitbox_area.area_entered.connect(on_gun_hitbox_area_entered)

#TODO: change logic so aoe collision checks aren't done every frame, signals/events
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_drillgun_active:
		monitor_for_drill_asteroids()


func monitor_for_drill_asteroids() -> void:
	var overlaping_areas = gun_hitbox_area.get_overlapping_areas()
	for area in overlaping_areas:
		if area.is_in_group("asteroid"):
			drill_asteroid_area(area)

func drill_asteroid_area(area) -> void:
	# if area.is_being_drilled == false:
	# 	area.is_being_drilled = true
	printt("Drilling the Asteroid:", str(area.name))

func on_gun_hitbox_area_entered(area):
	if area.is_in_group("asteroid"):
		drill_asteroid_area(area)
		
func activate_drilling_gun() -> void:
	if !is_drillgun_active:
		is_drillgun_active = true
		gun_hitbox_area.visible = true
		gun_hitbox_area.monitorable = true
		gun_hitbox_area.monitoring = true

		printt("Drilling Gun Activated")

func deactivate_drilling_gun(forced:bool = false) -> void:
	if is_drillgun_active or forced:
		is_drillgun_active = false
		gun_hitbox_area.visible = false
		gun_hitbox_area.monitorable = false
		gun_hitbox_area.monitoring = false
		printt("Drilling Gun Deactivated")

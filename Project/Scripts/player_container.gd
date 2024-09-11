extends Node

@onready var spawns : Array[Area2D] : get = _get_spawn_points

func _get_spawn_points():
	var index := 0
	for spawn in get_children(): 
		spawns.insert(index, spawn)
		++index
		if index > get_child_count():
			index = get_child_count()
	print("total asteroid spawns: ")
	print(spawns.size())
	return spawns

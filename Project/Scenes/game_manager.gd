extends Node2D

#loop through child nodes, store the one with a camera2d, return said camera


func return_camera() -> Camera2D:

	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is Camera2D:
				print("camera found: " + grandchild.name)
				return grandchild
	return

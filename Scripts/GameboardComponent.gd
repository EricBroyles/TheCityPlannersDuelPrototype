extends Node2D

class_name GameboardComponent

#tile, item, agent

func get_oriented_size() -> Vector2:
	return Vector2(0,0)

func get_top_left_position() -> Vector2:
	var size: Vector2 = get_oriented_size() #this calls the lowest level version of this
	return position - size / 2

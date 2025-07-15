extends Node2D
class_name GameboardComponent

#tile, item, agent

func get_oriented_size() -> Vector2:
	return Vector2(0,0)

func get_top_left_position() -> Vector2:
	return position - get_oriented_size() / 2.0 #this calls the lowest level version of get_oriented_size this

	

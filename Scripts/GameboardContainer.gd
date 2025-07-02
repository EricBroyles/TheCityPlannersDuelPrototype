extends Node

class_name GameboardContainer

var r: int
var c: int

var components: Array[GameboardComponent]

func add(component: GameboardComponent):
	components.append(component)
	
func remove(component: GameboardComponent):
	if component in components:
		components.erase(component)

func get_coord() -> Vector2:
	return Vector2(r,c)

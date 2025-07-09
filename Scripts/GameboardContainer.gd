extends Resource

class_name GameboardContainer

var center_position: Vector2 #(x,y)
var components: Array[GameboardComponent]




func add(component: GameboardComponent):
	components.append(component)
	
func remove(component: GameboardComponent):
	if component in components:
		components.erase(component)

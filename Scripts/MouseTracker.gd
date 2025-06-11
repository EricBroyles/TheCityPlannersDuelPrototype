extends Node


var click_area_size: Vector2

func _ready() -> void:
	click_area_size = self.size
	print(click_area_size)
	
func update_position():
	self.position = GameData.mouse_position - click_area_size/2

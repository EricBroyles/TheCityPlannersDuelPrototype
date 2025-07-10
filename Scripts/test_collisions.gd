extends Node




func _on_right_area_entered(area: Area2D) -> void:
	print("collided with area: ", area, " at ", area.position)

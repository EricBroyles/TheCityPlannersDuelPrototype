extends GameboardItem


#Elevation: 0 
#Level: 0 (it does not have levels)
#max_level: 0 (it does not have levels)

func _init():
	type = GAMEBOARD.ROAD_2_LANE["type"]
	main_body_texture = preload("res://Assets/Roads/Straights/Road 2 Lane.svg")
	size = main_body_texture.get_size()
	
	##NOTE: this sets the z_index for this item
	z_index = GAMEBOARD.ROAD_2_LANE["z_index"]

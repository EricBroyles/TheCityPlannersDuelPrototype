extends ParkingLot


#Elevation: 0 
#Level: 0 (it does not have levels)
#max_level: 0 (it does not have levels)

func _init():
	type = GAMEBOARD.PARKING_LOT_2X2["type"]
	main_body_texture = preload("res://Assets/Parking/Parking Lot 2x2.svg")
	size = main_body_texture.get_size()
	
	##NOTE: this sets the z_index for this item
	z_index = GAMEBOARD.PARKING_LOT_2X2["z_index"]
	

	
	

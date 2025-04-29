extends GameboardItem

class_name ParkingLot1x1


#Elevation: 0 
#Level: 0 (it does not have levels)
#max_level: 0 (it does not have levels)

func _init():
	type = TYPES.PARKING_LOT_1X1
	
func _ready():
	main_body = $MainBody
	

#func _process(delta: float) -> void:
	#print(get_corner_positions())


## ---- Transform ----
func flip_h():
	super()
	
	##NOTE: this actually flips the main body and all its supnodes
	main_body.flip_h = real_orientation["flip_h"]
	
func flip_v():
	super()
	
	##NOTE: this actually flips the main body and all its supnodes
	main_body.flip_v = real_orientation["flip_v"]
	
		
## ---- Position ----
	





##have a method that pulls all map items 

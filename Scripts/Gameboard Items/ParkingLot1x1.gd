extends ParkingLot

class_name ParkingLot1x1

@onready var curtain_2_lane = $Curtain2Lane
@onready var curtain_4_lane = $Curtain4Lane
@onready var parking_spots = $ParkingSpots
@onready var zone_walkways_container = $ZoneWalkwaysContainer
@onready var zone_navigation_container_car = $ZoneNavigationContainerCar


#Elevation: 0 
#Level: 0 (it does not have levels)
#max_level: 0 (it does not have levels)

func _init():
	type = GAMEBOARD.PARKING_LOT_1X1["type"]
	
	##NOTE: this sets the z_index for this item
	z_index = GAMEBOARD.PARKING_LOT_1X1["z_index"]
	
func _ready():
	#main_body = $MainBody
	pass
	
	
	
func reset_real_orientation():
	#this will need to be much stronger to clear out any possible changes and set all items back to original. 
	pass
#func _process(delta: float) -> void:
	#
	

func orient5():
	pass
	
func orient6():
	pass
	
func orient7():
	pass
	
func orient8():
	pass

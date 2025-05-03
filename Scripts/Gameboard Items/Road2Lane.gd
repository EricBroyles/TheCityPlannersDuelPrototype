extends GameboardItem

class_name Road2Lane
@onready var left_parking = $Parking/LeftParking
@onready var right_parking = $Parking/RightParking
@onready var zone_left_parking = $Parking/ZoneLeftParking
@onready var zone_right_parking = $Parking/ZoneRightParking

#Elevation: 0 
#Level: 0 (it does not have levels)
#max_level: 0 (it does not have levels)

var is_parking: bool = false
var left_parking_active: bool = false
var right_parking_active: bool = false

var left_parking_spots: Array[Vector2]
var right_parking_spots: Array[Vector2]

func _init(parking: bool = false):
	type = GAMEBOARD.ROAD_2_LANE["type"]
	main_body_texture = preload("res://Assets/Roads/Straights/Road 2 Lane.svg")
	size = main_body_texture.get_size()
	
	if parking:
		is_parking = true
		left_parking_active = true
		right_parking_active = true
		
	##NOTE: this sets the z_index for this item
	z_index = GAMEBOARD.ROAD_2_LANE["z_index"]
	
func _ready():
	set_parking()
	

func set_parking():
	left_parking.visible = left_parking_active
	right_parking.visible = right_parking_active
	
	zone_left_parking.monitoring = left_parking_active
	zone_right_parking.monitoring = right_parking_active
	
func get_parking_spots():
	##usig the smallest amount of available information this computes where all the parking spots are
	pass
	
	
##I will have my zones and wait when they experience a on enter then I check what has enetered them and depening on that
## I will toggle

#USer is going to be placing with is_parking = false or is_parking = true. 
#if is_parking is true then full or half parking is decided as you try and place it (for now just assume that it is full parking)
#half parking has nothing to do with the flip

func flip_h_real_orientation():
	##NOTE: This asset is fully symmetric about horizontal axis so flipping this symmetric asset does nothing execpt change orientation of axis
	return
	
func flip_v_real_orientation():
	##NOTE: This asset is fully symmetric about vertical axis so flipping this symmetric asset does nothing execpt change orientation of axis
	return

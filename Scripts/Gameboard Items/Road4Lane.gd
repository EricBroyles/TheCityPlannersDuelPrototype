extends GameboardItem

class_name Road4Lane

@onready var left_parking = %LeftParking
@onready var right_parking = %RightParking
@onready var left_parking_hitbox = %LeftParkingHitbox
@onready var right_parking_hitbox = %RightParkingHitbox

@onready var left_parking_col = $Parking/LeftParkingColumn

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20

var is_parking: bool = false
var left_parking_active: bool = false
var right_parking_active: bool = false

func _init() -> void:
	self.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE #the size to begin with
	self.elevation = 0 #Elevation: 0 base, .5 (halfway), 1 (up a level)
	self.level = 0 #Levels: 0 means that it does not have levels, otherwise starts at level 1
	self.max_level = 0
	
func _ready():
	z_index = ITEM_Z
	
	
func set_parking():
	left_parking.visible = left_parking_active
	right_parking.visible = right_parking_active
	
	#zone_left_parking.monitoring = left_parking_active
	#zone_right_parking.monitoring = right_parking_active
	
	
	
	

# I need a way to take in a hitbox and tell information from it

	
#extends GameboardItem
#
#class_name Road2Lane
#@onready var left_parking = $Parking/LeftParking
#@onready var right_parking = $Parking/RightParking
#@onready var zone_left_parking = $Parking/ZoneLeftParking
#@onready var zone_right_parking = $Parking/ZoneRightParking
#@onready var left_parking_col = $Parking/LeftParkingColumn
#
##Elevation: 0 
##Level: 0 (it does not have levels)
##max_level: 0 (it does not have levels)
#
#var is_parking: bool = false
#var left_parking_active: bool = false
#var right_parking_active: bool = false



#func _init(parking: bool = false):
	#type = GameConstants.ROAD_2_LANE["type"]
	#main_body_texture = preload("res://Assets/Roads/Straights/Road 2 Lane.svg")
	#size = main_body_texture.get_size()
	#
	#if parking:
		#is_parking = true
		#left_parking_active = true
		#right_parking_active = true
		#
	###NOTE: this sets the z_index for this item
	#z_index = GameConstants.ROAD_2_LANE["z_index"]
	#
#func _ready():
	#set_parking()
	#
#
#func set_parking():
	#left_parking.visible = left_parking_active
	#right_parking.visible = right_parking_active
	#
	#zone_left_parking.monitoring = left_parking_active
	#zone_right_parking.monitoring = right_parking_active
	#
#func get_parking_spots() -> Dictionary:
	#var left_col_spot: Vector2 = left_parking_col.position
	#return {"left_col":  [left_col_spot, Vector2(left_col_spot.x, -left_col_spot.y)],
			#"right_col": [Vector2(-left_col_spot.x, left_col_spot.y), Vector2(-left_col_spot.x, -left_col_spot.y)]
	#} 
	#
	#
###I will have my zones and wait when they experience a on enter then I check what has enetered them and depening on that
### I will toggle
#
##USer is going to be placing with is_parking = false or is_parking = true. 
##if is_parking is true then full or half parking is decided as you try and place it (for now just assume that it is full parking)
##half parking has nothing to do with the flip
#
#func flip_h_real_orientation():
	###NOTE: This asset is fully symmetric about horizontal axis so flipping this symmetric asset does nothing 
	#return
	#
#func flip_v_real_orientation():
	###NOTE: This asset is fully symmetric about vertical axis so flipping this symmetric asset does nothing
	#return

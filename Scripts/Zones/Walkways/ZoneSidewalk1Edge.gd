extends ZoneWalkway

##Purpose: This Sidewalk Hitbox is intended to allow me to detect when I should be placing a Sidewalk

##Hitbox Size
#width = 200 - 16
#height = 8
##Hitbox Position
#x = 0
#y = 96

func _ready():
	request_walkway_type = GAMEBOARD.SIDEWALK_1_EDGE["type"]

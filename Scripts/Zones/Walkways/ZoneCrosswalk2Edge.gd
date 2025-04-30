extends ZoneWalkway

##Purpose: This Crosswalk 2 Hitbox is intended to allow me to detect when I should be placing a Crosswalk 2 Edge

##Hitbox Size
#width = (200 - 16) * 2
#height = 8
##Hitbox Position
#x = 0
#y = 96


func _ready():
	request_walkway_type = GAMEBOARD.CROSSWALK_2_EDGE["type"]

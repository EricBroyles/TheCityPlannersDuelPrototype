extends ZoneWalkway

##Purpose: This Crosswalk 1 Hitbox is intended to allow me to detect when I should be placing a Crosswalk 1 Edge

##Hitbox Size
#width = 200 - 16
#height = 8
##Hitbox Position
#x = 0
#y = 96

func _ready():
	request_walkway_type = GameConstants.CROSSWALK_1_EDGE["type"]

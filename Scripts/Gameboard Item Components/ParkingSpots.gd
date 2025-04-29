extends Node2D

## Purpose:
#  To store for easy access all ParkingSpot within a ParkingSpots Node
#  This will also handle placing cars as children of the ParkingSpots (for both parking lots and parking on roads)
#  Assumes that the children of this Node2D (called PakringSpots) are called ParkingSpot and have a position and rotation assigned
#  Assumes that the only children are ParkingSpot 

var parking_spots: Array[Node]

func _ready() -> void:
	parking_spots = get_children()
	
	#print(parking_spots[0].position)
##this needs fucntions that allow me to just add a car arbritraily (parking lots), vs add one to a specific spot (decided outside this) for roads with parking

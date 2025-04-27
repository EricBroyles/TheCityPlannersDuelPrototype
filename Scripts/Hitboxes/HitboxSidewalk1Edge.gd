extends Area2D

##Purpose: This Sidewalk Hitbox is intended to allow me to detect when I should be placing a Sidewalk

##Hitbox Size
#width = 200 - 16
#height = 8
##Hitbox Position
#x = 0
#y = 92

const TYPES = preload("res://Scripts/Constants/GameboardItemTypes.gd")
var request_walkway_type: String = TYPES.SIDEWALK_1_EDGE

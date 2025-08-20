extends Node2D

var speed = 100
var accel = 7

@onready var camera = %Camera
	
func _ready() -> void:
	## Setup Camera
	var limits: Array[float] = [4000.0]
	camera.custom_camera_limits(limits)
	camera.position = Vector2(2000,1600)

	
	

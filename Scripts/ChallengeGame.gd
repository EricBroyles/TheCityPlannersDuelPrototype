extends Node

@onready var camera = $Camera
@onready var gameboard = $Gameboard

func _ready() -> void:
	## Setup gameboard
	gameboard.make_gameboard()
	
	## Setup Camera
	camera.center_camera(gameboard)
	camera.set_camera_limits(gameboard)
	 
func _process(_delta: float) -> void:
	GameData.mouse_position = camera.get_global_mouse_position()
	

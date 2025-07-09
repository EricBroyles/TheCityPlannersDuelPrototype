extends Node

@onready var camera = $Camera
@onready var gameboard = $Gameboard





func _ready() -> void:
	## Setup gameboard
	gameboard.make_gameboard()
	gameboard.init_matrix()
	
	## Setup Camera
	camera.center_camera(gameboard)
	camera.set_camera_limits(gameboard)
	 


func _process(_delta: float) -> void:
	GameData.mouse_position = camera.get_global_mouse_position()
	


	#var ParkingLot2x2Scene: PackedScene = preload("res://Scenes/Gameboard Items/ParkingLot2x2.tscn")
	
	###TEST: for the orientations
	#var gameitem_1 = ParkingLot2x2Scene.instantiate()
	#var shift = gameitem_1.get_oriented_size()
	#
	###Normal orientation
	#add_child(gameitem_1)
	#gameitem_1.position += shift
	#
	###ROTATE 90
	#var gameitem_2 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_2) ##NOTE: always add the child before you try and update it
	#gameitem_2.rotate_90_cw(1) ##TEST
	#
	#gameitem_2.position += gameitem_1.position
	#gameitem_2.position.x +=  (shift.x * 1.25)
	#
	#
	###ROTATE 180
	#var gameitem_3 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_3) ##NOTE: always add the child before you try and update it
	#gameitem_3.rotate_90_cw(2) ##TEST
	#
	#gameitem_3.position += gameitem_2.position
	#gameitem_3.position.x += (shift.x * 1.25)
	#
	#
	###ROTATE 270
	#var gameitem_4 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_4) ##NOTE: always add the child before you try and update it
	#gameitem_4.rotate_90_cw(3) ##TEST
	#
	#gameitem_4.position += gameitem_3.position
	#gameitem_4.position.x += (shift.x * 1.25)
	#
	#
	### Flip V
	#var gameitem_5 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_5) ##NOTE: always add the child before you try and update it
	#gameitem_5.flip_v()
	#
	#gameitem_5.position += gameitem_1.position
	#gameitem_5.position.y += (shift.y * 1.25)
	#
	### FLip H
	#var gameitem_6 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_6) ##NOTE: always add the child before you try and update it
	#gameitem_6.flip_h()
	#
	#gameitem_6.position += gameitem_2.position
	#gameitem_6.position.y += (shift.y * 1.25)
	#
	### Flip V , rot 90
	#var gameitem_7 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_7) ##NOTE: always add the child before you try and update it
	#gameitem_7.flip_v()
	#gameitem_7.rotate_90_cw(1)
	#
	#gameitem_7.position += gameitem_3.position
	#gameitem_7.position.y += (shift.y * 1.25)
	#
	### Flip H, rot 90
	#var gameitem_8 = ParkingLot2x2Scene.instantiate()
	#add_child(gameitem_8) ##NOTE: always add the child before you try and update it
	#gameitem_8.flip_h()
	#gameitem_8.rotate_90_cw(1)
	#
	#gameitem_8.position += gameitem_4.position
	#gameitem_8.position.y += (shift.y * 1.25)

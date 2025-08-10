extends Node

@onready var path = %Path2D
@onready var follower = %PathFollow2D

enum SIM_STATUS {
	PAUSED,
	ACTIVE,
}

var simulation_time: float = 0 #seconds

var car_speed = 15 #mph

var car_tile_per_sec: float = car_speed / GameConstants.MILES_PER_TILE / 60 / 60
var car_pixel_per_sec: float = car_tile_per_sec * GameConstants.GAMEBOARD_TILE_SIZE
var sim_status: int = SIM_STATUS.PAUSED

#need system to concatentate a path. of various speeds, turns, stopping point, pause points, etc. deactivate collision points
#how to get cars to merge onto the same raod via merge or turing, how to get cars to change lanes. 
#get cars of differing speeds to not collide with each other.
#each car will have its own path but they need to know when they are ontop of another car. 

#car leaves parking lot and car driving need to not collide
#allow cars to drive slower than  speed limit.

#just do a check to see if the lanes you are crossing and entering are occupied.
#oncumming traffic that is inturupted by turning traffic should stop until clear.

func _ready() -> void:
	print( path.curve.get_baked_length())


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		if sim_status == SIM_STATUS.PAUSED: sim_status = SIM_STATUS.ACTIVE 
		else: sim_status = SIM_STATUS.PAUSED

func _process(delta: float) -> void:
	if sim_status == SIM_STATUS.ACTIVE:
		follower.progress += car_pixel_per_sec * delta
	pass

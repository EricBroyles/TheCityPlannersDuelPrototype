extends Node
class_name Car

@onready var path = %Path
@onready var follower = %Follower
@onready var blue_body = %BlueBody
@onready var bronze_body = %BronzeBody

enum COLORS {
	BLUE,
	BRONZE,
}

var speed: float
var color: int
var curve: Curve2D
var collision_radius_pixels: int = 6 

static func create(the_curve: Curve2D = Curve2D.new(), the_color: int = COLORS.BLUE) -> Car:
	var car: Car = GameComponents.CAR.instantiate()
	car.curve = the_curve
	car.color = the_color
	return car
	
func _ready() -> void:
	set_color(color)
	set_path(curve)

func set_path(the_curve: Curve2D):
	#dont call until ready
	path.curve = the_curve

func set_speed(spd: float):
	speed = spd
	
func set_rotation(rot_deg: float):
	blue_body.rotation_degrees = rot_deg
	bronze_body.rotation_degrees = rot_deg
	
func set_color(the_color: int):
	#dont call until ready
	match the_color:
		COLORS.BLUE:
			blue_body.visible = true
			bronze_body.visible = false
		COLORS.BRONZE:
			blue_body.visible = false
			bronze_body.visible = true
	
func get_tile_per_sec() -> float:
	return speed / GameConstants.MILES_PER_TILE / 60 / 60
	
func get_pixels_per_sec() -> float:
	return  get_tile_per_sec() * GameConstants.GAMEBOARD_TILE_SIZE
	
func get_pixels_per_tick() -> float:
	return get_pixels_per_sec() / GameData.ticks_per_sec
	
func tick_step():
	follower.progress += get_pixels_per_tick()
	
#func on_collision_path_with(other: Car) -> bool:
	#var self_path_proj: Array[Vector2] = path_projection()
	#var other_path_proj: Array[Vector2] = other.path_projection()
	#collision_radius_pixels
	#
	#return 
	
func path_projection(ticks: int) -> Array[Vector2]:
	var path_proj: Array[Vector2] = []
	var start_progress = follower.progress
	var step = get_pixels_per_tick()
	
	for tick in ticks:
		follower.progress = start_progress + tick * step
		path_proj.append(follower.position)
	
	# restore follower
	follower.progress = start_progress
	
	return path_proj

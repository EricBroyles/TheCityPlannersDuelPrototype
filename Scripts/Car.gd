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
	
func get_pixels_per_tick(ticks_per_sec: float) -> float:
	return get_pixels_per_sec() / ticks_per_sec
	
func handle_tick(ticks_per_sec: float):
	follower.progress += get_pixels_per_tick(ticks_per_sec)

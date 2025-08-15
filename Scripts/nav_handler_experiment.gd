extends Node

@onready var right_turn = %RightTurn

enum SIM_STATUS {
	PAUSED,
	ACTIVE,
}

var car_speed = 15 #mph

var simulation_status: int = SIM_STATUS.PAUSED
var simulation_ticks: int = 0
var ticks_per_sec: int = 60
var next_tick_progress: float = 0

var lane_start: Vector2 = Vector2(300,330)
var lane_end: Vector2 = Vector2(3300,330)
var lane_cars: Array[Car]
var turning_car: Car
var all_cars: Array[Car]

func _ready() -> void:
	var lane_spot: Vector2 = lane_start
	while lane_spot.x < lane_end.x - 200:
		var lane_curve: Curve2D = Curve2D.new()
		lane_curve.add_point(lane_spot)
		lane_curve.add_point(lane_end)
		var car: Car = Car.create(lane_curve)
		car.set_speed(car_speed)
		lane_cars.append(car)
		
		lane_spot.x += 200
	
	for lane_car in lane_cars:
		add_child(lane_car)
	
	turning_car = Car.create(right_turn.curve, Car.COLORS.BRONZE)
	turning_car.set_speed(car_speed)
	add_child(turning_car)
	
	for car in lane_cars:
		all_cars.append(car)
	all_cars.append(turning_car)

	

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		if simulation_status == SIM_STATUS.PAUSED: simulation_status = SIM_STATUS.ACTIVE 
		else: simulation_status = SIM_STATUS.PAUSED

func _process(delta: float) -> void:
	if simulation_status == SIM_STATUS.ACTIVE:
		next_tick_progress += delta * ticks_per_sec
		if next_tick_progress < 1: return
		next_tick_progress = 0
		simulation_ticks += 1
		## DO THE TICKS ACTIONS
		
		for car in all_cars:
			car.handle_tick(ticks_per_sec)
		
		
		#follower.progress += car_pixel_per_sec * delta




#need system to concatentate a path. of various speeds, turns, stopping point, pause points, etc. deactivate collision points
#how to get cars to merge onto the same raod via merge or turing, how to get cars to change lanes. 
#get cars of differing speeds to not collide with each other.
#each car will have its own path but they need to know when they are ontop of another car. 

#car leaves parking lot and car driving need to not collide
#allow cars to drive slower than  speed limit.

#just do a check to see if the lanes you are crossing and entering are occupied.
#oncumming traffic that is inturupted by turning traffic should stop until clear.

##TODO
#create car in the parking lot ready to turn right.
#create up to 16 cars at the lane spot
#assign the appropriate path to each car
#on space bar pressed. activate the simulation. for each car tell them to attempt to procede on its path
#each car needs to check that its forward path is not interesecting with the forward path of any other cars
	# be sure to use the circle with some radius to check collisions along its path
#each car also needs to check its occupied path (just the point the car is currently at)
#use a 3 second rule for straight lines and a 5 second rule for turing. When somthing enters that 3 second rule begin to slow down by 50%, if in 1 second come to a stop
#how to handle simulation tick speed... I want to be able to speed up the simulatuion at will, pause at will 



	

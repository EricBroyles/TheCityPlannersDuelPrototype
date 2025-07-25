extends Node2D

var speed = 100
var accel = 7

@onready var camera = %Camera
@onready var gameboard = %Gameboard
@onready var agent1 = %Agent1
@onready var nav_agent1: NavigationAgent2D = %NavigationAgent1
var end_point: Vector2 = Vector2(1188, 294)
	
func _ready() -> void:
	## Setup gameboard
	gameboard.make_gameboard()
	
	## Setup Camera
	#camera.center_camera(gameboard)
	camera.set_camera_limits(gameboard)

func _physics_process(delta: float) -> void:
	
	nav_agent1.target_position = end_point
	
	var direction_agent1: Vector2 = nav_agent1.get_next_path_position() - agent1.global_position
	direction_agent1 = direction_agent1.normalized()

	agent1.velocity = agent1.velocity.lerp(direction_agent1 * speed, accel * delta)
	
	agent1.move_and_slide()
	
	

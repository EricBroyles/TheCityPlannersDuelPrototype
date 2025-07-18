extends Camera2D


@export var camera_move_speed = 500 #the zoom level also impacts this see 1/zoom
@export var camera_zoom_speed = .02
@export var camera_start_zoom = .5 #the zoom value on load
@export var camera_limit_addition = 100 #pixels more that the camera *center* can move beyond the edge of the gameboard

@export var camera_zoom_out_limit = .02
@export var camera_zoom_in_limit = 1 #2 would double the size of the assets in the viewport (does not change the actual size)


var velocity = Vector2.ZERO #init movement velocity
var zoom_velocity = 0
var camera_left_limit 
var camera_right_limit
var camera_top_limit
var camera_bottom_limit

var new_pos
var new_zoom

func _ready() -> void:
	zoom = Vector2(camera_start_zoom, camera_start_zoom)


func _process(delta: float) -> void:
	
	## move the camera
	velocity = Vector2.ZERO 
	if Input.is_action_pressed("move camera up"):
		velocity.y -= 1
	if Input.is_action_pressed("move camera down"):
		velocity.y += 1
	if Input.is_action_pressed("move camera left"):
		velocity.x -= 1
	if Input.is_action_pressed("move camera right"):
		velocity.x += 1 
	
	velocity = velocity.normalized() * camera_move_speed * 1/zoom * delta
	
	#check movement limits
	new_pos = position + velocity
	if new_pos.x <= camera_left_limit:
		new_pos.x =  camera_left_limit
	if new_pos.x >= camera_right_limit:
		new_pos.x = camera_right_limit
	if new_pos.y <= camera_top_limit:
		new_pos.y = camera_top_limit
	if new_pos.y >= camera_bottom_limit:
		new_pos.y =  camera_bottom_limit

	position = new_pos
		
	## zoom the camera
	zoom_velocity = 0
	if Input.is_action_just_released("zoom camera in"):
		zoom_velocity += 1
	if Input.is_action_just_released("zoom camera out"):
		zoom_velocity -= 1
	
	#keep the zoom in bounds
	new_zoom = zoom + Vector2(zoom_velocity, zoom_velocity) * camera_zoom_speed;
	#notice that new_zoom is (x,y) but both x,y are assumed to be the same
	if new_zoom.x <= camera_zoom_out_limit:
		new_zoom = Vector2(camera_zoom_out_limit, camera_zoom_out_limit)
	if new_zoom.x >= camera_zoom_in_limit:
		new_zoom = Vector2(camera_zoom_in_limit, camera_zoom_in_limit)
		
	zoom = new_zoom
	

	
##Set Camera Limits
# Inputs: a gameboard object 
# sets the limits based on the size of the gameboard
# assuming the first tile is at (0,0) and they get built out from there
func set_camera_limits(gameboard: Node2D) -> void:
	var gameboard_size = gameboard.get_gameboard_size() #(width, height)

	camera_left_limit = -1 * camera_limit_addition
	camera_right_limit = gameboard_size.x + camera_limit_addition
	camera_top_limit = -1 * camera_limit_addition
	camera_bottom_limit = gameboard_size.y + camera_limit_addition
	
	
## Center Camera
#  Inputs: the gameboard object
#  set the camera starting position to the midpoint of the gameboard
func center_camera(gameboard: Node2D) -> void:
	position = gameboard.get_gameboard_center()

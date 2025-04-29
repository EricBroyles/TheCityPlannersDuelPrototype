extends Node2D


class_name GameboardItem
const COLORS = preload("res://Scripts/Constants/Colors.gd")
const TYPES = preload("res://Scripts/Constants/GameboardItemTypes.gd")

var type: String #Type: from TYPES, to be set by each item
var main_body: Sprite2D



var is_on_grid: bool = true #the gameboard grid


##Gameboard Z Index: this is the z index relative to other gameboard items (as this is node need to set to .z_index)
var gameboard_z_index: int = 1

##Elevation: 0 base, .5 (halfway), 1 (up a level)
var elevation: float = 0

##Orientation: this can be used to easily tell the orientation
const X_DIR: Vector2 = Vector2(1,0)
const Y_DIR: Vector2 = Vector2(0,1)
var orientation: Dictionary = {"x_dir": X_DIR, "y_dir": Y_DIR}
var real_orientation: Dictionary = {"rotation_degrees": 0, "flip_h": false, "flip_v": false}



##Error Layer Color: used by the error layer
var error_layer_color = COLORS.GAMEBOARD_ITEM_ERROR_LAYER

##Levels: 0 means that it does not have levels, otherwise starts at level 1
var level: float = 0
var max_level: float = 0


## ---- Transform ----
func rotate_90_cw(times: int = 1):
	rotate_90_cw_orientation(times)
	set_real_orientation()
	
func flip_h():
	flip_h_orientation()
	set_real_orientation()

func flip_v():
	flip_v_orientation()
	set_real_orientation()

## ---- Size ----
func get_oriented_size(body: Sprite2D = main_body) -> Vector2:
	#The reason this is a getter and not a setter, is it always needs to be recalcualted. So instead of having a bunch or set_orient_size all over the place, you call this when you need it
	#This is set up so that usally if main_body is where the oriented_size is derived from you can just call it without inputs. But if for some reason the main body and the body to derive size differ, pass it a var
	var oriented_size: Vector2 = body.texture.get_size()
	if abs(orientation["x_dir"]) == Vector2(0,1):
		return Vector2(oriented_size.y, oriented_size.x)
	return oriented_size

## ---- Position ----
func get_center_position() -> Vector2:
	#.position is assumed to read the center of the item -> if this is not true add a custom version of this
	return position

func get_corner_positions():
	var center_positon: Vector2 = get_center_position()
	var oriented_size: Vector2 = get_oriented_size()
	var w: float = oriented_size.x
	var h: float = oriented_size.y
	
	return {"top_left":     Vector2(center_positon.x - w/2, center_positon.y - h/2), 
			"top_right":    Vector2(center_positon.x + w/2, center_positon.y - h/2), 
			"bottom_left":  Vector2(center_positon.x - w/2, center_positon.y + h/2),
			"bottom_right": Vector2(center_positon.x + w/2, center_positon.y + h/2)}
	












## Transform Helpers
func rotate_90_cw_orientation(times: int):
	orientation["x_dir"] = rotate_vector_90_cw(orientation["x_dir"], times)
	orientation["y_dir"] = rotate_vector_90_cw(orientation["y_dir"], times)
	
func flip_h_orientation():
	orientation["x_dir"] = Vector2(orientation["x_dir"].x, -1 * orientation["x_dir"].y)
	orientation["y_dir"] = Vector2(orientation["y_dir"].x, -1 * orientation["y_dir"].y)
	
func flip_v_orientation():
	orientation["x_dir"] = Vector2(-1 * orientation["x_dir"].x, orientation["x_dir"].y)
	orientation["y_dir"] = Vector2(-1 * orientation["y_dir"].x, orientation["y_dir"].y)

func rotate_90_cw_real_orientation(times: int):
	real_orientation["rotation_degrees"] = (int(real_orientation["rotation_degrees"]) + times * 90) % 360
	
	##NOTE: This is what actually sets the rotation in degrees of the node2D
	rotation_degrees = real_orientation["rotation_degrees"]
	
func flip_h_real_orientation():
	real_orientation["flip_h"] = !real_orientation["flip_h"]
	
func flip_v_real_orientation():
	real_orientation["flip_v"] = !real_orientation["flip_v"]

func reset_orientation():
	orientation = {"x_dir": X_DIR, "y_dir": Y_DIR}

func reset_real_orientation():
	real_orientation = {"rotation_degrees": 0, "flip_h": false, "flip_v": false}

func set_real_orientation():
	reset_real_orientation()
	
	var x_dir = orientation["x_dir"]
	var y_dir = orientation["y_dir"]
	
	#8 possible orientations of the axis
	
	#at original orientation
	if x_dir == Vector2(1,0) && y_dir == Vector2(0,1):
		return
	#rotated by 90 CW
	if x_dir == Vector2(0,1) && y_dir == Vector2(-1,0):
		rotate_90_cw_real_orientation(1)
		return
	#rotated by 180 CW
	if x_dir == Vector2(-1,0) && y_dir == Vector2(0,-1):
		rotate_90_cw_real_orientation(2)
		return
	#rotated by 270 CW
	if x_dir == Vector2(0,-1) && y_dir == Vector2(1,0):
		rotate_90_cw_real_orientation(3)
		return
	#flip V
	if x_dir == Vector2(-1,0) && y_dir == Vector2(0,1):
		flip_v_real_orientation()
		return
	#flip H
	if x_dir == Vector2(1,0) && y_dir == Vector2(0,-1):
		flip_h_real_orientation()
		return
	#flip V, rotated by 90 CW
	if x_dir == Vector2(0,-1) && y_dir == Vector2(-1,0):
		flip_v_real_orientation()
		rotate_90_cw_real_orientation(1)
		return
	#flip H, rotated by 90 CW
	if x_dir == Vector2(0,1) && y_dir == Vector2(1,0):
		flip_h_real_orientation()
		rotate_90_cw_real_orientation(1)
		return
	
func rotate_vector_90_cw(vec: Vector2, times: int) -> Vector2:
	match times % 4:
		0:return vec
		1:return Vector2(-vec.y, vec.x)
		2:return Vector2(-vec.x, -vec.y)
		3:return Vector2(vec.y, -vec.x)
	return vec # fallback (should never reach here)















## CLASS OVERVIEW
#Level of Detail
#Path information (including info on is it for Pedestrian or Car
#Elevation (swap between items with variable elevations)
#item variations, such as road vs joint (Decision road, joint, bridge will all be unique gameboard items and not like swap between them as if they were the same

#oriented_size

##how is it going to be created: Road2Lane.new(), this has nothing to do with picking what thing to create
##THIS WILL NOT DEAL WITH, oh the xyz button was pressed and based on that what item needs to be created, that will be handeld elsewhere

##to make accurate placment easier I will often have items Tiled, such as the curtains for parking, allowing me to easily place them where i want in figma
##other items such as walkways do not get this treatment, becuase I will be moving them around in the gameworld, and I want to easily get their size (so I can clip to custom grid) without having to adjust for the extra border padding.


##Z_indexes, the overal node's z_index call it the gameboard_z_index, keep in mind this is an int, vall z_index's for the various items inside the item, item_z_index
#what is the type
#make it easy to see its attachments
#move
#level, upgrade


#ingress and egress for cars and humans
##Transform


##be sure to set the colorrect to the error color on start. \


##rotation of the parking spots matters for the orientation of the car

#8.	I may need to manually specify the size of things, of specifiy what gets the size for any particular item

#the Path2D defined by me are just for generating the actual paths, they are not expected to be pixel perfect you may need to add extra points and so


##be aware of weirdness when fliping with arrows, when you flip the parking lot do not also flip the curtain, you need to shift its position tho
#fliping also swaps the directions of stuff


##I need to label all items inside of the various trees with somthing that i can do a .label = "CarNavigationMap" (NO. I will specify this with a function)

#anything inside the main_body sprite gets flipped hor v

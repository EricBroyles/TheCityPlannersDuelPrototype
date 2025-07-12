extends GameboardComponent
class_name GameboardItem

#•	Layer 1: Game Board Tiles
#•	Layer 2: All roads, curves, junctions, merges, 
#•	Layer 3: all Buildings
#•	Layer 4: curtains and parking lot)
#•	Layer 5: walkways (sidewalks, and crosswalks)
#•	Layer 6: Cars 
#•	Layer 7: People
#•	Layer Last: Parking Symbol, junction level symbols, curve level items, merge symbols

var size: Vector2 #the size to begin with
var elevation: float #Elevation: 0 base, .5 (halfway), 1 (up a level) (use this for determining item collisions not z-index, as z-index may vary slightly between items that have the same elevation)
var level: int #Levels: 0 means that it does not have levels, otherwise starts at level 1
var max_level: int

var orientation: Dictionary = {"x_dir": GameConstants.X_DIR, "y_dir": GameConstants.Y_DIR}
var error_layer_color = GameConstants.GAMEBOARD_ITEM_ERROR_LAYER

func get_oriented_size() -> Vector2:
	if abs(orientation["x_dir"]) == Vector2(0,1):
		return Vector2(size.y, size.x)
	return size

func set_properties_from(other: GameboardItem):
	#use for duplication
	position = other.global_position
	orientation = other.orientation
	set_real_orientation()

func shares_elevation_with(other_item: GameboardItem) -> bool:
	#my elevation is 0 then I share an elevation with between 0 and .5 (the ramp is .5)
	#my elevation is .5 then I share an elevation with between 0 1
	#my elevation is 1 then I share an elevation with between .5 and 1
	#and so on
	var min_elevation = min(elevation, other_item.elevation)
	var max_elevation = max(elevation, other_item.elevation)
	
	# They share elevation if their difference is 0.5 or less
	return (max_elevation - min_elevation) <= 0.5

func is_colliding_with_overlapping_item(item: GameboardItem) -> bool:
	return shares_elevation_with(item)

func can_upgrade() -> bool:
	if self.max_level == 0: return false
	return true
	
func upgrade():
	return
	
func can_delete() -> bool:
	return true
	
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
	
## Transform Helpers
func rotate_90_cw_orientation(times: int):
	orientation["x_dir"] = GameHelper.rotate_vector_90_cw(orientation["x_dir"], times)
	orientation["y_dir"] = GameHelper.rotate_vector_90_cw(orientation["y_dir"], times)
	
func flip_h_orientation():
	orientation["x_dir"] = Vector2(orientation["x_dir"].x, -1 * orientation["x_dir"].y)
	orientation["y_dir"] = Vector2(orientation["y_dir"].x, -1 * orientation["y_dir"].y)
	
func flip_v_orientation():
	orientation["x_dir"] = Vector2(-1 * orientation["x_dir"].x, orientation["x_dir"].y)
	orientation["y_dir"] = Vector2(-1 * orientation["y_dir"].x, orientation["y_dir"].y)

func set_real_orientation():
	perform_reset_orientation()
	
	var x_dir = orientation["x_dir"]
	var y_dir = orientation["y_dir"]
	
	#8 possible orientations of the axis
	#at original orientation
	if x_dir == Vector2(1,0) && y_dir == Vector2(0,1):
		orient1()
	#rotated by 90 CW
	elif x_dir == Vector2(0,1) && y_dir == Vector2(-1,0):
		orient2()
	#rotated by 180 CW
	elif x_dir == Vector2(-1,0) && y_dir == Vector2(0,-1):
		orient3()
	#rotated by 270 CW
	elif x_dir == Vector2(0,-1) && y_dir == Vector2(1,0):
		orient4()
	#flip V
	elif x_dir == Vector2(-1,0) && y_dir == Vector2(0,1):
		orient5()
	#flip H
	elif x_dir == Vector2(1,0) && y_dir == Vector2(0,-1):
		orient6()
	#flip V, rotated by 90 CW
	elif x_dir == Vector2(0,-1) && y_dir == Vector2(-1,0):
		orient7()
	#flip H, rotated by 90 CW
	elif x_dir == Vector2(0,1) && y_dir == Vector2(1,0):
		orient8()

func reset_orientation():
	orientation = {"x_dir": GameConstants.X_DIR, "y_dir": GameConstants.Y_DIR}

func perform_reset_orientation():
	rotation_degrees = 0
	scale = Vector2(1,1)

func perform_rotate_90_cw(times: int):
	##NOTE: This is what actually sets the rotation in degrees of the node2D
	rotation_degrees = (int(rotation_degrees) + times * 90) % 360
	
func perform_flip_h():
	##NOTE: this actually changes the scale of the top level node (ex ParkingLot1x1)
	scale = Vector2(1, -1) #I make the y negetive as I am changing all pos y coords to be negetive, and vice versa
	
func perform_flip_v():
	##NOTE: this actually changes the scale of the top level node (ex ParkingLot1x1)
	scale = Vector2(-1, 1) #I make the x negetive as I am changing all pos x coords to be negetive, and vice versa

## Orientations (8)
func orient1():
	return
	
func orient2():
	perform_rotate_90_cw(1)
	return
	
func orient3():
	perform_rotate_90_cw(2)
	return

func orient4():
	perform_rotate_90_cw(3)
	return

func orient5():
	perform_flip_v()
	return
	
func orient6():
	perform_flip_h()
	return

func orient7():
	perform_flip_v()
	perform_rotate_90_cw(1)
	return
	
func orient8():
	perform_flip_h()
	perform_rotate_90_cw(1)
	return

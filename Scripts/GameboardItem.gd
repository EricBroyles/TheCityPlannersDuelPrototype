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

var size: Vector2 #start size
var elevation: float #0, .5 (ramp), 1, ... (use this for determining item collisions not z-index, as z-index may vary slightly between items that have the same elevation)
var level: int #Levels: 0 means that it does not have levels, otherwise starts at level 1
var max_level: int

var x_dir: Vector2 = GameConstants.X_DIR
var y_dir: Vector2 = GameConstants.Y_DIR
var error_layer_color = GameConstants.GAMEBOARD_ITEM_ERROR_LAYER

func delete(from_gameboard: Gameboard):
	from_gameboard.delete_component(self)
	
func attempt_to_delete(from_gameboard: Gameboard) -> bool:
	if not can_delete(): return false
	delete(from_gameboard)
	return true
	
func upgrade():
	return
	
func attempt_to_upgrade() -> bool:
	if not can_upgrade(): return false
	upgrade()
	return true

func _set_transform_from(other: GameboardItem):
	position = other.global_position
	x_dir = other.x_dir
	y_dir = other.y_dir
	set_real_orientation()

func get_oriented_size() -> Vector2:
	if abs(x_dir) == GameConstants.Y_DIR:
		return Vector2(size.y, size.x)
	return size

func shares_elevation_with(other_item: GameboardItem) -> bool:
	#my elevation is 0 then I share an elevation with between 0 and .5 (the ramp is .5)
	#my elevation is .5 then I share an elevation with between 0 1
	#my elevation is 1 then I share an elevation with between .5 and 1, ...
	var min_elevation = min(elevation, other_item.elevation)
	var max_elevation = max(elevation, other_item.elevation)
	return (max_elevation - min_elevation) <= 0.5

func is_colliding_with_overlapping_item(item: GameboardItem) -> bool:
	#ignore collisions with walkway unless fully engulfed
	if not shares_elevation_with(item): return false
	if item is Walkway and not GameHelper.is_comp1_fully_contained_by_comp2(item, self): return false
	return true

func can_upgrade() -> bool:
	if self.max_level == 0: return false
	return true
	
func can_delete() -> bool:
	return true
	
## ---- Transform ----
func rotate_90_cw(times: int = 1):
	if not self.CAN_ROTATE: return
	rotate_90_cw_orientation(times)
	set_real_orientation()
	
func flip_h():
	if not self.CAN_FLIP_H: return
	flip_h_orientation()
	set_real_orientation()

func flip_v():
	if not self.CAN_FLIP_V: return
	flip_v_orientation()
	set_real_orientation()
	
## Transform Helpers
func rotate_90_cw_orientation(times: int):
	x_dir = GameHelper.rotate_vector_90_cw(x_dir, times)
	y_dir = GameHelper.rotate_vector_90_cw(y_dir, times)
	
func flip_h_orientation():
	x_dir = Vector2(x_dir.x, -1 * x_dir.y)
	y_dir = Vector2(y_dir.x, -1 * y_dir.y)
	
func flip_v_orientation():
	x_dir = Vector2(-1 * x_dir.x, x_dir.y)
	y_dir = Vector2(-1 * y_dir.x, y_dir.y)

func set_real_orientation():
	perform_reset_orientation()
	
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
	x_dir = GameConstants.X_DIR
	y_dir = GameConstants.Y_DIR

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

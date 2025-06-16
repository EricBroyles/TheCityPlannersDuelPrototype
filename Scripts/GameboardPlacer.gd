extends Node

## This will handle buying land, zoning, delete, upgrades, placing items
#this needs to be able to control the itme placer buttons (show/not show, disable)
#this needs to detect clikc on the gameboard at any time. 
#by default this detects clicks on the gameboard, but this proceess should be able to be stopped
#from buton presseed the mode? is switched, is mode just for gameboardd items

@onready var gameboard = %Gameboard
@onready var selector = %Selector
@onready var body = %Body
@onready var mouse_hitbox = %MouseHitbox
#@onready var gameboard_1x1_hitbox = %Gameboard1x1Hitbox

var _active_mode: int = GameConstants.MODES.MOUSE_POINTER #this is the mode currently being shown, I need this so I can tell when the UI has requested a change, the GameDATA.gameboard_placer_mode is the mode you want to get to
#var area_1x1_overlap: Array = []
#var mouse_area_overlap: Array = []

enum ACTIONS {
	START,
	END,
	CLICK,
	MOVE,
}

func _ready():
	handle_placer(_active_mode, ACTIONS.START) #I need this as while the proper gamemode has been selected It has not been properly started
	selector.close()

func _process(_delta: float) -> void:
	
	if _active_mode != GameData.gameboard_placer_mode:
		#then a new mode has been requested by the UI, so end the current one, start the new one, update the active mode
		handle_placer(_active_mode, ACTIONS.END) 
		handle_placer(GameData.gameboard_placer_mode, ACTIONS.START)  
		_active_mode = GameData.gameboard_placer_mode
		
	handle_placer(_active_mode, ACTIONS.MOVE)



func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == GameData.mouse_button_left:
		handle_placer(_active_mode, ACTIONS.CLICK)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_placer(_active_mode, ACTIONS.CLICK)

func remove_all_body_children():
	for child in body.get_children():
		remove_child(child)
		#child.queue_free()
		
#position is in the center of the object
func snap_to_grid(position: Vector2, size: Vector2) -> Vector2:
	var top_left_position: Vector2 = position - size/2
	var new_top_left_position: Vector2 = round(top_left_position / GameConstants.GAMEBOARD_TILE_SIZE) * GameConstants.GAMEBOARD_TILE_SIZE
	var new_position: Vector2 = new_top_left_position + size/2
	return new_position

func close_mouse_hitbox():
	mouse_hitbox.monitorable = false
	mouse_hitbox.monitoring = false
	
func open_mouse_hitbox():
	mouse_hitbox.monitorable = true
	mouse_hitbox.monitoring = true

#position is the center of the object
func is_out_of_bounds(position: Vector2, size: Vector2) -> bool:
	var half_size = size / 2.0
	var w: float = gameboard.get_gameboard_size().x
	var h: float = gameboard.get_gameboard_size().y
	
	# Check bounds
	if (position.x - half_size.x) < 0:
		return true
	if (position.x + half_size.x) > w:
		return true
	if (position.y - half_size.y) < 0:
		return true
	if (position.y + half_size.y) > h:
		return true
		
	return false



## Handle Placer
#mode: see GameConstants
#action: Start the placer, End the placer, click (held down) run some specific code (ie place the item if possible)
func handle_placer(mode: int, action: int):
	match mode:
		GameConstants.MODES.NONE: 
			## this is specifically for nothing really, ignore this unless I get a good reason, default to Mouse_pointer
			return
		GameConstants.MODES.MOUSE_POINTER:
			match action:
				ACTIONS.START:
					open_mouse_hitbox()
				ACTIONS.END:
					close_mouse_hitbox()
				ACTIONS.MOVE:
					self.position = GameData.mouse_position
				ACTIONS.CLICK:
					var mouse_area_overlap: Array = mouse_hitbox.get_overlapping_areas()
					print(mouse_area_overlap[0].get_owner())
					
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			
		GameConstants.MODES.BUY_LAND:
			#Buy Land
			match action:
				ACTIONS.START:
					selector.open_buy_land_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, selector.oriented_size)
				ACTIONS.CLICK:
					## Attempting to BUY LAND (place Owned_Unzoned tile) @ the placers position
					
					if is_out_of_bounds(self.position, selector.oriented_size):
						return
					
					#check collisions
					var overlapping_areas: Array = selector.find_overlapping_areas()
					for area in overlapping_areas:
						var obj = area.get_owner()
						if obj is OwnedUnzoned or obj is RZone or obj is CZone or obj is IZone:
							return
					
					#try and buy the land, if I dont have enought money then exit
					var amount_bought: int = GameHelper.buy_land(1)
					if amount_bought == 0:
						return
					
					#spawn in the tile
					var new_tile = GameComponents.OWNED_UNZONED_TILE.instantiate()
					new_tile.position = self.position
					gameboard.gameboard_tiles.add_child(new_tile)
					
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.UPGRADE:
			#Buy Land
			match action:
				ACTIONS.START:
					selector.open_upgrade_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, selector.oriented_size)
				ACTIONS.CLICK:
					pass
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.DELETE:
			#Buy Land
			match action:
				ACTIONS.START:
					selector.open_delete_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, selector.oriented_size)
				ACTIONS.CLICK:
					pass
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
						
		GameConstants.MODES.OWNED_UNZONED:
			
			match action:
				ACTIONS.START:
					add_child(GameComponents.OwnedUnzonedTile.instantiate())
				ACTIONS.END:
					remove_all_body_children()
				ACTIONS.CLICK:
					pass
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.R_ZONE:
			return
		GameConstants.MODES.C_ZONE:
			return
		GameConstants.MODES.I_ZONE:
			return
		GameConstants.MODES.WALKWAY:
			return
		GameConstants.MODES.ROAD_2_LANE:
			
			## when snapping to grid be sure to get the updated oriented size
			return
		GameConstants.MODES.ROAD_2_LANE_PARKING:
			return
		GameConstants.MODES.ROAD_4_LANE:
			return
		GameConstants.MODES.ROAD_4_LANE_PARKING:
			return
		GameConstants.MODES.JOINT_2_LANE:
			return
		GameConstants.MODES.JOINT_4_LANE:
			return
		GameConstants.MODES.MERGE_2_AND_4:
			return
		GameConstants.MODES.PARKING_LOT_1X1:
			return
		GameConstants.MODES.PARKING_LOT_1X2_LONG_OPEN:
			return
		GameConstants.MODES.PARKING_LOT_1X2_SHORT_OPEN:
			return
		GameConstants.MODES.PARKING_LOT_2X2:
			return
		GameConstants.MODES.JUNCTION_1X1:
			return
		GameConstants.MODES.JUNCTION_4_INLETS_1X2:
			return
		GameConstants.MODES.JUNCTION_5_INLETS_1X2:
			return
		GameConstants.MODES.JUNCTION_6_INLETS_1X2:
			return
		GameConstants.MODES.JUNCTION_2X2:
			return
		GameConstants.MODES.JUNCTION_5_INLETS_2X2:
			return
		GameConstants.MODES.JUNCTION_6_INLETS_2X2_ACROSS:
			return
		GameConstants.MODES.JUNCTION_6_INLETS_2X2_NEXT:
			return
		GameConstants.MODES.JUNCTION_7_INLETS_2X2:
			return
		GameConstants.MODES.JUNCTION_8_INLETS_2X2:
			return
		GameConstants.MODES.BRIDGE_RAMP_2_LANE_STRAIGHT:
			return
		GameConstants.MODES.BRIDGE_2_LANE_STRAIGHT:
			return
		GameConstants.MODES.BRIDGE_2_LANE_JOINT:
			return
		_:
			push_error("Unknown placer mode: %d" % mode)

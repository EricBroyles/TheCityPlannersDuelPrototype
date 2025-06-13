extends Node

## This will handle buying land, zoning, delete, upgrades, placing items
#this needs to be able to control the itme placer buttons (show/not show, disable)
#this needs to detect clikc on the gameboard at any time. 
#by default this detects clicks on the gameboard, but this proceess should be able to be stopped
#from buton presseed the mode? is switched, is mode just for gameboardd items


@onready var selector = %Selector
@onready var body = %Body

var _active_mode: int = GameConstants.MODES.MOUSE_POINTER #this is the mode currently being shown, I need this so I can tell when the UI has requested a change, the GameDATA.gameboard_placer_mode is the mode you want to get to

enum ACTIONS {
	START,
	END,
	CLICK,
	MOVE,
}

func _ready():
	selector.close()

func _process(_delta: float) -> void:
	#update_position()
	
	if _active_mode != GameData.gameboard_placer_mode:
		#then a new mode has been requested by the UI, so end the current one, start the new one, update the active mode
		handle_placer(_active_mode, ACTIONS.END) 
		handle_placer(GameData.gameboard_placer_mode, ACTIONS.START)  
		_active_mode = GameData.gameboard_placer_mode
		
	handle_placer(_active_mode, ACTIONS.MOVE)


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == GameData.mouse_button_left:
		print("fuck me pressed") 

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

## Handle Placer
#mode: see GameConstants
#action: Start the placer, End the placer, click (held down) run some specific code (ie place the item if possible)
func handle_placer(mode: int, action: int):
	match mode:
		GameConstants.MODES.NONE: 
			## this is specifically for nothing really, ignore this unless I get a good reason, default to Mouse_pointer
			return
		GameConstants.MODES.MOUSE_POINTER:
			return
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
					pass
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

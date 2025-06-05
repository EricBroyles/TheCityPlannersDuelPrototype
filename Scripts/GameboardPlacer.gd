extends Node

var active_mode: int = 0 #this is the mode currently being shown, I need this so I can tell when the UI has requested a change, the GameDATA.gameboard_placer_mode is the mode you want to get to


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active_mode != GameData.gameboard_placer_mode:
		active_mode = GameData.gameboard_placer_mode
		setup_placer(GameData.gameboard_placer_mode)
	

##SETUP PLACER
#this runs when the gameboard_placer_mode has changed and is not zero
func setup_placer(mode: int) -> void:
	
	
	#NEED TO KILL THE CURRENT COMPONENT !!!!!!!!!! HERE DO THIS
	
	
	match mode:
		GameConstants.UNSELECTED_MODE:
			return
		GameConstants.OWNED_UNZONED_MODE:
			return
		GameConstants.R_ZONE_MODE:
			return
		GameConstants.C_ZONE_MODE:
			return
		GameConstants.I_ZONE_MODE:
			return
		GameConstants.WALKWAY_MODE:
			return
		GameConstants.ROAD_2_LANE_MODE:
			return
		GameConstants.ROAD_2_LANE_PARKING_MODE:
			return
		GameConstants.ROAD_4_LANE_MODE:
			return
		GameConstants.ROAD_4_LANE_PARKING_MODE:
			return
		GameConstants.JOINT_2_LANE_MODE:
			return
		GameConstants.JOINT_4_LANE_MODE:
			return
		GameConstants.MERGE_2_AND_4_MODE:
			return
		GameConstants.PARKING_LOT_1X1_MODE:
			return
		GameConstants.PARKING_LOT_1X2_LONG_OPEN_MODE:
			return
		GameConstants.PARKING_LOT_1X2_SHORT_OPEN_MODE:
			return
		GameConstants.PARKING_LOT_2X2_MODE:
			return
		GameConstants.JUNCTION_1X1_MODE:
			return
		GameConstants.JUNCTION_4_INLETS_1X2_MODE:
			return
		GameConstants.JUNCTION_5_INLETS_1X2_MODE:
			return
		GameConstants.JUNCTION_6_INLETS_1X2_MODE:
			return
		GameConstants.JUNCTION_2X2_MODE:
			return
		GameConstants.JUNCTION_5_INLETS_2X2_MODE:
			return
		GameConstants.JUNCTION_6_INLETS_2X2_ACROSS_MODE:
			return
		GameConstants.JUNCTION_6_INLETS_2X2_NEXT_MODE:
			return
		GameConstants.JUNCTION_7_INLETS_2X2_MODE:
			return
		GameConstants.JUNCTION_8_INLETS_2X2_MODE:
			return
		GameConstants.BRIDGE_RAMP_2_LANE_STRAIGHT_MODE:
			return
		GameConstants.BRIDGE_2_LANE_STRAIGHT_MODE:
			return
		GameConstants.BRIDGE_2_LANE_JOINT_MODE:
			return
		_:
			push_error("Unknown placer mode: %d" % mode)
	return

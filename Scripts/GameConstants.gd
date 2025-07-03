extends Node
## This will include the constants needed for the challenge game, duel game mode, creative game mode

const X_DIR: Vector2 = Vector2(1,0)
const Y_DIR: Vector2 = Vector2(0,1)

## Colors
const GAMEBOARD_ITEM_ERROR_LAYER: Dictionary = {"hex": "ff0400", "alpha": 180}

## Gameboard
const GAMEBOARD_TILE_SIZE = 200 #pixels x pixcels for each tile in the gameboard

## Gameboard Placer Modes: these come from a particular UI input from the User
#the reason I do not combine this with the information about type and z_index is these two things are distinct and while their is some overlap thier is a lot of variation (walkway vs sidewalks, road, road with parking)
enum MODES {
	NONE, 
	MOUSE_POINTER,
	BUY_LAND,
	UPGRADE,
	DELETE, 
	OWNED_UNZONED,
	R_ZONE, 
	C_ZONE,  
	I_ZONE, 
	WALKWAY, 
	ROAD_2_LANE,
	ROAD_2_LANE_PARKING, 
	ROAD_4_LANE,
	ROAD_4_LANE_PARKING,
	JOINT_2_LANE,
	JOINT_4_LANE,
	MERGE_2_AND_4,
	PARKING_LOT_1X1,
	PARKING_LOT_1X2_LONG_OPEN,
	PARKING_LOT_1X2_SHORT_OPEN,
	PARKING_LOT_2X2,
	JUNCTION_1X1,
	JUNCTION_4_INLETS_1X2,
	JUNCTION_5_INLETS_1X2,
	JUNCTION_6_INLETS_1X2,
	JUNCTION_2X2,
	JUNCTION_5_INLETS_2X2,
	JUNCTION_6_INLETS_2X2_ACROSS,
	JUNCTION_6_INLETS_2X2_NEXT,
	JUNCTION_7_INLETS_2X2,
	JUNCTION_8_INLETS_2X2,
	BRIDGE_RAMP_2_LANE_STRAIGHT,
	BRIDGE_2_LANE_STRAIGHT,
	BRIDGE_2_LANE_JOINT,
}

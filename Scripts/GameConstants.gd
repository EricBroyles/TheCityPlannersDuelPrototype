extends Node
## This will include the constants needed for the challenge game, duel game mode, creative game mode

const X_DIR: Vector2 = Vector2(1,0)
const Y_DIR: Vector2 = Vector2(0,1)

## Colors
const GAMEBOARD_ITEM_ERROR_LAYER: Dictionary = {"hex": "ff0400", "alpha": 180}

## Gameboard
const GAMEBOARD_TILE_SIZE: int = 200 #pixels x pixcels for each tile in the gameboard
const GAMEBOARD_CONTAINER_SIZE: int = 8
const GAMEBOARD_TILE_SIZE_FT: int = 32; #ft
const PIXELS_PER_FT = 200 / 32.0; #6.25 px/ft

const POINTS_PER_R_DEMAND: int = 1100
const POINTS_PER_C_DEMAND: int = 1100
const POINTS_PER_I_DEMAND: int = 1100

#cost of 2 lane of road per tile
const MONEY_PER_LAND_TILE: int = 250

const MONEY_PER_WALKWAY: int = int(2.5 * GAMEBOARD_TILE_SIZE_FT * 6) #width 2.5 x 32 length ft^2 at 6$ a square foot = 480

const MONEY_PER_ROAD_2_LANE: int = int(625000 / 5280.0 * GAMEBOARD_TILE_SIZE_FT) #$3800/tile
const MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN: int = int(5000 / 5280.0 *  GAMEBOARD_TILE_SIZE_FT) #$30/tile per turn

const MONEY_PER_PARKING_SPOT: int = 1500 #$1500 / spot
const MONEY_TO_UPKEEP_PARKING_SPOT_PER_TURN: int = 20 #$20/tile per turn 

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

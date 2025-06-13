extends Node
## This will include the constants needed for the challenge game, duel game mode, creative game mode

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

## Types: are unique to each gameboard item, agent, tile
enum GAMEBOARD_TILE_TYPES {
	
}

enum GAMEBOARD_AGENT_TYPES {
	CAR,
	HUMAN,
}

enum GAMEBOARD_ITEM_TYPES {
	SIDEWALK_1_EDGE,
	CROSSWALK_1_EDGE,
	ROAD_2_LANE,
	ROAD_4_LANE,
	PARKING_LOT_1X1,
	PARKING_LOT_2X2,
}

#const UNSELECTED_MODE: String = "UNSELECTED_MODE"
#const OWNED_UNZONED_MODE: String = "OWNED_UNZONED_MODE" 
#const R_ZONE_MODE: String = "R_ZONE_MODE" 
#const C_ZONE_MODE: String = "C_ZONE_MODE" 
#const I_ZONE_MODE: String = "I_ZONE_MODE" 
#const WALKWAY_MODE: String = "WALKWAY_MODE" 
#const ROAD_2_LANE_MODE: String = "ROAD_2_LANE_MODE" 
#const ROAD_2_LANE_PARKING_MODE: String = "ROAD_2_LANE_PARKING_MODE" 
#const ROAD_4_LANE_MODE: String = "ROAD_4_LANE_MODE" 
#const ROAD_4_LANE_PARKING_MODE: String = "" 
#const JOINT_2_LANE_MODE: String = "" 
#const JOINT_4_LANE_MODE: String = "" 
#const MERGE_2_AND_4_MODE: String = "" 
#const PARKING_LOT_1X1_MODE: String = "" 
#const PARKING_LOT_1X2_LONG_OPEN_MODE: String = "" 
#const PARKING_LOT_1X2_SHORT_OPEN_MODE: String = "" 
#const PARKING_LOT_2X2_MODE: String = "" 
#const JUNCTION_1X1_MODE: String = "" 
#const JUNCTION_4_INLETS_1X2_MODE: String = "" 
#const JUNCTION_5_INLETS_1X2_MODE: String = "" 
#const JUNCTION_6_INLETS_1X2_MODE: String = "" 
#const JUNCTION_2X2_MODE: String = "" 
#const JUNCTION_5_INLETS_2X2_MODE: String = "" 
#const JUNCTION_6_INLETS_2X2_ACROSS_MODE: String = "" 
#const JUNCTION_6_INLETS_2X2_NEXT_MODE: String = "" 
#const JUNCTION_7_INLETS_2X2_MODE: String = "" 
#const JUNCTION_8_INLETS_2X2_MODE: String = "" 
#const BRIDGE_RAMP_2_LANE_STRAIGHT_MODE: String = "" 
#const BRIDGE_2_LANE_STRAIGHT_MODE: String = "" 
#const BRIDGE_2_LANE_JOINT_MODE: String = "" 



#•	Layer 1: Game Board Tiles
#•	Layer 2: All roads, curves, junctions, merges, 
#•	Layer 3: all Buildings
#•	Layer 4: curtains and parking lot)
#•	Layer 5: walkways (sidewalks, and crosswalks)
#•	Layer 6: Cars 
#•	Layer 7: People
#•	Layer Last: Parking Symbol, junction level symbols, curve level items, merge symbols


## TO BE REMOVED, and PLACE the z inisde of the actual item script


##Agent Items
const CAR:   Dictionary = {"type": "car",   "z_index": 60}
const HUMAN: Dictionary = {"type": "human", "z_index": 70}

## Gameboard Items 
## Walkways
const SIDEWALK_1_EDGE:  Dictionary = {"type": "sidewalk_1_edge",  "z_index": 51}
const CROSSWALK_1_EDGE: Dictionary = {"type": "crosswalk_1_edge", "z_index": 50}
const CROSSWALK_2_EDGE: Dictionary = {"type": "crosswalk_2_edge", "z_index": 50} #this will come latter

## ParkingLots 
const PARKING_LOT_1X1: Dictionary = {"type": "parking_lot_1x1", "z_index": 40}
#parking_lot_1x2_long_open
const PARKING_LOT_2X2: Dictionary = {"type": "parking_lot_2x2", "z_index": 40}

## Roads
const ROAD_2_LANE: Dictionary = {"type": "road_2_lane", "z_index": 20}
const ROAD_4_LANE: Dictionary = {"type": "road_4_lane", "z_index": 20}

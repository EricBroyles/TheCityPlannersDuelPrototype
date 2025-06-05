extends Node
## This will include the constants needed for the challenge game, duel game mode, creative game mode

## Colors
const GAMEBOARD_ITEM_ERROR_LAYER: Dictionary = {"hex": "ff0400", "alpha": 180}

## Gameboard
const GAMEBOARD_TILE_SIZE = 200 #pixels

## Gameboard Placer Modes: the reason I do not combine this with the game components is their is not a one to one (ie road parking)
const UNSELECTED_MODE: int = 0
const OWNED_UNZONED_MODE: int = 1
const R_ZONE_MODE: int = 2
const C_ZONE_MODE: int = 3
const I_ZONE_MODE: int = 4
const WALKWAY_MODE: int = 5
const ROAD_2_LANE_MODE: int = 6
const ROAD_2_LANE_PARKING_MODE: int = 7
const ROAD_4_LANE_MODE: int = 8
const ROAD_4_LANE_PARKING_MODE: int = 9
const JOINT_2_LANE_MODE: int = 10
const JOINT_4_LANE_MODE: int = 11
const MERGE_2_AND_4_MODE: int = 12
const PARKING_LOT_1X1_MODE: int = 13
const PARKING_LOT_1X2_LONG_OPEN_MODE: int = 14
const PARKING_LOT_1X2_SHORT_OPEN_MODE: int = 15
const PARKING_LOT_2X2_MODE: int = 16
const JUNCTION_1X1_MODE: int = 17
const JUNCTION_4_INLETS_1X2_MODE: int = 18
const JUNCTION_5_INLETS_1X2_MODE: int = 19
const JUNCTION_6_INLETS_1X2_MODE: int = 20
const JUNCTION_2X2_MODE: int = 21
const JUNCTION_5_INLETS_2X2_MODE: int = 22
const JUNCTION_6_INLETS_2X2_ACROSS_MODE: int = 23
const JUNCTION_6_INLETS_2X2_NEXT_MODE: int = 24
const JUNCTION_7_INLETS_2X2_MODE: int = 25
const JUNCTION_8_INLETS_2X2_MODE: int = 26
const BRIDGE_RAMP_2_LANE_STRAIGHT_MODE: int = 27
const BRIDGE_2_LANE_STRAIGHT_MODE: int = 28
const BRIDGE_2_LANE_JOINT_MODE: int = 29



#•	Layer 1: Game Board Tiles
#•	Layer 2: All roads, curves, junctions, merges, 
#•	Layer 3: all Buildings
#•	Layer 4: curtains and parking lot)
#•	Layer 5: walkways (sidewalks, and crosswalks)
#•	Layer 6: Cars 
#•	Layer 7: People
#•	Layer Last: Parking Symbol, junction level symbols, curve level items, merge symbols

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

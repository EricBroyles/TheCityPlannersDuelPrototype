extends Node
## This will include the constants needed for the challenge game, duel game mode, creative game mode

## Colors
const GAMEBOARD_ITEM_ERROR_LAYER: Dictionary = {"hex": "ff0400", "alpha": 180}

## Gameboard
const GAMEBOARD_TILE_SIZE = 200 #pixels


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

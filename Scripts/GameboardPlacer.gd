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
	
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#handle_placer(_active_mode, ACTIONS.CLICK)


func get_body_child() -> Node2D:
	return body.get_child(0)

func add_body_child(child: Node2D):
	body.add_child(child)

func remove_all_body_children():
	for child in body.get_children():
		body.remove_child(child)
		#child.queue_free()
		
func place_tile(tile: GameboardTile):
	tile.position = self.position
	gameboard.gameboard_tiles.add_child(tile)
	
func remove_tile(tile: GameboardTile):
	gameboard.gameboard_tiles.remove_child(tile)
		
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
	
	
	

## Click Sequence
## Buy Land: Placing a Owned_Unzoned Tile on an empty space
#	Do I have enough money
#	Am I in bounds
#	Am I on an unbought_unzoned gameboad tile (not on a Owned_Unzoned, R, C, I)
#		search through all areas in its layer 
#	place the Owned_unzoned tile
#	make the transaction (remove money)
## Owned_Unzoned Tile: removing the zoning in a spot
#	Am I In bounds
#	Am I a R,C,I 
#		search through all areas in its layer 
#	remove the R,C,I tile
#	place the Owned_unzoned tile
# 	refund the demand unit

## R Tile: changing an Owned_Unzoned to R Tile
#	Do I have enough r_demand_units
#	Am I In bounds
#	Am I a Owned_Unzoned,R,C,I 
#		search through all areas in its layer 
#	remove the Owned_Unzoned,R,C,I tile
#	place the R tile
# 	make the demand transaction

## C Tile: changing an Owned_Unzoned to C Tile
#	same shit as R
## I Tile: changing an Owned_Unzoned to I Tile
#	same shit as R







	


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
					#var mouse_area_overlap: Array = mouse_hitbox.get_overlapping_areas()
					pass
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			
		GameConstants.MODES.BUY_LAND:
			#Buy Land
			match action:
				ACTIONS.START:
					selector.open_buy_land_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, selector.size)
				ACTIONS.CLICK:
					## Attempting To BUY LAND: place Owned_Unzoned tile @ the placers position
					var tile = GameComponents.OWNED_UNZONED_TILE.instantiate()
					if GameHelper.amount_land_tiles_can_buy() < 1: return #need to be able to buy at least one
					if is_out_of_bounds(self.position, tile.size): return
					var overlapping_areas: Array = selector.find_overlapping_areas() #yes this is supposed to use the selector
					for area in overlapping_areas:
						var obj = area.get_owner()
						if GameHelper.is_owned_tile(obj): return
					place_tile(tile)
					GameHelper.buy_land(1)
					
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
				
		GameConstants.MODES.UPGRADE:
			#Buy Land
			match action:
				ACTIONS.START:
					selector.open_upgrade_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, selector.size)
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
					self.position = snap_to_grid(GameData.mouse_position, selector.size)
				ACTIONS.CLICK:
					pass
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
						
		GameConstants.MODES.OWNED_UNZONED:
			
			match action:
				ACTIONS.START:
					add_body_child(GameComponents.OWNED_UNZONED_TILE.instantiate())
				ACTIONS.END:
					remove_all_body_children()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, get_body_child().size)
				ACTIONS.CLICK:
					## Attempting To Remove Zoning: place Owned_Unzoned tile and remove zoned tile @ the placers position
					var tile = GameComponents.OWNED_UNZONED_TILE.instantiate()
					if is_out_of_bounds(self.position, tile.size): return
					var overlapping_areas: Array = get_body_child().find_overlapping_areas() 
					for area in overlapping_areas:
						var obj = area.get_owner()
						if GameHelper.is_zoned_tile(obj):
							#remove_child(obj) #remove R C I
							remove_tile(obj)
							GameHelper.refund_demand_units(obj, 1) #refund R C I tile
							place_tile(tile)
							return
	
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
				
		GameConstants.MODES.R_ZONE:
			
			match action:
				ACTIONS.START:
					add_body_child(GameComponents.R_ZONE_TILE.instantiate())
				ACTIONS.END:
					remove_all_body_children()
				ACTIONS.MOVE:
					self.position = snap_to_grid(GameData.mouse_position, get_body_child().size)
				ACTIONS.CLICK:
					## Attempting to Add ZoneR: add ZoneR, remove Owned_Unzoned @ the placers position
					var tile = GameComponents.R_ZONE_TILE.instantiate()
					if GameData.r_demand < 1: return
					if is_out_of_bounds(self.position, tile.size): return
					var overlapping_areas: Array = get_body_child().find_overlapping_areas() 
					for area in overlapping_areas:
						var obj = area.get_owner()
						if GameHelper.is_owned_tile(obj) and not obj is RZone:
							#remove_child(obj) #remove owned_unzoned C I
							remove_tile(obj)
							GameHelper.refund_demand_units(obj, 1) #refund C I tile, can pass in Owned_unzoned, it refunds nothing
							place_tile(tile)
							GameData.r_demand -= 1
							return
					
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			
			
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

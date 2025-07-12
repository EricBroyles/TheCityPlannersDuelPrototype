extends Node

enum ACTIONS {
	START,
	END,
	CLICK,
	MOVE,
	ROTATE_90_CW,
	FLIP_V,
	FLIP_H,
}

@onready var gameboard = %Gameboard
@onready var build_phase_ui = %BuildPhase
@onready var selector = %Selector

var _active_mode: int = GameConstants.MODES.MOUSE_POINTER 

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

func _unhandled_input(_event: InputEvent):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_placer(_active_mode, ACTIONS.CLICK)

func set_placer_component(component: GameboardComponent):
	#the reason I do not have a body underneath is due to its position staying at 0,0 when moving the node2D version of placer
	component.name = "PlacerComponent"
	add_child(component)

func get_placer_component() -> GameboardComponent:
	if has_node("PlacerComponent"):
		return get_node("PlacerComponent") as GameboardComponent
	return null

func clear_placer_component():
	var placer = get_node("PlacerComponent")
	remove_child(placer)

func handle_placer(mode: int, action: int):
	#mode: see GameConstants.MODES, action: see ACTIONS enum
	match mode:
		GameConstants.MODES.NONE: 
			return
		GameConstants.MODES.MOUSE_POINTER:
			match action: 
				ACTIONS.START:
					pass
				ACTIONS.END:
					pass
				ACTIONS.MOVE:
					pass
				ACTIONS.CLICK:
					#probably get the mouse position and then get top component at that spot to select it ...
					pass
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.UPGRADE:
			match action:
				ACTIONS.START:
					selector.open_upgrade_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					selector.position = GameData.mouse_position
				ACTIONS.CLICK:
					gameboard.attempt_to_upgrade_item_at(selector.position)
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.DELETE:
			match action:
				ACTIONS.START:
					selector.open_delete_selector()
				ACTIONS.END:
					selector.close()
				ACTIONS.MOVE:
					selector.position = GameData.mouse_position
				ACTIONS.CLICK:
					gameboard.attempt_to_delete_item_at(selector.position)
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.BUY_LAND:
			match action:
				ACTIONS.START:
					selector.open_buy_land_selector() #this needs to run before so the selector is on top of the component.
					set_placer_component(GameComponents.OWNED_UNZONED_TILE.instantiate())
				ACTIONS.END:
					clear_placer_component()
					selector.close()
				ACTIONS.MOVE:
					selector.position = gameboard.snap_to_grid(GameData.mouse_position, get_placer_component())
					get_placer_component().position = selector.position
				ACTIONS.CLICK:
					(get_placer_component() as OwnedUnzoned).attempt_to_buy_land(gameboard)
				_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		#GameConstants.MODES.OWNED_UNZONED:
			#match action:
				#ACTIONS.START:
					#add_body_child(GameComponents.OWNED_UNZONED_TILE.instantiate())
				#ACTIONS.END:
					#remove_all_body_children()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					#(get_body_child() as OwnedUnzoned).attempt_to_unzone(gameboard)
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
				






	


## Handle Placer
#mode: see GameConstants
#action: Start the placer, End the placer, click (held down) run some specific code (ie place the item if possible)

#func handle_placer(mode: int, action: int):
	#match mode:
		#GameConstants.MODES.NONE: 
			### this is specifically for nothing really, ignore this unless I get a good reason, default to Mouse_pointer
			#return
		#GameConstants.MODES.MOUSE_POINTER:
			#match action:
				#ACTIONS.START:
					#pass
				#ACTIONS.END:
					#pass
				#ACTIONS.MOVE:
					#self.position = GameData.mouse_position
				#ACTIONS.CLICK:
					##var mouse_area_overlap: Array = mouse_hitbox.get_overlapping_areas()
					#pass
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			#
		#GameConstants.MODES.BUY_LAND:
			#match action:
				#ACTIONS.START:
					#selector.open_buy_land_selector()
					#add_body_child(GameComponents.OWNED_UNZONED_TILE.instantiate())
				#ACTIONS.END:
					#remove_all_body_children()
					#selector.close()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					### Attempting To BUY LAND: place Owned_Unzoned tile @ the placers position
					#var tile: GameboardTile = GameComponents.OWNED_UNZONED_TILE.instantiate()
					#tile.set_properties_from(get_body_child())
#
					##do I have the money to buy a land tile
					#if not tile.can_buy(): return #need to be able to buy at least one
					#
					##is the land tile out of bounds
					#if not gameboard.contained_by_boxes(tile)["is_fully_contained"]: return
					#
					##have I already bought this tile
					#for comp in gameboard.get_components_in_shared_boxes(tile):
						#if GameHelper.is_owned_tile(comp): return #I already own this tile
				#
					##buy the tile and add it to the gameboard
					#gameboard.add_to_boxes(tile)
					#tile.buy()
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
				#
		#GameConstants.MODES.UPGRADE:
			##check if is an item I can upgrade, can_upgrade
			#
			#match action:
				#ACTIONS.START:
					#selector.open_upgrade_selector()
				#ACTIONS.END:
					#selector.close()
				#ACTIONS.MOVE:
					#self.position = GameData.mouse_position
				#ACTIONS.CLICK:
					### Attempting To UPGRADE the top most GameboardItem (in z)
					#var item_to_upgrade: GameboardItem = null
					#for hitbox in gameboard.get_hitboxes_at(self.position):
						#var hitbox_owner: Variant = gameboard.get_hitbox_owner(hitbox)
						#if hitbox_owner is GameboardItem and hitbox_owner.can_upgrade():
							#if item_to_upgrade == null or item_to_upgrade.z_index < hitbox_owner.z_index:
								#item_to_upgrade = hitbox_owner as GameboardItem 
					#
					#if item_to_upgrade != null:
						#item_to_upgrade.upgrade() #I am upgrading a GameboardItem that can upgrade and is at the top z idex of what I clicked on
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			#
#
		#GameConstants.MODES.DELETE:
			#match action:
				#ACTIONS.START:
					#selector.open_delete_selector()
				#ACTIONS.END:
					#selector.close()
				#ACTIONS.MOVE:
					#self.position = GameData.mouse_position
				#ACTIONS.CLICK:
					### Attempting To DELETE the top most GameboardItem (in z)
					#var item_to_remove: GameboardItem = null
					#for hitbox in gameboard.get_hitboxes_at(self.position):
						#var hitbox_owner: Variant = gameboard.get_hitbox_owner(hitbox)
						#if hitbox_owner is GameboardItem and hitbox_owner.can_delete():
							#if item_to_remove == null or item_to_remove.z_index < hitbox_owner.z_index:
								#item_to_remove = hitbox_owner as GameboardItem 
					#
					#if item_to_remove != null:
						#item_to_remove.delete_from(gameboard) #I am deleting a GameboardItem that can delete and is at the top z idex of what I clicked on
						#
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
#
						#
		#GameConstants.MODES.OWNED_UNZONED:
			#match action:
				#ACTIONS.START:
					#add_body_child(GameComponents.OWNED_UNZONED_TILE.instantiate())
				#ACTIONS.END:
					#remove_all_body_children()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					### Attempting To Remove Zoning: place Owned_Unzoned tile and remove zoned tile @ the placers position
					#var tile: GameboardTile = GameComponents.OWNED_UNZONED_TILE.instantiate()
					#tile.set_properties_from(get_body_child())
					#
					##is the land tile out of bounds
					#if not gameboard.contained_by_boxes(tile)["is_fully_contained"]: return
					#
					#for comp in gameboard.get_components_in_shared_boxes(tile):
						#if GameHelper.is_zoned_tile(comp): 
							#
							## remove the comp (it is a zoned tile)
							#gameboard.remove_from_boxes(comp)
							## add the unzoned_owned tile
							#gameboard.add_to_boxes(tile)
							##refund the demand
							#comp.refund() #refund R C I tile (be carful about refunding Owned_unzoned)
							#return 
				#
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
				#
		#GameConstants.MODES.R_ZONE:
			#match action:
				#ACTIONS.START:
					#add_body_child(GameComponents.R_ZONE_TILE.instantiate())
				#ACTIONS.END:
					#remove_all_body_children()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					### Attempting to Add ZoneR: add ZoneR, remove Owned_Unzoned @ the placers position
					#var tile: GameboardTile = GameComponents.R_ZONE_TILE.instantiate()
					#tile.set_properties_from(get_body_child())
					#
					##do I have enough demand
					#if not tile.can_buy(): return
					#
					##is the land tile out of bounds
					#if not gameboard.contained_by_boxes(tile)["is_fully_contained"]: return
					#
					#for comp in gameboard.get_components_in_shared_boxes(tile):
						#if GameHelper.is_owned_tile(comp) and not comp is RZone: 
							#
							## remove the comp (it is a zoned tile)
							#gameboard.remove_from_boxes(comp)
							## add the unzoned_owned tile
							#gameboard.add_to_boxes(tile)
							##refund the demand
							#comp.refund()
							##charge the demand
							#tile.buy()
							#return 
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			#
		#GameConstants.MODES.C_ZONE:
			#match action:
				#ACTIONS.START:
					#add_body_child(GameComponents.C_ZONE_TILE.instantiate())
				#ACTIONS.END:
					#remove_all_body_children()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					### Attempting to Add ZoneC: add ZoneC, remove Owned_Unzoned @ the placers position
					#var tile: GameboardTile = GameComponents.C_ZONE_TILE.instantiate()
					#tile.set_properties_from(get_body_child())
					#
					##do I have enough demand
					#if not tile.can_buy(): return
					#
					##is the land tile out of bounds
					#if not gameboard.contained_by_boxes(tile)["is_fully_contained"]: return
					#
					#for comp in gameboard.get_components_in_shared_boxes(tile):
						#if GameHelper.is_owned_tile(comp) and not comp is CZone: 
							#
							## remove the comp (it is a zoned tile)
							#gameboard.remove_from_boxes(comp)
							## add the unzoned_owned tile
							#gameboard.add_to_boxes(tile)
							##refund the demand
							#comp.refund()
							##charge the demand
							#tile.buy()
							#return 
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
				#
		#GameConstants.MODES.I_ZONE:
			#match action:
				#ACTIONS.START:
					#add_body_child(GameComponents.I_ZONE_TILE.instantiate())
				#ACTIONS.END:
					#remove_all_body_children()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					### Attempting to Add ZoneI: add ZoneI, remove Owned_Unzoned @ the placers position
					#var tile: GameboardTile = GameComponents.I_ZONE_TILE.instantiate()
					#tile.set_properties_from(get_body_child())
					#
					##do I have enough demand
					#if not tile.can_buy(): return
					#
					##is the land tile out of bounds
					#if not gameboard.contained_by_boxes(tile)["is_fully_contained"]: return
					#
					#for comp in gameboard.get_components_in_shared_boxes(tile):
						#if GameHelper.is_owned_tile(comp) and not comp is IZone: 
							#
							## remove the comp (it is a zoned tile)
							#gameboard.remove_from_boxes(comp)
							## add the unzoned_owned tile
							#gameboard.add_to_boxes(tile)
							##refund the demand
							#comp.refund()
							##charge the demand
							#tile.buy()
							#return 
				#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			#
			#
		#GameConstants.MODES.WALKWAY:
			#match action:
				#ACTIONS.START:
					#var item: Walkway = GameComponents.WALKWAY.instantiate()
					#item.setup(item.SETUP.SIDEWALK) #start with sidewalk (the item will detect the need to switch to crosswalk)
					#add_body_child(item)
					#build_phase_ui.open_item_placer_buttons(false, true, true) 
				#ACTIONS.END:
					#remove_all_body_children()
					#build_phase_ui.close_item_placer_buttons()
				#ACTIONS.MOVE:
					##self.position = gameboard.snap_to_edges(GameData.mouse_position, get_body_child(), true) #do autorotate
					#self.position = gameboard.snap_size_to_boxes(GameData.mouse_position, get_body_child().get_oriented_box_size()) 
					#
				#ACTIONS.CLICK:
					#var item: Walkway = GameComponents.WALKWAY.instantiate()
					#item.set_properties_from(get_body_child())
					#
					## can I buy the item
					#if not item.can_buy(): return
					#
					#var contained_by_edges_results: Dictionary = gameboard.contained_by_edges(item)
					#print(contained_by_edges_results)
					## is the item out of bounds
					#if not contained_by_edges_results["is_fully_contained"]: print("a"); return
					#
					##do I own the edge I am place in=t on
					##
					#
					##I only need one of the boxes to be owned
					#var box_has_owned_tile = false
					#for box in contained_by_edges_results["boxes"]:
						#for comp in box.components:
							#if GameHelper.is_owned_tile(comp):
								#box_has_owned_tile = true
								#break
						#if box_has_owned_tile: break
					 #
					#if not box_has_owned_tile: print("b"); return
					#
					#for edge in contained_by_edges_results["edges"]:
						#for comp in edge.components:
							#if comp is GameboardItem and item.shares_elevation_with(comp):
								#print("c"); return 		
					##leave the zoned tile underneath it
					##add the item
					#gameboard.add_to_edges(item)
					#
					##complete the transaction (have this code inside of the actiual item, as it will have stuff like cost of maintance
					#item.buy()
					#
					#
				#ACTIONS.ROTATE_90_CW:
					#get_body_child().rotate_90_cw()
					#
				#ACTIONS.FLIP_V:
					#get_body_child().flip_v()
					#
				#ACTIONS.FLIP_H: 
					#get_body_child().flip_h()
					#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			#
		#GameConstants.MODES.ROAD_2_LANE:
			### when snapping to grid be sure to get the updated oriented size
			### be ure to activate the UI buttons
			#return
		#GameConstants.MODES.ROAD_2_LANE_PARKING:
			#return
		#GameConstants.MODES.ROAD_4_LANE:
			#match action:
				#ACTIONS.START:
					#var item: Road4Lane = GameComponents.ROAD_4_LANE.instantiate()
					#item.setup(item.SETUP.NO_PARKING) 
					#add_body_child(item)
					#build_phase_ui.open_item_placer_buttons(false, true, true)
				#ACTIONS.END:
					#remove_all_body_children()
					#build_phase_ui.close_item_placer_buttons()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					#var item: GameboardItem = GameComponents.ROAD_4_LANE.instantiate()
					#item.set_properties_from(get_body_child())
					#
					## can I buy the item
					#if not item.can_buy(): return
					#
					#var contained_by_boxes_results: Dictionary = gameboard.contained_by_boxes(item)
					## is the item out of bounds
					#if not contained_by_boxes_results["is_fully_contained"]: return
					#
					## is the land I am placing this on bought and not occupied
					##all ocupied boxes need to have an onwned tile to pass this step
					##if any box has a gameboard item in it with a matching elevation then dont place
					#for box in contained_by_boxes_results["boxes"]:
						#var box_has_owned_tile = false
#
						#for comp in box.components:
							#if GameHelper.is_owned_tile(comp):
								#box_has_owned_tile = true
							#
							#if comp is GameboardItem and item.shares_elevation_with(comp):
								#return
								#
						#if not box_has_owned_tile: return
						#
					##leave the zoned tile underneath it
					##add the item
					#gameboard.add_to_boxes(item)
					#
					##complete the transaction (have this code inside of the actiual item, as it will have stuff like cost of maintance
					#item.buy()
					#
					#
				#ACTIONS.ROTATE_90_CW:
					#get_body_child().rotate_90_cw()
					#
				#ACTIONS.FLIP_V:
					#get_body_child().flip_v()
					#
				#ACTIONS.FLIP_H: 
					#get_body_child().flip_h()
					#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
			#
			#
			#
			#
		#GameConstants.MODES.ROAD_4_LANE_PARKING:
			#match action:
				#ACTIONS.START:
					#var item: Road4Lane = GameComponents.ROAD_4_LANE.instantiate()
					#item.setup(item.SETUP.PARKING) 
					#add_body_child(item)
					#build_phase_ui.open_item_placer_buttons(false, true, true)
				#ACTIONS.END:
					#remove_all_body_children()
					#build_phase_ui.close_item_placer_buttons()
				#ACTIONS.MOVE:
					#self.position = gameboard.snap_to_boxes(GameData.mouse_position, get_body_child())
				#ACTIONS.CLICK:
					#var item: GameboardItem = GameComponents.ROAD_4_LANE.instantiate()
					#item.set_properties_from(get_body_child())
					#
					#
					## can I buy the item
					#if not item.can_buy(): return
					#
					#var contained_by_boxes_results: Dictionary = gameboard.contained_by_boxes(item)
					## is the item out of bounds
					#if not contained_by_boxes_results["is_fully_contained"]: return
					#
					## is the land I am placing this on bought and not occupied
					##all ocupied boxes need to have an onwned tile to pass this step
					##if any box has a gameboard item in it with a matching elevation then dont place
					#for box in contained_by_boxes_results["boxes"]:
						#var box_has_owned_tile = false
#
						#for comp in box.components:
							#if GameHelper.is_owned_tile(comp):
								#box_has_owned_tile = true
							#
							#if comp is GameboardItem and item.shares_elevation_with(comp):
								#return
								#
						#if not box_has_owned_tile: return
						#
					##leave the zoned tile underneath it
					##add the item
					#gameboard.add_to_boxes(item)
					#
					##complete the transaction (have this code inside of the actiual item, as it will have stuff like cost of maintance
					#item.buy()
					#
					#
				#ACTIONS.ROTATE_90_CW:
					#get_body_child().rotate_90_cw()
					#
				#ACTIONS.FLIP_V:
					#get_body_child().flip_v()
					#
				#ACTIONS.FLIP_H: 
					#get_body_child().flip_h()
					#
				#_: push_error("Unknown placer action: ", action, "  with mode: ", mode)
		#GameConstants.MODES.JOINT_2_LANE:
			#return
		#GameConstants.MODES.JOINT_4_LANE:
			#return
		#GameConstants.MODES.MERGE_2_AND_4:
			#return
		#GameConstants.MODES.PARKING_LOT_1X1:
			#return
		#GameConstants.MODES.PARKING_LOT_1X2_LONG_OPEN:
			#return
		#GameConstants.MODES.PARKING_LOT_1X2_SHORT_OPEN:
			#return
		#GameConstants.MODES.PARKING_LOT_2X2:
			#return
		#GameConstants.MODES.JUNCTION_1X1:
			#return
		#GameConstants.MODES.JUNCTION_4_INLETS_1X2:
			#return
		#GameConstants.MODES.JUNCTION_5_INLETS_1X2:
			#return
		#GameConstants.MODES.JUNCTION_6_INLETS_1X2:
			#return
		#GameConstants.MODES.JUNCTION_2X2:
			#return
		#GameConstants.MODES.JUNCTION_5_INLETS_2X2:
			#return
		#GameConstants.MODES.JUNCTION_6_INLETS_2X2_ACROSS:
			#return
		#GameConstants.MODES.JUNCTION_6_INLETS_2X2_NEXT:
			#return
		#GameConstants.MODES.JUNCTION_7_INLETS_2X2:
			#return
		#GameConstants.MODES.JUNCTION_8_INLETS_2X2:
			#return
		#GameConstants.MODES.BRIDGE_RAMP_2_LANE_STRAIGHT:
			#return
		#GameConstants.MODES.BRIDGE_2_LANE_STRAIGHT:
			#return
		#GameConstants.MODES.BRIDGE_2_LANE_JOINT:
			#return
		#_:
			#push_error("Unknown placer mode: %d" % mode)
		

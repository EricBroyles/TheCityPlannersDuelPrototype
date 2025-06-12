extends Node

## This will handle buying land, zoning, delete, upgrades, placing items
#this needs to be able to control the itme placer buttons (show/not show, disable)
#this needs to detect clikc on the gameboard at any time. 
#by default this detects clicks on the gameboard, but this proceess should be able to be stopped
#from buton presseed the mode? is switched, is mode just for gameboardd items

#change modes to strings
#everything gets a mode



## Gameboard Selectors (these are here and not in game components as they are only needed here)
var BuyLandSelector: PackedScene = preload("res://Scenes/Gameboard Selectors/BuyLandSelector.tscn")
var DeleteSelector: PackedScene = preload("res://Scenes/Gameboard Selectors/DeleteSelector.tscn")
var UpgradeSelector: PackedScene = preload("res://Scenes/Gameboard Selectors/UpgradeSelector.tscn")

var buy_land_selector: Node2D = BuyLandSelector.instantiate()
var delete_selector: Node2D = DeleteSelector.instantiate()
var upgrade_selector: Node2D = UpgradeSelector.instantiate()

var active_mode: int = GameConstants.MODES.MOUSE_POINTER #this is the mode currently being shown, I need this so I can tell when the UI has requested a change, the GameDATA.gameboard_placer_mode is the mode you want to get to

enum ACTIONS {
	START,
	END,
	CLICK,
}


func _process(_delta: float) -> void:
	update_position()
	
	if active_mode != GameData.gameboard_placer_mode:
		#then a new mode has been requested by the UI, so end the current one, start the new one, update the active mode
		handle_placer(active_mode, ACTIONS.END) 
		handle_placer(GameData.gameboard_placer_mode, ACTIONS.START)  
		active_mode = GameData.gameboard_placer_mode


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == GameData.mouse_button_left:
		print("fuck me pressed") 

func update_position():
	self.position = GameData.mouse_position
	
func remove_all_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()

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
		GameConstants.MODES.OWNED_UNZONED:
			#Buy Land
			match action:
				ACTIONS.START:
					add_child(GameComponents.OwnedUnzonedTile.instantiate())
				ACTIONS.END:
					remove_all_children()
				ACTIONS.CLICK:
					pass
				_:
					push_error("Unknown placer action: ", action, "  with mode: ", mode)
		GameConstants.MODES.R_ZONE:
			return
		GameConstants.MODES.C_ZONE:
			return
		GameConstants.MODES.I_ZONE:
			return
		GameConstants.MODES.WALKWAY:
			return
		GameConstants.MODES.ROAD_2_LANE:
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

##if start == false then run stop code for the mode
#func config_placer(mode: int, start: bool):
	#match mode:
		#GameConstants.MODES.NONE:
			#return
		#GameConstants.MODES.MOUSE_POINTER:
			#return
		#GameConstants.MODES.OWNED_UNZONED:
			##Buy Land
			#if start:
				##activate the buy land selector
				#
				#BuyLandSelector
			#else:
				#pass
				#
		#GameConstants.MODES.R_ZONE:
			#return
		#GameConstants.MODES.C_ZONE:
			#return
		#GameConstants.MODES.I_ZONE:
			#return
		#GameConstants.MODES.WALKWAY:
			#return
		#GameConstants.MODES.ROAD_2_LANE:
			#return
		#GameConstants.MODES.ROAD_2_LANE_PARKING:
			#return
		#GameConstants.MODES.ROAD_4_LANE:
			#return
		#GameConstants.MODES.ROAD_4_LANE_PARKING:
			#return
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
	

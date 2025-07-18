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

const _PLACER_COMPONENT_NAME: String = "PlacerComponent"
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

func _unhandled_input(event: InputEvent):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_placer(_active_mode, ACTIONS.CLICK)
		
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R  and not event.shift_pressed: 
			handle_placer(_active_mode, ACTIONS.ROTATE_90_CW)
		elif event.keycode == KEY_T  and not event.shift_pressed: 
			handle_placer(_active_mode, ACTIONS.FLIP_V)
		elif event.keycode == KEY_Y  and not event.shift_pressed: 
			handle_placer(_active_mode, ACTIONS.FLIP_H)

func set_placer_component(component: GameboardComponent):
	component.name = _PLACER_COMPONENT_NAME
	add_child(component)

func get_placer_component() -> GameboardComponent:
	if has_node(_PLACER_COMPONENT_NAME):
		return get_node(_PLACER_COMPONENT_NAME) as GameboardComponent
	return null
	
func move_placer_component_to(point: Vector2):
	get_placer_component().position = point

func clear_placer_component():
	var placer = get_node(_PLACER_COMPONENT_NAME)
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
				_: return
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
				_: return
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
				_: return
		GameConstants.MODES.BUY_LAND:
			match action:
				ACTIONS.START:
					selector.open_buy_land_selector() #this needs to run before so the selector is on top of the component.
					set_placer_component(OwnedUnzoned.create())
				ACTIONS.END:
					clear_placer_component()
					selector.close()
				ACTIONS.MOVE:
					selector.position = gameboard.snap_to_grid(GameData.mouse_position, get_placer_component())
					move_placer_component_to(selector.position)
				ACTIONS.CLICK:
					(get_placer_component() as OwnedUnzoned).attempt_to_buy_land(gameboard)
				_: return
		GameConstants.MODES.OWNED_UNZONED:
			match action:
				ACTIONS.START:
					set_placer_component(OwnedUnzoned.create())
				ACTIONS.END:
					clear_placer_component()
				ACTIONS.MOVE:
					move_placer_component_to(gameboard.snap_to_grid(GameData.mouse_position, get_placer_component()))
				ACTIONS.CLICK:
					(get_placer_component() as OwnedUnzoned).attempt_to_unzone(gameboard)
				_: return
		GameConstants.MODES.R_ZONE:
			match action:
				ACTIONS.START:
					set_placer_component(RZone.create())
				ACTIONS.END:
					clear_placer_component()
				ACTIONS.MOVE:
					move_placer_component_to(gameboard.snap_to_grid(GameData.mouse_position, get_placer_component()))
				ACTIONS.CLICK:
					(get_placer_component() as RZone).attempt_to_zone(gameboard)
				_: return
		GameConstants.MODES.C_ZONE:
			match action:
				ACTIONS.START:
					set_placer_component(CZone.create())
				ACTIONS.END:
					clear_placer_component()
				ACTIONS.MOVE:
					move_placer_component_to(gameboard.snap_to_grid(GameData.mouse_position, get_placer_component()))
				ACTIONS.CLICK:
					(get_placer_component() as CZone).attempt_to_zone(gameboard)
				_: return
		GameConstants.MODES.I_ZONE:
			match action:
				ACTIONS.START:
					set_placer_component(IZone.create())
				ACTIONS.END:
					clear_placer_component()
				ACTIONS.MOVE:
					move_placer_component_to(gameboard.snap_to_grid(GameData.mouse_position, get_placer_component()))
				ACTIONS.CLICK:
					(get_placer_component() as IZone).attempt_to_zone(gameboard)
				_: return
		GameConstants.MODES.WALKWAY:
			standard_item_action_handler(Walkway, action)
		GameConstants.MODES.ROAD_4_LANE:
			standard_item_action_handler(Road4Lane, action, [Road4Lane.SETUP.NO_PARKING])
		GameConstants.MODES.ROAD_4_LANE_PARKING:
			standard_item_action_handler(Road4Lane, action, [Road4Lane.SETUP.PARKING])
		GameConstants.MODES.PARKING_LOT_2X2:
			standard_item_action_handler(ParkingLot2x2, action)
		_: push_error("Unknown placer mode: %d" % mode)

func standard_item_action_handler(item: Variant, action: int, creation_params: Array = []):
	match action:
		ACTIONS.START:
			if creation_params.size() > 0:
				set_placer_component(item.create.callv(creation_params))
			else:
				set_placer_component(item.create())
			build_phase_ui.open_item_placer_buttons(item.CAN_ROTATE, item.CAN_FLIP_V, item.CAN_FLIP_H) 
		ACTIONS.END:
			clear_placer_component()
			build_phase_ui.close_item_placer_buttons()
		ACTIONS.MOVE:
			if item is Walkway: 
				move_placer_component_to(gameboard.snap_size_to_grid(GameData.mouse_position, (get_placer_component() as Walkway).get_oriented_grid_size()))
			else:
				move_placer_component_to(gameboard.snap_to_grid(GameData.mouse_position, get_placer_component()))
		ACTIONS.CLICK:
			get_placer_component().attempt_to_place(gameboard)
		ACTIONS.ROTATE_90_CW:
			get_placer_component().rotate_90_cw()
		ACTIONS.FLIP_V:
			get_placer_component().flip_v()
		ACTIONS.FLIP_H:
			get_placer_component().flip_h()
		_: return
		

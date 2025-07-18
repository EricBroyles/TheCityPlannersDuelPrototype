extends Node

@onready var build_phase = %BuildPhase
@onready var simulation_phase = %SimulationPhase
@onready var end_game_screen = %EndGameScreen

func _ready() -> void:
	end_game_screen.visible = false
	start_build_phase()
	
func _unhandled_input(event: InputEvent):
	if build_phase.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			if GameData.gameboard_placer_mode != GameConstants.MODES.MOUSE_POINTER:
				GameData.gameboard_placer_mode = GameConstants.MODES.MOUSE_POINTER
			else:
				if build_phase.bottom_menu.visible: build_phase.close_bottom_menu()
				if build_phase.view_menu.visible: build_phase.toggle_view_menu()
				if build_phase.open_market_menu.visible: build_phase.toggle_open_market_menu()
				
func start_build_phase():
	GameData.gameboard_placer_mode = GameConstants.MODES.MOUSE_POINTER
	if GameData.turn < GameData.total_turns:
		GameData.turn += 1
		build_phase.visible = true
		simulation_phase.visible = false
	else:
		##THE GAME IS OVER
		build_phase.visible = false
		simulation_phase.visible = false
		end_game_screen.visible = true
	
func start_simulation_phase():
	build_phase.visible = false
	simulation_phase.visible = true
	GameData.gameboard_placer_mode = GameConstants.MODES.MOUSE_POINTER

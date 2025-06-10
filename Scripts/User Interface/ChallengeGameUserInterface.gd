extends Node

@onready var build_phase = %BuildPhase
@onready var simulation_phase = %SimulationPhase
@onready var end_game_screen = %EndGameScreen

func _ready() -> void:
	end_game_screen.visible = false
	start_build_phase()

func start_build_phase():
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

extends Node
@onready var main_ui = get_parent()

## Text
@onready var points_text = %PointsText
@onready var population_text = %PopulationText
@onready var money_text = %MoneyText
@onready var reputation_text = %ReputationText
@onready var r_demand_text = %RDemandText
@onready var c_demand_text = %CDemandText
@onready var i_demand_text = %IDemandText

@onready var turn_text = %TurnText
@onready var total_turn_text = %TotalTurnsText

@onready var skip_simulation_button = %SkipSimulationButton
@onready var run_simulation_button = %RunSimulationButton
@onready var pause_simulation_button = %PauseSimulationButton


func _ready() -> void:
	set_all_text()

func _process(_delta: float) -> void:
	if self.visible:
		update_all_text()
		
		
func _on_skip_simulation_button_pressed() -> void:
	main_ui.start_build_phase()

func _on_run_simulation_button_pressed() -> void:
	toggle_run_pause_buttons()

func _on_pause_simulation_button_pressed() -> void:
	toggle_run_pause_buttons()


## Helpers	
func toggle_run_pause_buttons():
	run_simulation_button.visible = !run_simulation_button.visible
	pause_simulation_button.visible = !pause_simulation_button.visible
	
func set_all_text():
	points_text.text = str(GameData.points)
	population_text.text = str(GameData.population)
	money_text.text = str(GameData.money)
	reputation_text.text = str(GameData.reputation)

	r_demand_text.text = str(GameData.r_demand)
	c_demand_text.text = str(GameData.c_demand)
	i_demand_text.text = str(GameData.i_demand)

	turn_text.text = str(GameData.turn)
	total_turn_text.text = str(GameData.total_turns)

func update_all_text():
	points_text.text = str(GameData.points)
	population_text.text = str(GameData.population)
	money_text.text = str(GameData.money)
	reputation_text.text = str(GameData.reputation)

	r_demand_text.text = str(GameData.r_demand)
	c_demand_text.text = str(GameData.c_demand)
	i_demand_text.text = str(GameData.i_demand)

	turn_text.text = str(GameData.turn)
	#total_turn_text.text = str(GameData.total_turns) Does not chnage

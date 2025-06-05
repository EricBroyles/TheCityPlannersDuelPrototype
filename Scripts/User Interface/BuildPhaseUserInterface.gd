extends Node

## Text
@onready var points_text = %PointsText
@onready var population_text = %PopulationText
@onready var money_text = %MoneyText
@onready var reputation_text = %ReputationText
@onready var r_demand_text = %RDemandText
@onready var c_demand_text = %CDemandText
@onready var i_demand_text = %IDemandText

@onready var cards_in_deck_text = %CurrentCardsInDeck

@onready var turn_text = %TurnText
@onready var total_turn_text = %TotalTurnsText

@onready var cost_per_r_demand_text = %CostPerRDemandText
@onready var cost_per_c_demand_text = %CostPerCDemandText
@onready var cost_per_i_demand_text = %CostPerIDemandText

## Buttons
#top bar
@onready var view_button = %ViewButton
@onready var settings_button = %SettingsButton
@onready var stats_button = %StatsButton
@onready var past_simulations_button = %PastSimulationsButton

#bottom right bar
@onready var finish_turn_button = %FinishTurnButton

#bottom left bar
@onready var buy_land_button = %BuyLandButton
@onready var zoning_button = %ZoningButton
@onready var build_button = %BuildButton
@onready var upgrade_button = %UpgradeButton
@onready var delete_button = %DeleteButton
@onready var card_button = %CardButton
@onready var open_market_button = %OpenMarketButton

#Item Placer
@onready var item_placer_x_button = %ItemPlacerXButton
@onready var item_info_button = %ItemInfoButton
@onready var rotate_90_button = %Rotate90Button
@onready var flip_vertical_button = %FlipVerticalButton
@onready var flip_horizontal_button = %FlipHorizontalButton

#bottom menu options tab
@onready var bottom_menu_x_button = %BottomMenuXButton
@onready var road_options_button = %RoadOptionsButton
@onready var junction_options_button = %JunctionOptionsButton
@onready var parking_options_button = %ParkingOptionsButton
@onready var bridge_options_button = %BridgeOptionsButton

#zoning options
@onready var unzone_button = %OwnedUnzonedButton
@onready var r_zone_button = %RZoneButton
@onready var c_zone_button = %CZoneButton
@onready var i_zone_button = %IZoneButton

#road options
@onready var walkway_button = %WalkwayButton
@onready var road_2_lane_button = %Road2LaneButton
@onready var road_4_lane_button = %Road4LaneButton
@onready var road_2_lane_parking_button = %Road2LaneParkingButton
@onready var road_4_lane_parking_button = %Road4LaneParkingButton
@onready var joint_2_lane_button = %Joint2LaneButton
@onready var joint_4_lane_button = %Joint4LaneButton
@onready var merge_2_and_4_button = %Merge2And4Button

#parking options
@onready var parking_lot_1x1 = %ParkingLot1x1Button
@onready var parking_lot_1x2_long_open = %ParkingLot1x2LongOpenButton
@onready var parking_lot_1x2_short_open = %ParkingLot1x2ShortOpenButton
@onready var parking_lot_2x2 = %ParkingLot2x2Button

#junction options
@onready var junction_1x1_button = %Junction1x1Button
@onready var junction_4_inlets_1x2_button = %Junction4Inlets1x2Button
@onready var junction_5_inlets_1x2_button = %Junction5Inlets1x2Button
@onready var junction_6_inlets_1x2_button = %Junction6Inlets1x2Button
@onready var junction_2x2_button = %Junction2x2Button
@onready var junction_5_inlets_2x2_button = %Junction5Inlets2x2Button
@onready var junction_6_inlets_2x2_across_button = %Junction6Inlets2x2AcrossButton
@onready var junction_6_inlets_2x2_next_button = %Junction6Inlets2x2NextButton
@onready var junction_7_inlets_2x_button2= %Junction7Inlets2x2Button
@onready var junction_8_inlets_2x2_button = %Junction8Inlets2x2Button

#bridge options
@onready var bridge_ramp_2_lane_straight_button = %BridgeRamp2LaneStraightButton
@onready var bridge_2_lane_straight_button = %Bridge2LaneStraightButton
@onready var bridge_2_lane_joint_button = %Bridge2LaneJointButton

## Menu Buttons
#Open Market
@onready var open_market_menu_x_button = %OpenMarketMenuXButton

@onready var buy_1_r_button = %Buy1RButton
@onready var buy_10_r_button = %Buy10RButton
@onready var buy_100_r_button = %Buy100RButton

@onready var buy_1_c_button = %Buy1CButton
@onready var buy_10_c_button = %Buy10CButton
@onready var buy_100_c_button = %Buy100CButton

@onready var buy_1_i_button = %Buy1IButton
@onready var buy_10_i_button = %Buy10IButton
@onready var buy_100_i_button = %Buy100IButton

#View
@onready var view_menu_x_button = %ViewMenuXButton

@onready var bridge_hide_button = %BridgeHideButton
@onready var r_hide_button = %RHideButton
@onready var c_hide_button = %CHideButton
@onready var i_hide_button = %IHideButton
@onready var bridge_show_button = %BridgeShowButton
@onready var r_show_button = %RShowButton
@onready var c_show_button = %CShowButton
@onready var i_show_button = %IShowButton

## Areas
@onready var open_market_menu = %OpenMarketMenu
@onready var view_menu = %ViewMenu
@onready var card_template_layout = %CardTemplateLayout
@onready var bottom_menu = %BottomMenu
@onready var item_placer_buttons = %ItemPlacerButtons
@onready var zoning_options = %ZoningOptions
@onready var road_options = %RoadOptions
@onready var parking_options = %ParkingOptions
@onready var junction_options = %JunctionOptions
@onready var bridge_options = %BridgeOptions
@onready var bottom_menu_button_row = %BottomMenuButtonRow

## Helpers







# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	open_market_menu.visible = false
	view_menu.visible = false
	card_template_layout.visible = false
	bottom_menu.visible = false
	item_placer_buttons.visible = false
	zoning_options.visible = false
	road_options.visible = false
	parking_options.visible = false
	junction_options.visible = false
	bridge_options.visible = false
	bottom_menu_button_row.visible = false
	
	
	points_text.text = str(GameData.points)
	population_text.text = str(GameData.population)
	money_text.text = str(GameData.money)
	reputation_text.text = str(GameData.reputation)

	r_demand_text.text = str(GameData.r_demand)
	c_demand_text.text = str(GameData.c_demand)
	i_demand_text.text = str(GameData.i_demand)

	cards_in_deck_text.text = str(GameData.cards_in_deck)

	turn_text.text = str(GameData.turn)
	total_turn_text.text = str(GameData.total_turns)

	cost_per_r_demand_text.text = str(GameData.cost_per_r_demand)
	cost_per_c_demand_text.text = str(GameData.cost_per_c_demand)
	cost_per_i_demand_text.text = str(GameData.cost_per_i_demand)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible:
		#print(game_manager.turn)
		pass
		
# Open View/Open Market menus -> close all other menus, close the item_placer

## Buttons
#Bottom Left Button Block
func _on_buy_land_button_pressed() -> void:
	pass 

func _on_zoning_button_pressed() -> void:
	pass 
	
func _on_build_button_pressed() -> void:
	pass 
	
func _on_upgrade_button_pressed() -> void:
	pass 
	
func _on_delete_button_pressed() -> void:
	pass 
	
func _on_card_button_pressed() -> void:
	card_template_layout.visible = !card_template_layout.visible
	

func _on_open_market_button_pressed() -> void:
	open_market_menu.visible = !open_market_menu.visible
	print("Open Market Button Pressed,  Visible: ", open_market_menu.visible)

#Top Bar
func _on_view_button_pressed() -> void:
	pass 

#Open Market Menu
func _on_open_market_menu_x_button_pressed() -> void:
	pass 

func _on_buy_1_r_button_pressed() -> void:
	pass 

func _on_buy_10_r_button_pressed() -> void:
	pass 

func _on_buy_100_r_button_pressed() -> void:
	pass 

func _on_buy_1_c_button_pressed() -> void:
	pass 

func _on_buy_10_c_button_pressed() -> void:
	pass 

func _on_buy_100_c_button_pressed() -> void:
	pass 

func _on_buy_1_i_button_pressed() -> void:
	pass 

func _on_buy_10_i_button_pressed() -> void:
	pass 

func _on_buy_100_i_button_pressed() -> void:
	pass 


#View Menu
func _on_view_menu_x_button_pressed() -> void:
	pass # Replace with function body.

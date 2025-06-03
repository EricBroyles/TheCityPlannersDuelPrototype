extends Node

## Text
@onready var points_text = %PointsText
@onready var people_text = %PeopleText
@onready var money_text = %MoneyText
@onready var reputation_text = %ReputationText

@onready var r_demand_text = %RDemandText
@onready var c_demand_text = %CDemandText
@onready var i_demand_text = %IDemandText

@onready var cards_in_deck_text = %CurrentCardsInDeck

@onready var turn_text = %CurrentTurnText
@onready var total_turn_text = %TotalTurnText

## Buttons
@onready var view_button = %ViewButton
@onready var settings_button = %ViewButton
@onready var stats_button = %StatsButton
@onready var past_simulations_button = %PastSimulationsButton

@onready var item_placer_x_button = %ItemPlacerXButton
@onready var item_info_button = %ItemInfoButton
@onready var rotate_90_button = %Rotate90Button
@onready var flip_vertical_button = %FlipVerticalButton
@onready var flip_horizontal_button = %FlipHorizontalButton

@onready var bottom_menu_x_button = %BottomMenuXButton
@onready var road_options_button = %RoadOptionsButton
@onready var junction_options_button = %JunctionOptionsButton
@onready var parking_options_button = %ParkingOptionsButton
@onready var bridge_options_button = %BridgeOptionsButton

@onready var unzone_button = %UnzoneButton
@onready var r_zone_button = %RZoneButton
@onready var c_zone_button = %CZoneButton
@onready var i_zone_button = %IZoneButton

@onready var walkway_button = %WalkwayButton
@onready var road_2_lane_button = %Road2LaneButton
@onready var road_4_lane_button = %Road4LaneButton
@onready var road_2_lane_parking_button = %Road2LaneParkingButton
@onready var road_4_lane_parking_button = %Road4LaneParkingButton
@onready var joint_2_lane_button = %Joint2LaneButton
@onready var joint_4_lane_button = %Joint4LaneButton
@onready var merge_2_and_4_button = %Merge2And4Button

@onready var parking_lot_1x1 = %Parking1x1Button
@onready var parking_lot_1x2_long_open = %Parking1x2LongOpeningButton
@onready var parking_lot_1x2_short_open = %Parking1x2ShortOpeningButton
@onready var parking_lot_2x2 = %Parking2x2Button

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

@onready var bridge_ramp_2_lane_straight_button = %BridgeRampButton
@onready var bridge_2_lane_straight_button = %BridgeStraightButton
@onready var bridge_2_lane_joint_button = %BridgeJointButton




##this just displays the infrmation stored inside of challengeGame class (want to get stuff onreadu)
##it needs to handle the various buttons displaying stuff
##when you hit the chekmark button -> this calls ChallengeGameUserInterFace (UI layer) which has the method to swap between control layouts.




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible:
		#print(game_manager.turn)
		pass
		
	

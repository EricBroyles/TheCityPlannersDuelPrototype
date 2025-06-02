extends Node

@onready var game_manager = %GameManager

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
		
	

extends Node

## Game Info
var total_turns: int = 40
var turn: int = 0

var points: int = 0
var population: int = 0
var money: int = 0
var reputation: int = 0
var r_demand: int = 0
var c_demand: int = 0
var i_demand: int = 0

## Cards
var cards_in_deck: int = 20 #current cards in deck

## Starting Gift
var money_starting_gift_amount: int = 10000
var money_starting_gift_turns: int = 3 #the number of turns to recieve the gift for.



##this will likly need to be moved into the class
## Costs of Zoning
#cost to buy demand in points
var cost_per_r_demand: int = 1200
var cost_per_c_demand: int = 1200
var cost_per_i_demand: int = 1200

#cost in demand points to place a one zone tile
var r_zone_demand_cost: int = 1
var c_zone_demand_cost: int = 1
var i_zone_demand_cost: int = 1


## probably want these in a dictionary, that utilize the same naming as each game item. 
##!!!!!This should all be held int the respective classes for each item. 
## Costs of Game Items
## Maintaince Costs

#cost of each thing like road, parking lot, ...
#maintaince cost of everything.
#cost of all upgrades
#cost of all destruction



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

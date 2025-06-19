extends Node

## User Controller
# User Mouse Controller
var mouse_button_left = 1
var mouse_button_right = 2
var mouse_button_middle = 3

## User Interface

var gameboard_placer_mode: int = GameConstants.MODES.MOUSE_POINTER

## Gameboard
var gameboard_r: int = 10
var gameboard_c: int = 20


#var gameboard_items_matrix: Array #3D matrix with array of GameboardItem at each index.

## Mouse Position
var mouse_position: Vector2

## Game Info
var total_turns: int = 40
var turn: int = 0

var points: int = 1000000
var population: int = 0
var money: int = 2500 * 4
var reputation: int = 100
var r_demand: int = 100
var c_demand: int = 20
var i_demand: int = 20

## Cards
var cards_in_deck: int = 20 #current cards in deck

## Starting Gift
var money_starting_gift_amount: int = 10000
var money_starting_gift_turns: int = 3 #the number of turns to recieve the gift for.


##Cost of Buying Land
# in money
var cost_per_land_tile: int = 250

## Costs of Zoning
#cost to buy demand in points
var cost_per_r_demand: int = 1100
var cost_per_c_demand: int = 1100
var cost_per_i_demand: int = 1100

var hide_bridges: bool = false
var hide_r_zone: bool = false
var hide_c_zone: bool = false
var hide_i_zone: bool = false



## probably want these in a dictionary, that utilize the same naming as each game item. 
##!!!!!This should all be held int the respective classes for each item. 
## Costs of Game Items
## Maintaince Costs

#cost of each thing like road, parking lot, ...
#maintaince cost of everything.
#cost of all upgrades
#cost of all destruction

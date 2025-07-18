extends Node

## User Interface
var gameboard_placer_mode: int = GameConstants.MODES.MOUSE_POINTER

## Gameboard
var gameboard_r: int = 20
var gameboard_c: int = 30

## Mouse Position
var mouse_position: Vector2

## Game Info
var total_turns: int = 40
var turn: int = 0

var points: int = 1000000
var population: int = 0
var money: int = 250 * 10000
var reputation: int = 100
var r_demand: int = 100
var c_demand: int = 20
var i_demand: int = 20

## Cards
var cards_in_deck: int = 20 #current cards in deck

## Starting Gift
var starting_gift_amount: int = 10000
var starting_gift_turns: int = 3 #the number of turns to recieve the gift for.

##Cost of Buying Land
# in money
var cost_per_land_tile: int = GameConstants.MONEY_PER_LAND_TILE

## Costs of Zoning
#cost to buy demand in points
var cost_per_r_demand: int = GameConstants.POINTS_PER_R_DEMAND
var cost_per_c_demand: int = GameConstants.POINTS_PER_C_DEMAND
var cost_per_i_demand: int = GameConstants.POINTS_PER_I_DEMAND

var hide_bridges: bool = false
var hide_r_zone: bool = false
var hide_c_zone: bool = false
var hide_i_zone: bool = false

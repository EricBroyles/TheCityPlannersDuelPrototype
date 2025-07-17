extends Node

## Stores the static loads for all gameboard items and gameboard tiles and gameboard agents ie game components


## Gameboard Tiles
const GROUND_TILE: PackedScene = preload("res://Scenes/Gameboard Tiles/GroundTile.tscn")
const LIGHT_GROUND_TILE: PackedScene = preload("res://Scenes/Gameboard Tiles/LightGroundTile.tscn")
const OWNED_UNZONED_TILE: PackedScene = preload("res://Scenes/Gameboard Tiles/OwnedUnzonedTile.tscn")
const R_ZONE_TILE: PackedScene = preload("res://Scenes/Gameboard Tiles/ResZoneTile.tscn")
const C_ZONE_TILE: PackedScene = preload("res://Scenes/Gameboard Tiles/ComZoneTile.tscn")
const I_ZONE_TILE: PackedScene = preload("res://Scenes/Gameboard Tiles/IndZoneTile.tscn")

## Gameboard Agents

## Gameboard Items
const WALKWAY: PackedScene = preload("res://Scenes/Gameboard Items/Walkway.tscn")
const ROAD_4_LANE: PackedScene = preload("res://Scenes/Gameboard Items/Road4Lane.tscn")
const PARKING_LOT_2X2: PackedScene = preload("res://Scenes/Gameboard Items/ParkingLot2x2.tscn")

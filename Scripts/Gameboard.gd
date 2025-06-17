extends Node2D

class_name Gameboard
@onready var gameboard_base_tiles = $BaseTiles
@onready var gameboard_tiles = $Tiles
@onready var gameboard_items = $Items
#@onready var gameboard_placer = $Placer

var top_left_tile_position: Vector2 = Vector2(0,0)
var tiles_shift: Vector2 = Vector2(int(GameConstants.GAMEBOARD_TILE_SIZE/2.0),int(GameConstants.GAMEBOARD_TILE_SIZE/2.0)) #this exists to shift the tiles so the top left corner of the gameboard is a (0,0), this is needed as center of tile is in its middle

func _process(_delta: float) -> void:
	pass

##Get Gameboard size
# returns vector2(width, height)
func get_gameboard_size() -> Vector2:
	var size = Vector2(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE, GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE) #(width, height)
	return size
	
##Get Gameboard Center
#  returns vector2(x,y) of the center of the gameboard
func get_gameboard_center() -> Vector2:
	var center = Vector2(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE / 2, GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE / 2)
	return center
	
###Init Gameboard Matrix
##  any size: r x c (r is num of rows and c is num of col)
##  returns [], or 3D matrix (2D matrix of size rxc, and ten at each spot has another array to hold the gameboard_items)
#func init_gameboard_items_matrix():
	#var r: int = GameData.gameboard_r
	#var c: int = GameData.gameboard_c
	#var matrix = []
	#for i in r:
		#var row = []
		#for j in c:
			#row.append([])
		#matrix.append(row)
		#
	#GameData.gameboard_items_matrix = matrix

## Make Gameboard
#  any size: r x c (r is num of rows and c is num of col)
#  crates the r x c matrix inside the scene
# this also sets the gameboard to array of just 0's
# all tiles have pivot_offset to set their center to their midpoint
#  returns nothing
func make_gameboard() -> void:
	var r: int = GameData.gameboard_r
	var c: int = GameData.gameboard_c
	var tile: Node2D
	var tile_position: Vector2 = top_left_tile_position
	
	for i in range(r):
		for j in range(c):
			var type = (i + j) %2
			tile = GameComponents.GROUND_TILE.instantiate() if type == 1 else GameComponents.LIGHT_GROUND_TILE.instantiate() 
			tile.position = tile_position
			gameboard_base_tiles.add_child(tile)
			tile_position.x += GameConstants.GAMEBOARD_TILE_SIZE
			
		tile_position.x = top_left_tile_position.x
		tile_position.y += GameConstants.GAMEBOARD_TILE_SIZE
	
	gameboard_base_tiles.position += tiles_shift

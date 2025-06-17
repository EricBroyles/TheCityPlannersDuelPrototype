extends Node2D

class_name GameboardTile

@onready var body = %Body
@onready var main_body_hitbox = %MainBodyHitbox

var size: Vector2 = Vector2(GameConstants.GAMEBOARD_TILE_SIZE, GameConstants.GAMEBOARD_TILE_SIZE)

func find_overlapping_areas() -> Array:
	return main_body_hitbox.get_overlapping_areas()


	
	

extends GameboardComponent
class_name GameboardTile

@onready var body = %Body

func get_oriented_size() -> Vector2:
	return Vector2(GameConstants.GAMEBOARD_TILE_SIZE, GameConstants.GAMEBOARD_TILE_SIZE)

func _set_transform_from(other: GameboardTile):
	self.position = other.global_position
	
	

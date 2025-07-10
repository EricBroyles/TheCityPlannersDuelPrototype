extends GameboardComponent
class_name GameboardTile

@onready var body = %Body

func get_oriented_size() -> Vector2:
	return Vector2(GameConstants.GAMEBOARD_TILE_SIZE, GameConstants.GAMEBOARD_TILE_SIZE)

func set_properties_from(other: GameboardTile):
	## used for deal with duplication. Make a new instance, then call this on the new instance passing it the object you want to duplicated
	self.position = other.global_position
	
	

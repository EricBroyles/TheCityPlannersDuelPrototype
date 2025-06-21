extends GameboardComponent

class_name GameboardTile

@onready var body = %Body
@onready var main_body_hitbox = %MainBodyHitbox

func get_oriented_size() -> Vector2:
	return Vector2(GameConstants.GAMEBOARD_TILE_SIZE, GameConstants.GAMEBOARD_TILE_SIZE)

func find_overlapping_areas() -> Array:
	return main_body_hitbox.get_overlapping_areas()


## used for deal with duplication. Make a new instance, then call this on the new instance passing it the object you want to duplicated
func set_properties_from(other: GameboardTile):
	self.position = other.position
	
	

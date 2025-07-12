extends Resource
class_name GameboardContainer

var r: int
var c: int
var components: Array[GameboardComponent]

func set_coord(row: int, col: int) -> void:
	r = row
	c = col
	
func get_top_left_position() -> Vector2:
	return Vector2(c, r) * GameConstants.GAMEBOARD_CONTAINER_SIZE
	
func get_tiles() -> Array[GameboardTile]:
	var tiles: Array[GameboardTile] = []
	for comp in components:
		if comp is GameboardTile:
			tiles.append(comp as GameboardTile)
	return tiles
	
func get_items() -> Array[GameboardItem]:
	var items: Array[GameboardItem] = []
	for comp in components:
		if comp is GameboardItem:
			items.append(comp as GameboardItem)
	return items
	
func add(component: GameboardComponent):
	components.append(component)
	
func delete(component: GameboardComponent):
	if component in components:
		components.erase(component)

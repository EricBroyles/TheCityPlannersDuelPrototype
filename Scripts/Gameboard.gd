extends Node2D
class_name Gameboard

@onready var gameboard_base_tiles = $BaseTiles
@onready var gameboard_tiles = $Tiles
@onready var gameboard_items = $Items
@onready var gameboard_placer = $Placer

var matrix: Array[Array] #2D matrix of GameboardContainers

func make_gameboard() -> void:
	var r: int = GameData.gameboard_r
	var c: int = GameData.gameboard_c
	var tile: Node2D
	var top_left_tile_position: Vector2 = Vector2(0,0)
	var tiles_shift: Vector2 = Vector2(int(GameConstants.GAMEBOARD_TILE_SIZE/2.0),int(GameConstants.GAMEBOARD_TILE_SIZE/2.0)) #this exists to shift the tiles so the top left corner of the gameboard is a (0,0), this is needed as center of tile is in its middle
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
	
	_init_matrix()
	
func _init_matrix() -> void:
	# Ensure tile size is divisible evenly by container size
	if GameConstants.GAMEBOARD_TILE_SIZE % GameConstants.GAMEBOARD_CONTAINER_SIZE != 0:
		push_error("Tile size must be evenly divisible by container size!")
		return

	var containers_per_tile: int = int(round(GameConstants.GAMEBOARD_TILE_SIZE / float(GameConstants.GAMEBOARD_CONTAINER_SIZE)))
	var total_rows: int = GameData.gameboard_r * containers_per_tile
	var total_cols: int = GameData.gameboard_c * containers_per_tile

	matrix = []

	for r in range(total_rows):
		var row = []
		for c in range(total_cols):
			var container := GameboardContainer.new()
			container.set_coord(r, c)  # optional: assign grid position
			row.append(container)
		matrix.append(row)
			
func get_gameboard_size() -> Vector2:
	return Vector2(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE, GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE) #(width, height)
	
func get_gameboard_center() -> Vector2:
	return Vector2(int(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE / 2.0), int(GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE / 2.0))

func count_tiles() -> int:
	return gameboard_tiles.get_child_count()
	
func count_items() -> int:
	return gameboard_items.get_child_count()
	
func count_components() -> int:
	return count_tiles() + count_items()
	
func display_items():
	var tile_size := 25  # e.g., 8

	for g_r in GameData.gameboard_r:
		for g_c in GameData.gameboard_c:
			print("R:", g_r, " --- C:", g_c)

			var start_row := g_r * tile_size
			var end_row := start_row + tile_size
			var start_col := g_c * tile_size
			var end_col := start_col + tile_size

			for row in range(start_row, end_row):
				var line := ""
				for col in range(start_col, end_col):
					var items := (matrix[row][col] as GameboardContainer).get_items()
					if items.size() > 0:
						var labels := []
						for item in items:
							labels.append(item.get_class_name()) 
						line += str(labels)
					else:
						line += " []"
					line += " "
				line += ""
				print(line)
			print("") 
	
func snap_to_grid(requested_position: Vector2, component: GameboardComponent) -> Vector2:
	#assumes that components position pointer is at their center	
	#sets the position of the component to the proper location to keep it snaped to boxes
	return snap_size_to_grid(requested_position, component.get_oriented_size())
	
func snap_size_to_grid(requested_position: Vector2, size: Vector2) -> Vector2:
	var requested_top_left_position: Vector2 = requested_position - size/2
	var new_top_left_position: Vector2 = round(requested_top_left_position / GameConstants.GAMEBOARD_TILE_SIZE) * GameConstants.GAMEBOARD_TILE_SIZE
	var snapped_position: Vector2 = new_top_left_position + size/2
	return round(snapped_position)
	
func is_fully_in_bounds(component: GameboardComponent) -> bool:
	var board_size: Vector2 = get_gameboard_size()         
	var top_left: Vector2 = component.get_top_left_position()
	var bottom_right: Vector2 = top_left + component.get_oriented_size()

	return  top_left.x >= 0                \
		and top_left.y >= 0                \
		and bottom_right.x <= board_size.x \
		and bottom_right.y <= board_size.y

func is_fully_out_of_bounds(component: GameboardComponent) -> bool:
	var board_size: Vector2 = get_gameboard_size()
	var top_left: Vector2 = component.get_top_left_position()
	var bottom_right: Vector2 = top_left + component.get_oriented_size()

	# No overlap with the board at all
	return bottom_right.x <= 0        \
		or top_left.x >= board_size.x \
		or bottom_right.y <= 0        \
		or top_left.y >= board_size.y

func is_partially_out_of_bounds(component: GameboardComponent) -> bool:
	# Partially‑out means: it’s NOT fully in AND NOT fully out
	return not is_fully_in_bounds(component) \
		and not is_fully_out_of_bounds(component)

func _get_coord_at(point: Vector2) -> Vector2:
	#is not restricted to return a coord inside the matrix
	var row: int = int(floor(point.y / GameConstants.GAMEBOARD_CONTAINER_SIZE))
	var col: int = int(floor(point.x / GameConstants.GAMEBOARD_CONTAINER_SIZE))
	return Vector2(row, col)
	
func _get_coords_from(center_point: Vector2, size: Vector2) -> Array[Vector2]:
	#is not restricted to return coords inside the matrix
	var half_size: Vector2 = size * 0.5
	var top_left: Vector2 = center_point - half_size
	var bottom_right: Vector2 = center_point + half_size

	var start_row: int = int(floor(top_left.y / GameConstants.GAMEBOARD_CONTAINER_SIZE))
	var end_row: int = int(floor((bottom_right.y - 1) / GameConstants.GAMEBOARD_CONTAINER_SIZE))
	var start_col: int = int(floor(top_left.x / GameConstants.GAMEBOARD_CONTAINER_SIZE))
	var end_col: int = int(floor((bottom_right.x - 1) / GameConstants.GAMEBOARD_CONTAINER_SIZE))

	var coords: Array[Vector2] = []
	for row in range(start_row, end_row + 1):
		for col in range(start_col, end_col + 1):
			coords.append(Vector2(row, col))
			
	return coords
	
func get_components_at(point: Vector2) -> Array[GameboardComponent]:
	var components: Array[GameboardComponent] = []
	var coord: Vector2 = _get_coord_at(point)
	if GameHelper.is_coord_in_matrix(coord, matrix):
		components = (matrix[coord.x][coord.y] as GameboardContainer).components
	return components
	
func find_top_item_at(point: Vector2) -> GameboardItem:
	#this uses z index not elevation ---- keep in mind that sidewalk has a 51 z and crosswalk has like 50 z but the same elevation
	#this to help determine what has been selected. DO not use z index for determining item collisions use elevation
	var top_item: GameboardItem = null
	for comp in get_components_at(point):
		if comp is GameboardItem and (top_item == null or comp.z_index > top_item.z_index):
			top_item = comp as GameboardItem
	return top_item
		
func get_components_overlapping_with(component: GameboardComponent) -> Array[GameboardComponent]:
	var overlapping_components: Dictionary = {}
	var unique_components: Array[GameboardComponent] = []
	for coord in _get_coords_from(component.position, component.get_oriented_size()):
		if GameHelper.is_coord_in_matrix(coord, matrix):
			for comp in (matrix[coord.x][coord.y] as GameboardContainer).components:
				if not overlapping_components.has(comp):
					unique_components.append(comp as GameboardComponent)
				overlapping_components[comp] = true
	return unique_components 
	
func get_tiles_overlapping_with(component: GameboardComponent) -> Array[GameboardTile]:
	var overlapping_tiles: Dictionary = {}
	var unique_tiles: Array[GameboardTile] = []
	for coord in _get_coords_from(component.position, component.get_oriented_size()):
		if GameHelper.is_coord_in_matrix(coord, matrix):
			for tile in (matrix[coord.x][coord.y] as GameboardContainer).get_tiles():
				if not overlapping_tiles.has(tile):
					unique_tiles.append(tile as GameboardTile)
				overlapping_tiles[tile] = tile as GameboardTile
	return unique_tiles
	
func get_items_overlapping_with(component: GameboardComponent) -> Array[GameboardItem]:
	var overlapping_items: Dictionary = {}
	var unique_items: Array[GameboardItem] = []
	for coord in _get_coords_from(component.position, component.get_oriented_size()):
		if GameHelper.is_coord_in_matrix(coord, matrix):
			for item in (matrix[coord.x][coord.y] as GameboardContainer).get_items():
				if not overlapping_items.has(item):
					unique_items.append(item as GameboardItem)
				overlapping_items[item] = item as GameboardItem
	return unique_items

func get_items_colliding_with(item: GameboardItem) -> Array[GameboardItem]:
	var colliding_items: Array[GameboardItem] = []
	for overlap_item in get_items_overlapping_with(item):
		if item.is_colliding_with_overlapping_item(overlap_item):
			colliding_items.append(overlap_item)
	return colliding_items
	
func is_land_fully_owned(item: GameboardItem) -> bool:
	#is_item_fully_overlapping_owned_tiles
	for tile in get_tiles_overlapping_with(item):
		if not GameHelper.is_owned_tile(tile): return false
	return true
	
func is_land_partially_owned(item: GameboardItem) -> bool:
	#is_item_overlapping_a_owned_tile: best used for walkways
	for tile in get_tiles_overlapping_with(item):
		if GameHelper.is_owned_tile(tile): return true
	return false

func attempt_to_upgrade_item_at(point: Vector2) -> bool:
	var item_to_upgrade: GameboardItem = find_top_item_at(point)
	if item_to_upgrade == null: return false
	var did_upgrade: bool = item_to_upgrade.attempt_to_upgrade()
	return did_upgrade
	
func attempt_to_delete_item_at(point: Vector2) -> bool:
	var item_to_delete: GameboardItem = find_top_item_at(point)
	if item_to_delete == null: return false
	var did_delete: bool = item_to_delete.attempt_to_delete(self)
	return did_delete

func add_component(component: GameboardComponent):
	_add_to_matrix(component)
	if component is GameboardTile:
		gameboard_tiles.add_child(component)
	elif component is GameboardItem:
		gameboard_items.add_child(component)
	else:
		push_error("Failed to add component: ", component, " to gameboard as it is not type Tile or Item")

func delete_component(component: GameboardComponent):
	_delete_from_matrix(component)
	if component is GameboardTile:
		gameboard_tiles.remove_child(component)
	elif component is GameboardItem:
		gameboard_items.remove_child(component)
	else:
		push_error("Failed to remove component: ", component, " from gameboard as it is not type Tile or Item")
		
func _add_to_matrix(component: GameboardComponent):
	for coord in _get_coords_from(component.position, component.get_oriented_size()):
		if GameHelper.is_coord_in_matrix(coord, matrix):
			(matrix[coord.x][coord.y] as GameboardContainer).add(component)
	
func _delete_from_matrix(component: GameboardComponent):
	for coord in _get_coords_from(component.position, component.get_oriented_size()):
		if GameHelper.is_coord_in_matrix(coord, matrix):
			(matrix[coord.x][coord.y] as GameboardContainer).delete(component)

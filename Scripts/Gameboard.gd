extends Node2D

class_name Gameboard

@onready var gameboard_base_tiles = $BaseTiles
@onready var gameboard_tiles = $Tiles
@onready var gameboard_items = $Items
@onready var gameboard_placer = $Placer

var boxes: Array[Array] #2D matrix of Boxes
var edges: Array[Array] #2D matrix of Edges

var top_left_tile_position: Vector2 = Vector2(0,0)
var tiles_shift: Vector2 = Vector2(int(GameConstants.GAMEBOARD_TILE_SIZE/2.0),int(GameConstants.GAMEBOARD_TILE_SIZE/2.0)) #this exists to shift the tiles so the top left corner of the gameboard is a (0,0), this is needed as center of tile is in its middle

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
	
	
	
## Init Boxes: create a 2D matrix where at each spot their is an empty array
func init_boxes():
	var matrix: Array[Array] = []
	for r in GameData.gameboard_r:
		var row: Array = []
		for c in GameData.gameboard_c:
			var box := Box.new()
			box.r = r
			box.c = c
			row.append(box) 
		matrix.append(row)
	boxes = matrix

func print_boxes():
	var file := FileAccess.open("res://Notes/view_boxes.txt", FileAccess.WRITE)
	if file == null:
		print("Failed to open file.")
		return
	
	# Write column headers
	var header := "Row/Col"
	if boxes.size() > 0:
		for c in range(boxes[0].size()):
			header += ",Col %d" % c
	file.store_line(header)
	
	# Write each row
	for r in range(boxes.size()):
		var row_data := "Row %d" % r
		for c in range(boxes[r].size()):
			var box: Box = boxes[r][c]
			# You can customize what "components" means here; converting array to string
			row_data += "," + str(box.components)
		file.store_line(row_data)

	file.close()
	print("CSV written to res://Notes/view_boxes.txt")
	
## Init Edges
func init_edges():
	var horizontal_edges: Array[Array] = []
	for r in GameData.gameboard_r + 1:
		var row: Array = []
		for c in GameData.gameboard_c:
			var edge := Edge.new()
			edge.r = r
			edge.c = c
			row.append(edge) 
		horizontal_edges.append(row)
	
	var vertical_edges: Array[Array] = []
	for r in GameData.gameboard_r:
		var row: Array = []
		for c in GameData.gameboard_c + 1:
			var edge := Edge.new()
			edge.r = r
			edge.c = c
			row.append(edge) 
		vertical_edges.append(row)
		
	#merge these two together by alternating rows of hor then vert
	var matrix: Array[Array] = []
	for r in range(GameData.gameboard_r):
		matrix.append(horizontal_edges[r])
		matrix.append(vertical_edges[r])
	# Add the final bottom row of horizontal_edges
	matrix.append(horizontal_edges[GameData.gameboard_r])
	edges = matrix
	
func print_edges():
	var file := FileAccess.open("res://Notes/view_edges.txt", FileAccess.WRITE)
	if file == null:
		print("Failed to open file.")
		return
	
	# Write column headers
	var header := "Row/Col"
	if edges.size() > 0:
		for c in range(edges[0].size()):
			header += ",Col %d" % c
	file.store_line(header)
	
	# Write each row
	for r in range(edges.size()):
		var row_data := "Row %d" % r
		for c in range(edges[r].size()):
			var edge: Edge = edges[r][c]
			# You can customize what "components" means here; converting array to string
			row_data += "," + str(edge.components)
		file.store_line(row_data)

	file.close()
	print("CSV written to res://Notes/view_edges.txt")
			
func get_gameboard_size() -> Vector2:
	return Vector2(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE, GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE) #(width, height)
	
func get_gameboard_center() -> Vector2:
	return Vector2(int(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE / 2.0), int(GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE / 2.0))
	
# returns: {"boxes": Array[Box], "is_fully_contained": bool}
func contained_by_boxes(component: GameboardComponent) -> Dictionary:

	var component_inside_these_boxes: Array[Box] = []
	var is_fully_contained: bool = true
	
	var size: Vector2 = component.get_oriented_size()
	var size_in_tile_units: Vector2 = round(Vector2(size.y, size.x) / GameConstants.GAMEBOARD_TILE_SIZE) #(num rows, num cols)
	var top_left_point: Vector2 = component.get_top_left_position()
	var top_left_index: Vector2 = round(Vector2(top_left_point.y, top_left_point.x) / GameConstants.GAMEBOARD_TILE_SIZE)
	
	for r in range(size_in_tile_units.x):
		for c in range(size_in_tile_units.y):
			var component_section_index: Vector2 = top_left_index + Vector2(r, c) #this is like each tile of a component
			if GameHelper.is_index_in_matrix(component_section_index, boxes):
				component_inside_these_boxes.append(boxes[component_section_index.x][component_section_index.y])
			else:
				is_fully_contained = false
				
	var result: Dictionary = {
		"boxes": component_inside_these_boxes,
		"is_fully_contained": is_fully_contained
	}
	return result

#see whatever the fuck  did for contained_by_boxes
# returns: {"edges": Array[Vector2], "is_fully_contained": bool}
func contained_by_edges(component: GameboardComponent) -> Dictionary:
	## TO BE FINISHED
	return {}
	
#assumes that components position pointer is at their center	
#sets the position of the component to the proper location to keep it snaped to boxes
func snap_to_boxes(requested_position: Vector2, component: GameboardComponent) -> Vector2:
	var requested_top_left_position: Vector2 = requested_position - component.get_oriented_size()/2
	var new_top_left_position: Vector2 = round(requested_top_left_position / GameConstants.GAMEBOARD_TILE_SIZE) * GameConstants.GAMEBOARD_TILE_SIZE
	var snapped_position: Vector2 = new_top_left_position + component.get_oriented_size()/2
	return round(snapped_position)
	
	
func snap_to_edges(requested_position: Vector2, component: GameboardComponent) -> Vector2:
	## TO BE FINISHED
	return Vector2(0,0)

# given a component. be sure to set its position to reflect where you want it in game space
# look up its boxes (contained_by_boxes)
# return all the objects inside of the boxes that this componet is on.
func get_components_in_shared_boxes(component: GameboardComponent) -> Array[GameboardComponent]:
	var unique_dict := {}  # Keys will be the components, values don't matter
	for box in contained_by_boxes(component)["boxes"]:
		for comp in box.components:
			unique_dict[comp] = true  # Add as key; duplicates will be overwritten
			
	var components_array: Array[GameboardComponent] = []
	for comp in unique_dict.keys():
		components_array.append(comp as GameboardComponent)  # Safe cast per element
	return components_array

#get_components_in_shared_boxes
func shares_edges_with(component: GameboardComponent) -> Array[GameboardComponent]:
	return []
	

## USE add_to_boxes and remove_from_boxes to add/remove items in general
func add_to_boxes(component: GameboardComponent):
	#assumes component is snaped to boxes
	#this does not error handle. if you call this it will place it at all the boxes it is inside
	var add_to_these_boxes: Array[Box] = contained_by_boxes(component)["boxes"]
	for box in add_to_these_boxes:
		box.add(component)
		
	_add_to_scene(component)

func remove_from_boxes(component: GameboardComponent):
	var remove_from_these_boxes: Array[Box] = contained_by_boxes(component)["boxes"]
	for box in remove_from_these_boxes:
		box.remove(component)
		
	_remove_from_scene(component)


## add_to_scene and remove_from_scene are just helpers for add_to_boxes and remove_from_boxes
func _add_to_scene(component: GameboardComponent):
	if component is GameboardTile:
		gameboard_tiles.add_child(component)
	elif component is GameboardItem:
		gameboard_items.add_child(component)
	else:
		push_error("Failed to add component: ", component, " to gameboard as it is not type Tile or Item")

func _remove_from_scene(component: GameboardComponent):
	if component is GameboardTile:
		gameboard_tiles.remove_child(component)
	elif component is GameboardItem:
		gameboard_items.remove_child(component)
	else:
		push_error("Failed to remove component: ", component, " from gameboard as it is not type Tile or Item")

	
## Hitboxes
func get_hitboxes_at(point: Vector2) -> Array[Area2D]:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collision_mask = 0xFFFFFFFF
	query.collide_with_bodies = false
	query.collide_with_areas = true
	
	var intersections = get_world_2d().direct_space_state.intersect_point(query, 10) #10 is max number of hitboxes
	var hitboxes: Array[Area2D] = []
	
	for intersection in intersections:
		var collider = intersection["collider"]
		if collider is Area2D:
			hitboxes.append(collider)
			
	return hitboxes
	
func get_hitbox_owner(hitbox: Area2D) -> Variant:
	return hitbox.get_owner()
	

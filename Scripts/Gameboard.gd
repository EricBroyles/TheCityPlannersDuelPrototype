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
	





































## OLD SHIT

## Matrixes: {Vector2: [Tiles, Items], ...}
#var grid_centers: Dictionary = {} 
#var grid_edges: Dictionary = {}
#
#
###need way to create the empty versions
#
###need way to get specific types and groups of items
#
###need ways to add, and rmoeve, and check if certain items exists
#
###need way to continuously check and swap walkways, add curtains
#
###need way to upgrade items
#
### need way to add, remove, and replace
#
### add to the game matrix == add to the game world so this should also handle that, sam idea for remove and rplace
#
### need easy way to visulaize the data held here
#
#
#func init_grid_centers():
	#for r in GameData.gameboard_r:
		#for c in GameData.gameboard_c:
			#var center_tile_pos: Vector2 = round(Vector2(r * GameConstants.GAMEBOARD_TILE_SIZE + GameConstants.GAMEBOARD_TILE_SIZE/2.0, c * GameConstants.GAMEBOARD_TILE_SIZE + GameConstants.GAMEBOARD_TILE_SIZE/2.0))
			#grid_centers[center_tile_pos] = []
			#
#func init_grid_edges():
	#var half_size: float = GameConstants.GAMEBOARD_TILE_SIZE / 2.0
	#for r in GameData.gameboard_r:
		#for c in GameData.gameboard_c:
			#var tile_top_left_corner_pos: Vector2 = round(Vector2(r, c) * GameConstants.GAMEBOARD_TILE_SIZE)
			##there is no duplicates, the duplicates just override each other.
			#grid_edges[round(tile_top_left_corner_pos + Vector2(half_size, 0))] = []
			#grid_edges[round(tile_top_left_corner_pos + Vector2(GameConstants.GAMEBOARD_TILE_SIZE, half_size))] = []
			#grid_edges[round(tile_top_left_corner_pos + Vector2(half_size, GameConstants.GAMEBOARD_TILE_SIZE))] = []
			#grid_edges[round(tile_top_left_corner_pos + Vector2(0, half_size))] = []
#
#func make_gameboard() -> void:
	#var r: int = GameData.gameboard_r
	#var c: int = GameData.gameboard_c
	#var tile: Node2D
	#var tile_position: Vector2 = top_left_tile_position
	#
	#for i in range(r):
		#for j in range(c):
			#var type = (i + j) %2
			#tile = GameComponents.GROUND_TILE.instantiate() if type == 1 else GameComponents.LIGHT_GROUND_TILE.instantiate() 
			#tile.position = tile_position
			#gameboard_base_tiles.add_child(tile)
			#tile_position.x += GameConstants.GAMEBOARD_TILE_SIZE
			#
		#tile_position.x = top_left_tile_position.x
		#tile_position.y += GameConstants.GAMEBOARD_TILE_SIZE
	#
	#gameboard_base_tiles.position += tiles_shift
	#
	#
#func get_gameboard_size() -> Vector2:
	#return Vector2(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE, GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE) #(width, height)
	#
#func get_gameboard_center() -> Vector2:
	#return Vector2(int(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE / 2.0), int(GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE / 2.0))
#
## returns the c,r that the point is contained in
#func get_grid_index_at(point: Vector2) -> Vector2:
	#return round(point / GameConstants.GAMEBOARD_TILE_SIZE)
#
## index == (c,r)
#func get_grid_edges_at(index: Vector2) -> Array[Vector2]:
	#print("untested")
	#var tile_top_left_corner_pos: Vector2 = round(index * GameConstants.GAMEBOARD_TILE_SIZE)
	#return [
	#round(tile_top_left_corner_pos + Vector2(GameConstants.GAMEBOARD_TILE_SIZE / 2.0, 0)),
	#round(tile_top_left_corner_pos + Vector2(GameConstants.GAMEBOARD_TILE_SIZE, GameConstants.GAMEBOARD_TILE_SIZE / 2.0)),
	#round(tile_top_left_corner_pos + Vector2(GameConstants.GAMEBOARD_TILE_SIZE / 2.0, GameConstants.GAMEBOARD_TILE_SIZE)),
	#round(tile_top_left_corner_pos + Vector2(0, GameConstants.GAMEBOARD_TILE_SIZE / 2.0))
	#]
#
#
#func get_hitboxes_at(point: Vector2) -> Array[Area2D]:
	#var query = PhysicsPointQueryParameters2D.new()
	#query.position = point
	#query.collision_mask = 0xFFFFFFFF
	#query.collide_with_bodies = false
	#query.collide_with_areas = true
	#
	#var intersections = get_world_2d().direct_space_state.intersect_point(query, 10) #10 is max number of hitboxes
	#var hitboxes: Array[Area2D] = []
	#
	#for intersection in intersections:
		#var collider = intersection["collider"]
		#if collider is Area2D:
			#hitboxes.append(collider)
	#
	#return hitboxes
	#
#func get_hitbox_owner(hitbox: Area2D) -> Variant:
	#return hitbox.get_owner()
#
##given the center position of an object with its oriented size
##return the objects center position so the obj is snapped to the grid centers
#func snap_position_to_grid_centers(point: Vector2, size: Vector2) -> Vector2:
	#var top_left_position: Vector2 = point - size/2
	#var new_top_left_position: Vector2 = round(top_left_position / GameConstants.GAMEBOARD_TILE_SIZE) * GameConstants.GAMEBOARD_TILE_SIZE
	#var new_position: Vector2 = new_top_left_position + size/2
	#return round(new_position)
	#
	#
##given the center position of an object 
##return the objects center position so the obj is snapped to the grid edge
#func snap_position_to_grid_edges(point: Vector2) -> Vector2:
	#print("UNTESTED what if the item is a 1x2 issues")
	##convert position into index r,c
	#var index: Vector2 = get_grid_index_at(point)
	##then find all the edges at that r,c
	#var edges: Array[Vector2] = get_grid_edges_at(index)
	##then see which edge I am closest too, this will be the position returned
	#var closest_edge: Vector2 = GameHelper.get_closest_position(point, edges)
	#return closest_edge
#
## this pairs with get_snapped_position_to_grid_edges for the walkways, to help autorotate the walkway	
## given a single edge position that matches a edge in grid_edges
## return true if vertical, false if horizontal
#func is_grid_edge_vertical(edge: Vector2) -> bool:
	#print("untested Fuck me what if the edge is a 1x2")
	#if int(edge.x) % GameConstants.GAMEBOARD_TILE_SIZE == 0:
		#return true
	#return false
#
##returns the size converted to number of (c,r) it takes up
#func get_indexed_size(size: Vector2) -> Vector2:
	#return round(size / GameConstants.GAMEBOARD_TILE_SIZE)
#
##given the center positon and size of some object snapped to the grid_center
##return all the grid_centers that the object overlaps with, ie a 2x2 object would have 4 grid centers positions each corresponding to the 4 tiles it takes up
## these may go beyond the grid_centers matrix
#func get_obj_grid_centers(point: Vector2, size: Vector2) -> Array[Vector2]:
	#print("untested 11")
	##get the top left point
	#var top_left_pos: Vector2 = point - size / 2
	##convert size into c,r
	#var indexed_size: Vector2 = get_indexed_size(size) #(c,r)
	#print(size, indexed_size)
	#var obj_grid_centers: Array[Vector2] = []
	#for r in indexed_size.y:
		#for c in indexed_size.x:
			#var obj_grid_center: Vector2 = round(top_left_pos + Vector2(r,c) * GameConstants.GAMEBOARD_TILE_SIZE + Vector2(1,1) * GameConstants.GAMEBOARD_TILE_SIZE/2)
			#obj_grid_centers.append(obj_grid_center)
	#
	#print(obj_grid_centers)	
	#return obj_grid_centers
	#
##given the center positon and size of some object snapped to the grid_edge
##return all the grid_edges that the object overlaps with, ie a 2 edge walkway will return the 2 edges positions it takes up
#func get_obj_grid_edges(center_position: Vector2, top_center_position: Vector2) -> Array[Vector2]:
	#print("untested 11.5 what if the edge is 1x2")
	#
	#return []
#
##not really needed due to get_objs_at_grid_centers(tile_grid_centers)
#func is_obj_in_grid_centers_bounds(obj_grid_centers: Array[Vector2]) -> bool:
	#print("untested 10")
	#for grid_center in obj_grid_centers:
		#if not grid_centers.has(grid_center):
			#return false
	#return true 
###irrelecant for same reason above is irrelevant
#func is_obj_in_grid_edges_bounds(obj_grid_edges: Array[Vector2]) -> bool:
	#print("untested 9")
	#for grid_edge in obj_grid_edges:
		#if not grid_edges.has(grid_edge):
			#return false
	#return true 
	#
##returns an array of [] of all items at each grid_center, if the grid_center is out of bounds it is null
##[null, [objs,..], ...]
#func get_objs_at_grid_centers(some_grid_centers: Array[Vector2]) -> Array:
	#var all_objs: Array = []
	#for grid_center in some_grid_centers:
		#if grid_centers.has(grid_center):
			#all_objs.append(grid_centers[grid_center])
		#else:
			#all_objs.append(null)
			#
	#return all_objs
#
#func add_tile(tile: GameboardTile, point: Vector2):
	#tile.position = round(point) #self.position
	#gameboard_tiles.add_child(tile)
	#for grid_center in get_obj_grid_centers(point, tile.size):
		#grid_centers[grid_center].append(tile)
	#
#
#func remove_tile(tile: GameboardTile):
	#gameboard_tiles.remove_child(tile)
	#for grid_center in get_obj_grid_centers(tile.position, tile.size):
		#while grid_centers[grid_center].has(tile):
			#grid_centers[grid_center].erase(tile)
			#
	##tile.queue_free()


	

	

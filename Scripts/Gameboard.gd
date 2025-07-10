extends Node2D
class_name Gameboard

@onready var gameboard_base_tiles = $BaseTiles
@onready var gameboard_tiles = $Tiles
@onready var gameboard_items = $Items
@onready var gameboard_placer = $Placer

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
			
func get_gameboard_size() -> Vector2:
	return Vector2(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE, GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE) #(width, height)
	
func get_gameboard_center() -> Vector2:
	return Vector2(int(GameData.gameboard_c * GameConstants.GAMEBOARD_TILE_SIZE / 2.0), int(GameData.gameboard_r * GameConstants.GAMEBOARD_TILE_SIZE / 2.0))

func get_number_of_tiles() -> int:
	return gameboard_tiles.get_child_count()
	
func get_number_of_items() -> int:
	return gameboard_items.get_child_count()
	
func get_number_of_components() -> int:
	return get_number_of_tiles() + get_number_of_items()

func snap_to_boxes(requested_position: Vector2, component: GameboardComponent) -> Vector2:
	#assumes that components position pointer is at their center	
	#sets the position of the component to the proper location to keep it snaped to boxes
	return snap_size_to_boxes(requested_position, component.get_oriented_size())
	
func snap_size_to_boxes(requested_position: Vector2, size: Vector2) -> Vector2:
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

func get_components_main_body_is_overlapping(component: GameboardComponent) -> Array[GameboardComponent]:
	var components: Array[GameboardComponent] = []
	for area in component.get_main_body_hitbox().get_overlapping_areas():
		components.append(area.get_owner() as GameboardComponent) 
	return components

func get_hitboxes_at(point: Vector2) -> Array[Area2D]:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collision_mask = 0xFFFFFFFF #hits all masks
	query.collide_with_bodies = false
	query.collide_with_areas = true
	
	var intersections = get_world_2d().direct_space_state.intersect_point(query, 10) #10 is max number of hitboxes
	var hitboxes: Array[Area2D] = []
	
	for intersection in intersections:
		var collider = intersection["collider"]
		if collider is Area2D:
			hitboxes.append(collider)
			
	return hitboxes

func get_components_at(point: Vector2) -> Array[GameboardComponent]:
	var components: Array[GameboardComponent] = []
	for hitbox in get_hitboxes_at(point):
		components.append(hitbox.get_owner() as GameboardComponent)
	return components
	
func find_top_item_at(point: Vector2) -> GameboardItem:
	#this uses z index not elevation ---- keep in mind that sidewalk has a 51 z and crosswalk has like 50 z but the same elevation
	#this to help determine what has been selected. DO not use z index for determining item collisions use elevation
	var top_item: GameboardItem = null
	for comp in get_components_at(point):
		if comp is GameboardItem and (top_item == null or comp.z_index > top_item.z_index):
			top_item = comp as GameboardItem
	return top_item
		
func attempt_to_upgrade_item_at(point: Vector2) -> bool:
	#Attempting to UPGRADE the top most (in z) GameboardItem
	var item_to_upgrade: GameboardItem = find_top_item_at(point)
	if item_to_upgrade != null and item_to_upgrade.can_upgrade():
		item_to_upgrade.upgrade() #I am upgrading a GameboardItem that can upgrade and is at the top z idex of what I clicked on
		return true
	return false
	
func attempt_to_delete_item_at(point: Vector2) -> bool:
	#Attempting to DELETE the top most (in z) GameboardItem
	var item_to_delete: GameboardItem = find_top_item_at(point)
	if item_to_delete != null and item_to_delete.can_delete():
		delete_component(item_to_delete) #I am deleting a GameboardItem that can delete and is at the top z idex of what I clicked on
		return true
	return false

func add_component(component: GameboardComponent):
	#this is used inside of each GameboardComponent class when buying or zoning
	if component is GameboardTile:
		gameboard_tiles.add_child(component)
		print("!!!!!!!! ADDING")
		#await get_tree().physics_frame
		#await component.ready
	elif component is GameboardItem:
		gameboard_items.add_child(component)
		#await get_tree().physics_frame
		#await component.ready
	else:
		push_error("Failed to add component: ", component, " to gameboard as it is not type Tile or Item")

func delete_component(component: GameboardComponent):
	#this is what should be used to handle the removal of a component
	if component is GameboardTile:
		component.pre_delete_sequence()
		gameboard_tiles.remove_child(component)
		#await get_tree().physics_frame
		#await component.tree_exited
	elif component is GameboardItem:
		component.pre_delete_sequence()
		gameboard_items.remove_child(component)
		#await get_tree().physics_frame
		#await component.tree_exited
	else:
		push_error("Failed to remove component: ", component, " from gameboard as it is not type Tile or Item")

	

	



##assumes the item is snapped to boxes
## returns: {"boxes": Array[Box], "is_fully_contained": bool}
#func contained_by_boxes(component: GameboardComponent) -> Dictionary:
#
	#var component_inside_these_boxes: Array[Box] = []
	#var is_fully_contained: bool = true
	#
	#var size: Vector2 = component.get_oriented_size()
	#var size_in_tile_units: Vector2 = round(Vector2(size.y, size.x) / GameConstants.GAMEBOARD_TILE_SIZE) #(num rows, num cols)
	#var top_left_point: Vector2 = component.get_top_left_position()
	#var top_left_index: Vector2 = round(Vector2(top_left_point.y, top_left_point.x) / GameConstants.GAMEBOARD_TILE_SIZE)
	#
	#for r in range(size_in_tile_units.x):
		#for c in range(size_in_tile_units.y):
			#var component_section_index: Vector2 = top_left_index + Vector2(r, c) #this is like each tile of a component
			#if GameHelper.is_index_in_matrix(component_section_index, matrix):
				#component_inside_these_boxes.append(matrix[component_section_index.x][component_section_index.y])
			#else:
				#is_fully_contained = false
				#
	#var result: Dictionary = {
		#"boxes": component_inside_these_boxes,
		#"is_fully_contained": is_fully_contained
	#}
	#return result
	#
	#
#func get_box_at_position(pos: Vector2) -> Box:
	#var r: int = int(round((pos.y - GameConstants.GAMEBOARD_TILE_SIZE) / GameConstants.GAMEBOARD_TILE_SIZE))
	#var c: int = int(round((pos.x - GameConstants.GAMEBOARD_TILE_SIZE) / GameConstants.GAMEBOARD_TILE_SIZE))
	#print(r, " ", c)
	#if GameHelper.is_index_in_matrix(Vector2(r,c), matrix): return matrix[r][c]
	#return null
	#
##WARNING: due to the fact that I dont give a shit anymore this only works for 1 edge items
##assumes the item is snapped to edges
## returns: {"edges": Array[Vector2], "is_fully_contained": bool}
#func contained_by_edges(component: GameboardComponent) -> Dictionary:
	#print("component size", component.get_oriented_size())
	#var component_inside_these_edges: Array[Edge] = []
	#var component_inside_these_boxes: Array[Box] = []
	#var is_fully_contained: bool = true
	#
	#var read_boxes_at_pos: Array[Vector2] = [component.position - Vector2(component.get_oriented_size().x,0), component.position + Vector2(component.get_oriented_size().x,0)]
	#
	#for box_pos in read_boxes_at_pos:
		#var box = get_box_at_position(box_pos)
		#print("heya ", box)
		#if box != null:
			#component_inside_these_boxes.append(box)
			#var edge_result: Edge = box.get_edge_at_position(component.position)
			#if edge_result != null:
				#
				#component_inside_these_edges.append(edge_result)
	#
	#var unique_component_inside_these_edges: Array[Edge]
	#for edge in GameHelper.get_unique_array(component_inside_these_edges):
		#unique_component_inside_these_edges.append(edge as Edge)
	#is_fully_contained = true if len(unique_component_inside_these_edges) > 0 else false
	#
	#var result: Dictionary = {
		#"boxes": component_inside_these_boxes, #need this to check if I own the land
		#"edges": unique_component_inside_these_edges,
		#"is_fully_contained": is_fully_contained
	#}
	#return result
	#
#
#
#
#
#
	#
	#
	#
#
	#
	#
#func is_edge_vertical(edge_position: Vector2) -> bool:
	#if int(round(edge_position.x)) % GameConstants.GAMEBOARD_TILE_SIZE == 0: return true
	#return false
#
	#
	#
#
## given a component. be sure to set its position to reflect where you want it in game space
## look up its boxes (contained_by_boxes)
## return all the objects inside of the boxes that this componet is on.
#func get_components_in_shared_boxes(component: GameboardComponent) -> Array[GameboardComponent]:
	#var unique_dict := {}  # Keys will be the components, values don't matter
	#for box in contained_by_boxes(component)["boxes"]:
		#for comp in box.components:
			#unique_dict[comp] = true  # Add as key; duplicates will be overwritten
			#
	#var components_array: Array[GameboardComponent] = []
	#for comp in unique_dict.keys():
		#components_array.append(comp as GameboardComponent)  # Safe cast per element
	#return components_array
#
##get_components_in_shared_boxes
##func shares_edges_with(component: GameboardComponent) -> Array[GameboardComponent]:
	##return []
	#
#
### USE add_to_boxes and remove_from_boxes to add/remove items in general
#func add_to_boxes(component: GameboardComponent):
	##assumes component is snaped to boxes
	##this does not error handle. if you call this it will place it at all the boxes it is inside
	#var add_to_these_boxes: Array[Box] = contained_by_boxes(component)["boxes"]
	#for box in add_to_these_boxes:
		#box.add(component)
		#
	#_add_to_scene(component)
#
#func remove_from_boxes(component: GameboardComponent):
	#var remove_from_these_boxes: Array[Box] = contained_by_boxes(component)["boxes"]
	#for box in remove_from_these_boxes:
		#box.remove(component)
		#
	#_remove_from_scene(component)
	#
#func add_to_edges(component: GameboardComponent):
	#var add_to_these_edges: Array[Edge] = contained_by_edges(component)["edges"]
	#for edge in add_to_these_edges:
		#edge.add(component)
		#
	#_add_to_scene(component)
#
#func remove_from_edges(component: GameboardComponent):
	#var remove_from_these_edges: Array[Edge] = contained_by_edges(component)["edges"]
	#for edge in remove_from_these_edges:
		#edge.remove(component)
		#
	#_remove_from_scene(component)


	

## this does not work as it needs the mouse to be pointing at the matrix boxes, but when it goes out of bounds I would need to like create a new box with edges and this gets expensive and confusing
##box: this func does not handle out of bounds at all and sucks ass
#func get_box_at_position(pos: Vector2) -> Box:
	#var r: int = int(round((pos.y - GameConstants.GAMEBOARD_TILE_SIZE) / GameConstants.GAMEBOARD_TILE_SIZE))
	#var c: int = int(round((pos.x - GameConstants.GAMEBOARD_TILE_SIZE) / GameConstants.GAMEBOARD_TILE_SIZE))
	#return matrix[r][c]
##WARNING: I am only designing this for stuff that fits on 1 edge, may need to redesign for larger (due to the location of the center point for even 2 tile items)
#func snap_to_edges(requested_position: Vector2, component: GameboardComponent, auto_rotate: bool) -> Vector2:
	#
	#var pointing_at_box: Box = get_box_at_position(requested_position)
	#var closest_edge_pos: Vector2 = GameHelper.get_closest_position(requested_position, pointing_at_box.get_edge_positions())
	#
	#if auto_rotate:
		#if is_edge_vertical(closest_edge_pos):
			#if not component.is_vertical(): #check if the components is not already vertically aligned
				#component.rotate_90_cw()
		#else:
			#if component.is_vertical():
				#component.rotate_90_cw()
			#
	#return closest_edge_pos
	#
	#
	###this is the box position that the mouse is pointing at
	###ex. pointing at the top left most grid tile is 0,0 -> out of bounds is negetive stuff.
	##var req_box_top_left_pos = requested_position - Vector2(1,1) * GameConstants.GAMEBOARD_TILE_SIZE/2.0
	##var req_box_pos: Vector2 = round(req_box_top_left_pos / GameConstants.GAMEBOARD_TILE_SIZE) * GameConstants.GAMEBOARD_TILE_SIZE + Vector2(1,1) * GameConstants.GAMEBOARD_TILE_SIZE/2.0
	##
	###print(req_box_pos)
	##
	##var top_edge_center_pos: Vector2 = req_box_pos + Vector2(.5,0) * GameConstants.GAMEBOARD_TILE_SIZE
	##var bottom_edge_center_pos: Vector2 = top_edge_center_pos + Vector2(0,1) * GameConstants.GAMEBOARD_TILE_SIZE
	##var left_edge_center_pos: Vector2 = req_box_pos + Vector2(0,.5) * GameConstants.GAMEBOARD_TILE_SIZE
	##var right_edge_center_pos: Vector2 = left_edge_center_pos + Vector2(1,0) * GameConstants.GAMEBOARD_TILE_SIZE
	##
	##var closest_edge_pos: Vector2 = round(GameHelper.get_closest_position(requested_position, [top_edge_center_pos,bottom_edge_center_pos,left_edge_center_pos,right_edge_center_pos]))
	##
	##if is_edge_vertical(closest_edge_pos):
		##if not component.check_is_vertical(): #check if the components is not already vertically aligned
			##component.rotate_90_cw()
	##else:
		##if component.check_is_vertical():
			##component.rotate_90_cw()
			##
	##return closest_edge_pos
	

extends Node

func buy_demand(type: String, amount: int) -> int:
	# type: "r", "c", "i"
	# amount: int of number of demand units desired
	#this stays in helper as it is used by UI (it would get confusing to have it inside the class and i would have to create an instance inside the ui..)
	var cost_per_demand_unit: int
	match type:
		"r":
			cost_per_demand_unit = GameData.cost_per_r_demand
		"c":
			cost_per_demand_unit = GameData.cost_per_c_demand
		"i":
			cost_per_demand_unit = GameData.cost_per_i_demand
		_:
			push_error("Unknown buy_demand type: %s" % type)
			return 0

	var max_affordable_demand_units: int = int(GameData.points / float(cost_per_demand_unit))
	var amount_to_buy: int = min(amount, max_affordable_demand_units) #demand units to buy
	var points_cost: int = amount_to_buy * cost_per_demand_unit

	# Deduct and apply
	GameData.points -= points_cost
	match type:
		"r":
			GameData.r_demand += amount_to_buy
		"c":
			GameData.c_demand += amount_to_buy
		"i":
			GameData.i_demand += amount_to_buy

	return amount_to_buy

func is_owned_tile(obj: Variant) -> bool:
	#if it is zoned, then it must also be owned
	if obj is OwnedUnzoned or obj is RZone or obj is CZone or obj is IZone:
		return true
	return false

func is_zoned_tile(obj: Variant) -> bool:
	if obj is RZone or obj is CZone or obj is IZone:
		return true
	return false
	
func is_hitbox_overlapping_hitbox_in_group(hitbox: Area2D, group_name: String) -> bool:
	var is_overlapping: bool = false
	for overlap_area in hitbox.get_overlapping_areas():
		if overlap_area.is_in_group(group_name): is_overlapping = true; break;
	return is_overlapping
	
func is_comp1_fully_contained_by_comp2(comp1: GameboardComponent, comp2: GameboardComponent) -> bool:
	var size1 = comp1.get_oriented_size()
	var size2 = comp2.get_oriented_size()
	
	var rect1 = Rect2(comp1.position - size1 * 0.5, size1)
	var rect2 = Rect2(comp2.position - size2 * 0.5, size2)
	
	return rect2.encloses(rect1)
	
func get_closest_position(target_position: Vector2, positions: Array) -> Vector2:
	var closest_position: Vector2 = Vector2.INF
	var min_distance := INF
	
	for pos in positions:
		var distance = target_position.distance_to(pos)
		if distance < min_distance:
			min_distance = distance
			closest_position = pos
			
	return closest_position

func is_coord_in_matrix(coord: Vector2, matrix: Array[Array]) -> bool:
	var r := int(coord.x)
	var c := int(coord.y)
	
	#check row bounds
	if r < 0 or r >= matrix.size():
		return false
	
	#check col bounds
	if c < 0 or c >= matrix[r].size():
		return false
	
	return true
	
func rotate_vector_90_cw(vec: Vector2, times: int) -> Vector2:
	match times % 4:
		0:return vec
		1:return Vector2(-vec.y, vec.x)
		2:return Vector2(-vec.x, -vec.y)
		3:return Vector2(vec.y, -vec.x)
	return vec # fallback (should never reach here)
	
func convert_mph_to_px_per_sec(mph: float) -> float:
	return mph * 5280 * GameConstants.GAMEBOARD_TILE_SIZE / GameConstants.GAMEBOARD_TILE_SIZE_FT / 3600
	
func do_path_projections_collide(rad1: int, path_proj1: Array[Vector2], rad2: int, path_proj2: Array[Vector2]) -> bool:
	var min_dist := rad1 + rad2
	for p1 in path_proj1:
		for p2 in path_proj2:
			if p1.distance_to(p2) < min_dist:
				return true
	return false	
	

	
## Unused (may be useful later)
#func find_izone_in_tree(node: Node) -> bool:
	#if node is IZone:
		#print("Found IZone at path: ", node.get_path())
		#return true
	#for child in node.get_children():
		#if find_izone_in_tree(child):
			#return true
	#return false
	

	
	

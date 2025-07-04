extends Node

## When buying somthing, if not able to buy the full amount still buy the max amount allowed. return this amount bought

# type: "r", "c", "i"
# amount: int of number of demand units desired
#this stays in helper as it is used by UI (technically I could move it, i dont want to tho) (it would get confusing to have it inside the class and i would have to create an instance inside the ui..)
func buy_demand(type: String, amount: int) -> int:
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
	
	


#amount is number of tiles of land
#func buy_land(amount: int) -> int:
	#var amount_land_to_buy = min(amount, amount_land_tiles_can_buy())
	#var total_cost = amount_land_to_buy * GameData.cost_per_land_tile
#
	#GameData.money -= total_cost
#
	#return amount_land_to_buy

#this is used for when the player unzones land and then gets those demand units (this is not refunding the points purchase the player made to get the demand)
#tile: either a RZone, CZone, IZone tile
#func refund_demand_units(tile: GameboardTile, amount: int):
	#if tile is RZone:
		#GameData.r_demand += amount
	#elif tile is CZone:
		#GameData.c_demand += amount
	#elif tile is IZone:
		#GameData.i_demand += amount
	#elif tile is OwnedUnzoned:
		#return
	#else:
		#push_error("Did Not Refund ---- due to unknown refund demand tile : ", tile)





#if it is zoned, then it must also be owned
func is_owned_tile(obj: Variant) -> bool:
	if obj is OwnedUnzoned or obj is RZone or obj is CZone or obj is IZone:
		return true
	return false

func is_zoned_tile(obj: Variant) -> bool:
	if obj is RZone or obj is CZone or obj is IZone:
		return true
	return false
	
	
	
	

func get_closest_position(target_position: Vector2, positions: Array) -> Vector2:
	var closest_position: Vector2 = Vector2.INF
	var min_distance := INF
	
	for pos in positions:
		var distance = target_position.distance_to(pos)
		if distance < min_distance:
			min_distance = distance
			closest_position = pos
			
	return closest_position


func is_index_in_matrix(index: Vector2, matrix: Array[Array]) -> bool:
	var r := int(index.x)
	var c := int(index.y)
	
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
	
	
	
	
## Unused (may be useful later)
#func find_izone_in_tree(node: Node) -> bool:
	#if node is IZone:
		#print("Found IZone at path: ", node.get_path())
		#return true
	#for child in node.get_children():
		#if find_izone_in_tree(child):
			#return true
	#return false
	
	

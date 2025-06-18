extends Node

## When buying somthing, if not able to buy the full amount still buy the max amount allowed. return this amount bought

# type: "r", "c", "i"
# amount: int of number of demand units desired
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
	
	
func amount_land_tiles_can_buy() -> int:
	return int(GameData.money / float(GameData.cost_per_land_tile))

#amount is number of tiles of land
func buy_land(amount: int) -> int:
	var amount_land_to_buy = min(amount, amount_land_tiles_can_buy())
	var total_cost = amount_land_to_buy * GameData.cost_per_land_tile

	GameData.money -= total_cost

	return amount_land_to_buy

#this is used for when the player unzones land and then gets those demand units (this is not refunding the points purchase the player made to get the demand)
#tile: either a RZone, CZone, IZone tile
func refund_demand_units(tile: GameboardTile, amount: int):
	if tile is RZone:
		GameData.r_demand += amount
	elif tile is CZone:
		GameData.c_demand += amount
	elif tile is IZone:
		GameData.i_demand += amount
	elif tile is OwnedUnzoned:
		return
	else:
		push_error("Did Not Refund ---- due to unknown refund demand tile : ", tile)



#func is_unowned_unzoned_tile(obj: Variant) -> bool:
	#if obj is OwnedUnzoned or obj is RZone or obj is CZone or obj is IZone:
		#return false
	#return true

#if it is zoned, then it must also be owned
func is_owned_tile(obj: Variant) -> bool:
	if obj is OwnedUnzoned or obj is RZone or obj is CZone or obj is IZone:
		return true
	return false

func is_zoned_tile(obj: Variant) -> bool:
	if obj is RZone or obj is CZone or obj is IZone:
		return true
	return false
	
	

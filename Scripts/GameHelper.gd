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

	var max_affordable = GameData.points / cost_per_demand_unit
	var amount_to_buy = min(amount, max_affordable)
	var points_cost = amount_to_buy * cost_per_demand_unit

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
func buy_land(amount: int) -> int:
	var max_affordable = GameData.money / GameData.cost_per_land_tile
	var amount_to_buy = min(amount, max_affordable)
	var total_cost = amount_to_buy * GameData.cost_per_land_tile

	GameData.money -= total_cost

	return amount_to_buy
	

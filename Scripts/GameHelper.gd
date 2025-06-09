extends Node

func buy_demand(type: String, amount: int):
	var points_cost: float
	match type:
		"r":
			points_cost = amount * GameData.cost_per_r_demand
			if GameData.points >= points_cost:
				GameData.points -= points_cost
				GameData.r_demand += amount
		"c":
			points_cost = amount * GameData.cost_per_c_demand
			if GameData.points >= points_cost:
				GameData.points -= points_cost
				GameData.c_demand += amount
		"i":
			points_cost = amount * GameData.cost_per_i_demand
			if GameData.points >= points_cost:
				GameData.points -= points_cost
				GameData.i_demand += amount
		_:
			push_error("Unknown buy_demand type: %d" %type)

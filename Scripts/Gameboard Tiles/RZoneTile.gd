extends GameboardTile

class_name RZone

#only checks for a single tile
func can_buy() -> bool:
	if GameData.r_demand < 1: return false
	return true

#this buys a single tile with no error handling.
func buy():
	GameData.r_demand -= 1
	
#this refunds a single tile with no error handling.
func refund():
	GameData.r_demand += 1


# this pairs with batch_buy
func max_amount_can_buy() -> int:
	return GameData.r_demand
	
func batch_buy(amount: int):
	GameData.r_demand -= amount

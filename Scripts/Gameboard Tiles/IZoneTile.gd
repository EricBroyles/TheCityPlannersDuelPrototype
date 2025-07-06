extends GameboardTile

class_name IZone

#only checks for a single tile
func can_buy() -> bool:
	if GameData.i_demand < 1: return false
	return true

#this buys a single tile with no error handling.
func buy():
	GameData.i_demand -= 1
	
#this refunds a single tile with no error handling.
func refund():
	GameData.i_demand += 1


# this pairs with batch_buy
func max_amount_can_buy() -> int:
	return GameData.i_demand
	
func batch_buy(amount: int):
	GameData.i_demand -= amount

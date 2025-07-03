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


# FINISH if need to buy in batches
func max_amount_can_buy() -> int:
	return 0
	
func batch_buy(amount: int):
	pass

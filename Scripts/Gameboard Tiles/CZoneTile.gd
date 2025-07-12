extends GameboardTile
class_name CZone

func can_buy() -> bool:
	#only checks for a single tile
	if GameData.c_demand < 1: return false
	return true
	
func pre_delete_sequence():
	super()
	refund()

func buy():
	#this buys a single tile with no error handling.
	GameData.c_demand -= 1
	
#this refunds a single tile with no error handling.
func refund():
	GameData.c_demand += 1

func max_amount_can_buy() -> int:
	return GameData.c_demand
	
func batch_buy(amount: int):
	GameData.c_demand -= amount
	

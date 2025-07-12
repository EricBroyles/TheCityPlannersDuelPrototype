extends GameboardTile
class_name IZone

func can_buy() -> bool:
	#only checks for a single tile
	if GameData.i_demand < 1: return false
	return true
	
func pre_delete_sequence():
	super()
	refund()

func buy():
	#this buys a single tile with no error handling.
	GameData.i_demand -= 1
	
func refund():
	#this refunds a single tile with no error handling.
	GameData.i_demand += 1

func max_amount_can_buy() -> int:
	return GameData.i_demand
	
func batch_buy(amount: int):
	GameData.i_demand -= amount

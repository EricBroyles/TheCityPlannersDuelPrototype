extends GameboardTile
class_name RZone

@onready var main_body_hitbox = %MainBodyHitbox

func can_buy() -> bool:
	#only checks for a single tile
	if GameData.r_demand < 1: return false
	return true
	
func pre_delete_sequence():
	super()
	refund()
	
func buy():
	#this buys a single tile with no error handling.
	GameData.r_demand -= 1
	
func refund():
	#this refunds a single tile with no error handling.
	GameData.r_demand += 1

func max_amount_can_buy() -> int:
	return GameData.r_demand
	
func batch_buy(amount: int):
	GameData.r_demand -= amount

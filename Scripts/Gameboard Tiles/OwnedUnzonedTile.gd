extends GameboardTile

class_name OwnedUnzoned

#only checks for a single tile
func can_buy() -> bool:
	if GameData.money < GameData.cost_per_land_tile: return false
	return true

#this buys a single tile with no error handling.
func buy():
	GameData.money -= GameData.cost_per_land_tile

	
#this refunds a single tile with no error handling.
func refund():
	#you cannot refund purchased land (uf you decide to change this be sure to chage placer r,c,i so that it ignores the owned_unzoned tiles to refund)
	return


# FINISH if need to buy in batches
func max_amount_can_buy() -> int:
	return int(GameData.money / float(GameData.cost_per_land_tile))
	
func batch_buy(amount: int):
	GameData.money -= amount * GameData.cost_per_land_tile
	

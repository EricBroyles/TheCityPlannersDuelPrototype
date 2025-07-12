extends GameboardTile
class_name OwnedUnzoned

static func create() -> OwnedUnzoned:
	return GameComponents.OWNED_UNZONED_TILE.instantiate()
	
func clone() -> OwnedUnzoned:
	var new_tile: OwnedUnzoned = OwnedUnzoned.create()
	new_tile.set_properties_from(self)
	return new_tile

func attempt_to_buy_land(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false 
	if not gameboard.is_fully_in_bounds(self): return false
	for tile in gameboard.get_tiles_overlapping_with(self):
		if GameHelper.is_owned_tile(tile): return false
	var new_tile: OwnedUnzoned = self.clone()
	gameboard.add_component(new_tile)
	new_tile.buy()
	return true
	
func attempt_to_unzone(gameboard: Gameboard) -> bool:
	if not gameboard.is_fully_in_bounds(self): return false
	for tile in gameboard.get_tiles_overlapping_with(self):
		if GameHelper.is_zoned_tile(tile):
			gameboard.delete_component(tile) #this handles the refund as it calls pre_delete_sequence
			var new_tile: OwnedUnzoned = self.clone()
			gameboard.add_component(new_tile)
			return true
	return false
	
func can_buy() -> bool:
	#only checks for a single tile
	if GameData.money < GameData.cost_per_land_tile: return false
	return true
	
func pre_delete_sequence():
	super()
	refund()

func buy():
	#this buys a single tile with no error handling.
	GameData.money -= GameData.cost_per_land_tile

func refund():
	#you cannot refund purchased land (uf you decide to change this be sure to chage placer r,c,i so that it ignores the owned_unzoned tiles to refund)
	return

func max_amount_can_buy() -> int:
	return int(GameData.money / float(GameData.cost_per_land_tile))
	
func batch_buy(amount: int):
	GameData.money -= amount * GameData.cost_per_land_tile
	

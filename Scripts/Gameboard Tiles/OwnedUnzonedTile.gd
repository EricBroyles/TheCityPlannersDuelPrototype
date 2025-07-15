extends GameboardTile
class_name OwnedUnzoned

var do_refund: bool = true #this is unique to OwnedUnzoned. When zoning set do_refund to false. When undoing buy_land let it be true to get the refund

static func create() -> OwnedUnzoned:
	return GameComponents.OWNED_UNZONED_TILE.instantiate()
	
func clone() -> OwnedUnzoned:
	var new_tile: OwnedUnzoned = OwnedUnzoned.create()
	new_tile._set_properties_from(self)
	return new_tile
	
func delete(from_gameboard: Gameboard):
	if do_refund: refund()
	from_gameboard.delete_component(self)

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
			tile.delete(gameboard) 
			var new_tile: OwnedUnzoned = self.clone()
			gameboard.add_component(new_tile)
			return true
	return false
	
func get_class_name() -> String:
	return "OwnedUnzoned"
	
func can_buy() -> bool:
	if GameData.money < GameData.cost_per_land_tile: return false
	return true
	
func max_amount_can_buy() -> int:
	return int(GameData.money / float(GameData.cost_per_land_tile))
	
func buy():
	GameData.money -= GameData.cost_per_land_tile
	
func batch_buy(amount: int):
	GameData.money -= amount * GameData.cost_per_land_tile

func refund():
	GameData.money += GameData.cost_per_land_tile
	


	

extends GameboardTile
class_name IZone

static func create() -> IZone:
	return GameComponents.I_ZONE_TILE.instantiate()
	
func clone() -> IZone:
	var new_tile: IZone = IZone.create()
	new_tile.set_properties_from(self)
	return new_tile
	
func attempt_to_zone(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if not gameboard.is_fully_in_bounds(self): return false
	for tile in gameboard.get_tiles_overlapping_with(self):
		if GameHelper.is_owned_tile(tile) and not tile is IZone:
			if tile is OwnedUnzoned: (tile as OwnedUnzoned).do_refund = false
			gameboard.delete_component(tile) #this handles the refund as it calls pre_delete_sequence
			var new_tile: IZone = self.clone()
			gameboard.add_component(new_tile)
			new_tile.buy()
			return true
	return false

func can_buy() -> bool:
	if GameData.i_demand < 1: return false
	return true
	
func max_amount_can_buy() -> int:
	return GameData.i_demand
	
func buy():
	GameData.i_demand -= 1
	
func batch_buy(amount: int):
	GameData.i_demand -= amount
	
func pre_delete_sequence():
	super()
	refund()
	
func refund():
	GameData.i_demand += 1

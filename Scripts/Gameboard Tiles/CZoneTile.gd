extends GameboardTile
class_name CZone

static func create() -> CZone:
	return GameComponents.C_ZONE_TILE.instantiate()
	
func clone() -> CZone:
	var new_tile: CZone = CZone.create()
	new_tile.set_properties_from(self)
	return new_tile
	
func attempt_to_zone(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if not gameboard.is_fully_in_bounds(self): return false
	for tile in gameboard.get_tiles_overlapping_with(self):
		if GameHelper.is_owned_tile(tile) and not tile is CZone:
			if tile is OwnedUnzoned: (tile as OwnedUnzoned).do_refund = false
			gameboard.delete_component(tile) #this handles the refund as it calls pre_delete_sequence
			var new_tile: CZone = self.clone()
			gameboard.add_component(new_tile)
			new_tile.buy()
			return true
	return false

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
	

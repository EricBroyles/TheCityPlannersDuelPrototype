extends GameboardTile
class_name RZone

static func create() -> RZone:
	return GameComponents.R_ZONE_TILE.instantiate()
	
func clone() -> RZone:
	var new_tile: RZone = RZone.create()
	new_tile.set_properties_from(self)
	return new_tile
	
func attempt_to_zone(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if not gameboard.is_fully_in_bounds(self): return false
	for tile in gameboard.get_tiles_overlapping_with(self):
		if GameHelper.is_owned_tile(tile) and not tile is RZone:
			if tile is OwnedUnzoned: (tile as OwnedUnzoned).do_refund = false
			gameboard.delete_component(tile) #this handles the refund as it calls pre_delete_sequence
			var new_tile: RZone = self.clone()
			gameboard.add_component(new_tile)
			new_tile.buy()
			return true
	return false

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

extends GameboardTile
class_name RZone

static func create() -> RZone:
	return GameComponents.R_ZONE_TILE.instantiate()
	
func clone() -> RZone:
	var new_tile: RZone = RZone.create()
	new_tile._set_properties_from(self)
	return new_tile
	
func delete(from_gameboard: Gameboard):
	refund()
	from_gameboard.delete_component(self)
	
func attempt_to_zone(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if not gameboard.is_fully_in_bounds(self): return false
	for tile in gameboard.get_tiles_overlapping_with(self):
		if GameHelper.is_owned_tile(tile) and not tile is RZone:
			if tile is OwnedUnzoned: (tile as OwnedUnzoned).do_refund = false
			tile.delete(gameboard) 
			var new_tile: RZone = self.clone()
			gameboard.add_component(new_tile)
			new_tile.buy()
			return true
	return false

func get_class_name() -> String:
	return "RZone"

func can_buy() -> bool:
	if GameData.r_demand < 1: return false
	return true
	
func max_amount_can_buy() -> int:
	return GameData.r_demand
	
func buy():
	GameData.r_demand -= 1
	
func batch_buy(amount: int):
	GameData.r_demand -= amount
	
func refund():
	GameData.r_demand += 1

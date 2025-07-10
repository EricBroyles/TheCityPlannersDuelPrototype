extends GameboardTile
class_name OwnedUnzoned

@onready var main_body_hitbox = %MainBodyHitbox

func attempt_to_buy_land(gameboard: Gameboard) -> bool:
	print("attempting to buy land ", gameboard.get_number_of_tiles())
	if not self.can_buy(): print("a"); return false 
	if not gameboard.is_fully_in_bounds(self): print("b"); return false
	await get_tree().process_frame
	for comp in gameboard.get_components_main_body_is_overlapping(self):
		if GameHelper.is_owned_tile(comp): print("c"); return false #I already own this tile
		
	var new_tile: OwnedUnzoned = GameComponents.OWNED_UNZONED_TILE.instantiate()
	new_tile.set_properties_from(self) #full duplicate of self
	print("@@@@@@@@@ ADDING")
	gameboard.add_component(new_tile)
	print("--------- ADDING")
	new_tile.buy()
	return true
	
func attempt_to_unzone(gameboard: Gameboard) -> bool:
	if not gameboard.is_fully_in_bounds(self): return false
	for comp in gameboard.get_components_main_body_is_overlapping(self):
		if GameHelper.is_zoned_tile(comp): 
			gameboard.delete_component(comp) #delete the zoned tile (this handles the refund as it calls pre_delete_sequence)
			
			var new_tile: OwnedUnzoned = GameComponents.OWNED_UNZONED_TILE.instantiate() 
			new_tile.set_properties_from(self) #full duplicate of self
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
	

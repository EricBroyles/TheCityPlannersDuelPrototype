extends GameboardItem

class_name Walkway

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20

var speed: float = 40; #mph

func _init() -> void:
	self.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE #the size to begin with
	self.elevation = 0 #Elevation: 0 base, .5 (halfway), 1 (up a level)
	self.level = 0 #Levels: 0 means that it does not have levels, otherwise starts at level 1
	self.max_level = 0

func _ready():
	z_index = ITEM_Z
	


#it is assumed that this is called on an instantiated version and then it will be added to the scene
func set_properties_from(other: GameboardItem):
	super(other)
	
	### I NEED TO SET THE TYPE OF WALKWAY HERE sidewlak or crosswalk

func get_money_buy_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_PER_ROAD_2_LANE
	
	return int(money_cost)

#to be charged once a turn
func get_money_upkeep_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN
	 
	return int(money_cost)
	
func get_money_delete_cost() -> int:
	return int(get_money_buy_cost() * .1)
	
func can_delete() -> bool:
	if GameData.money >= get_money_delete_cost(): return true
	return false
	
func delete_from(gameboard: Gameboard):
	super(gameboard)
	GameData.money -= get_money_delete_cost()

	
	
func can_buy() -> bool:
	if GameData.money < get_money_buy_cost(): return false
	return true

func buy():
	GameData.money -= get_money_buy_cost()
	
func refund():
	GameData.money += get_money_buy_cost()
	
# this pairs with batch_buy
func max_amount_can_buy() -> int:
	return int(GameData.money / float(get_money_buy_cost()))
	
func batch_buy(amount: int):
	GameData.money -= amount * get_money_buy_cost()
	
	

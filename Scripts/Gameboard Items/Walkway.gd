extends GameboardItem
class_name Walkway

## Walkway Use
#  Create
#   1. Create an Instance
#   2. Call setup with the crosswalk or not
#   3. Now add it to the scene this calls _ready which sets what crosswalk or sidewalk is visible
#  Duplicate
#   0. Have an old_instance to copy from
#   1. Create an Instance
#   2. (optional step: this get override so dont do this) Call setup with the crosswalk or not
#   3. Call set_properties_from(old_instance), this calls setup for the Instance
#   3. Now add it to the scene this calls _ready which sets what crosswalk or sidewalk is visible

@onready var sidewalk = %Sidewalk
@onready var crosswalk = %Crosswalk

enum SETUP {
	SIDEWALK,
	CROSSWALK,
}

const SIZE_IN_PIXELS: Vector2 = Vector2(16,200) #(x,y), notice how its texture is actually larger than this
const EDGE_LENGTH_IN_TILES: int = 1 #this item occupies one edge, notice how the item has some overlap. This is used for snap to edges to dictate how it should snap
const SIDEWALK_Z: int = 51
const CROSSWALK_Z: int = 50

var speed: float = 3; #mph

var is_crosswalk: bool #if it is not a crosswalk then it must be a sidewalk

#type specifies Crosswalk or Sidewalk
func setup(type: int) -> void:
	self.size = SIZE_IN_PIXELS #the size to begin with
	self.elevation = 0 #Elevation: 0 base, .5 (halfway), 1 (up a level)
	self.level = 0 #Levels: 0 means that it does not have levels, otherwise starts at level 1
	self.max_level = 0
	self.contained_by = Edge.new() #the item is contained inside boxes
	
	is_crosswalk = true if type == SETUP.CROSSWALK else false
	
func set_properties_from(other: GameboardItem):
	super(other) #this sets key info like position and orientation
	var type: int = SETUP.CROSSWALK if other.is_crosswalk else SETUP.SIDEWALK
	setup(type)

func _ready():
	config_walkway()
	
func config_walkway():
	if is_crosswalk: 
		z_index = CROSSWALK_Z
	else: 
		z_index = SIDEWALK_Z
	crosswalk.visible = is_crosswalk
	sidewalk.visible = !is_crosswalk
	
func check_is_vertical():
	if abs(self.orientation["x_dir"]) == Vector2(0,1): return false #if the x direction is in the y then it is vertical for this item
	return true
	
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
	
func max_amount_can_buy() -> int:
	# this pairs with batch_buy
	return int(GameData.money / float(get_money_buy_cost()))
	
func batch_buy(amount: int):
	GameData.money -= amount * get_money_buy_cost()
	
	

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
@onready var crosswalk_hitbox = %CrosswalkHitbox

enum SETUP {
	SIDEWALK,
	CROSSWALK,
}

const SIZE_IN_PIXELS: Vector2 = Vector2(16,200) #(x,y), notice how its texture is actually larger than this
const GRID_SIZE_IN_TILES: Vector2 = Vector2(2,1) #used for snap to grid
const SIDEWALK_Z: int = 51 #slightly higher so that sidewalk is always layered ontop of crosswalk
const CROSSWALK_Z: int = 50

var speed: float = 3; #mph

var is_crosswalk: bool #if it is not a crosswalk then it must be a sidewalk

func setup(type: int) -> void:
	self.size = SIZE_IN_PIXELS 
	self.elevation = 0 
	self.level = 0 
	self.max_level = 0
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

func is_colliding_with_overlapping_item(item: GameboardItem) -> bool:
	if shares_elevation_with(item) and GameHelper.is_item1_fully_contained_by_item2(self, item): return true
	return false

func get_oriented_grid_size() -> Vector2:
	#this is used to place this item onto the snapped grid
	if abs(orientation["x_dir"]) == Vector2(0,1):
		return Vector2(GRID_SIZE_IN_TILES.y, GRID_SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE
	return GRID_SIZE_IN_TILES * GameConstants.GAMEBOARD_TILE_SIZE

func is_vertical():
	if abs(self.orientation["x_dir"]) == Vector2(0,1): return false #if the x direction is in the y then it is vertical for this item
	return true
	
func get_money_buy_cost() -> int:
	var money_cost: float = GameConstants.MONEY_PER_WALKWAY
	return int(money_cost)

func get_money_upkeep_cost() -> int:
	#to be charged once a turn
	var money_cost: float = .01 * GameConstants.MONEY_PER_WALKWAY
	return int(money_cost)
	
func get_money_delete_cost() -> int:
	return int(get_money_buy_cost() * .1)
	
func can_delete() -> bool:
	if GameData.money >= get_money_delete_cost(): return true
	return false
	
func pre_delete_sequence():
	super()
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
	
func _on_crosswalk_hitbox_area_entered(_area: Area2D) -> void:
	#I will be entered by other crosswalks (the ones that are monitorable trigger this)
	setup(SETUP.CROSSWALK) #set it to a crosswalk
	config_walkway()

func _on_crosswalk_hitbox_area_exited(_area: Area2D) -> void:
	#I need to check that I still do am not overlapping another monitorable crosswalk area
	#if so then set it to a sidewalk
	if crosswalk_hitbox.get_overlapping_areas().is_empty():
		setup(SETUP.SIDEWALK)
	else:
		setup(SETUP.CROSSWALK) #I am still overlapping a crosswalk
	config_walkway()
	

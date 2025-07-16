extends GameboardItem
class_name Walkway

@onready var sidewalk = %Sidewalk
@onready var crosswalk = %Crosswalk
@onready var crosswalk_hitbox = %CrosswalkHitbox

enum SETUP {SIDEWALK, CROSSWALK}

const SIZE_IN_PIXELS: Vector2 = Vector2(16,200) #(x,y), its texture is actually larger than this
const GRID_SIZE_IN_TILES: Vector2 = Vector2(2,1) #used for snap to grid
const SIDEWALK_Z: int = 51 #sidewalk is always layered ontop of crosswalk
const CROSSWALK_Z: int = 50

var speed: float = 3; #mph
var is_crosswalk: bool

static func create(type: int) -> Walkway:
	var walkway: Walkway = GameComponents.WALKWAY.instantiate()
	walkway._setup(type)
	return walkway
	
func clone() -> Walkway:
	var new_walkway: Walkway = Walkway.create(SETUP.SIDEWALK) 
	new_walkway._set_properties_from(self)
	return new_walkway
	
func delete(from_gameboard: Gameboard):
	GameData.money -= get_money_delete_cost()
	super(from_gameboard)
	
func attempt_to_place(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if gameboard.is_fully_out_of_bounds(self): return false
	if not gameboard.is_land_partially_owned(self) : return false
	if not gameboard.get_items_colliding_with(self).is_empty(): return false
	var new_walkway: Walkway = self.clone()
	gameboard.add_component(new_walkway)
	new_walkway.buy()
	return true

func _setup(type: int) -> void:
	self.size = SIZE_IN_PIXELS 
	self.elevation = 0 
	self.level = 0 
	self.max_level = 0
	is_crosswalk = true if type == SETUP.CROSSWALK else false
	
func _set_properties_from(other: GameboardItem):
	super(other) #this sets key info like position and orientation
	var type: int = SETUP.CROSSWALK if other.is_crosswalk else SETUP.SIDEWALK
	_setup(type)

func _ready():
	config_walkway()
	
func _on_crosswalk_hitbox_area_entered(_area: Area2D) -> void:
	#I will be entered by other monitorable crosswalks
	turn_into_crosswalk()

func _on_crosswalk_hitbox_area_exited(_area: Area2D) -> void:
	#check that I am not overlapping another monitorable crosswalk area
	if crosswalk_hitbox.get_overlapping_areas().is_empty():
		turn_into_sidewalk()
	else: #I am still overlapping a crosswalk
		turn_into_crosswalk()
		
func get_class_name() -> String:
	return "Walkway"
	
func turn_into_crosswalk():
	_setup(SETUP.CROSSWALK) 
	config_walkway()
	
func turn_into_sidewalk():
	_setup(SETUP.SIDEWALK) 
	config_walkway()
	
func config_walkway():
	if is_crosswalk: 
		z_index = CROSSWALK_Z
	else: 
		z_index = SIDEWALK_Z
	crosswalk.visible = is_crosswalk
	sidewalk.visible = !is_crosswalk

func is_colliding_with_overlapping_item(item: GameboardItem) -> bool:
	if shares_elevation_with(item) and GameHelper.is_comp1_fully_contained_by_comp2(self, item): return true
	return false

func get_oriented_grid_size() -> Vector2:
	#this is used to place this item onto the snapped grid
	if abs(x_dir) == GameConstants.Y_DIR:
		return Vector2(GRID_SIZE_IN_TILES.y, GRID_SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE
	return GRID_SIZE_IN_TILES * GameConstants.GAMEBOARD_TILE_SIZE

func is_vertical():
	if abs(x_dir) == GameConstants.Y_DIR: return false 
	return true
	
func get_money_buy_cost() -> int:
	var money_cost: float = GameConstants.MONEY_PER_WALKWAY
	return int(money_cost)

func get_money_upkeep_cost() -> int:
	var money_cost: float = .01 * GameConstants.MONEY_PER_WALKWAY
	return int(money_cost)
	
func get_money_delete_cost() -> int:
	return int(get_money_buy_cost() * .1)
	
func can_delete() -> bool:
	if GameData.money >= get_money_delete_cost(): return true
	return false

func can_buy() -> bool:
	if GameData.money < get_money_buy_cost(): return false
	return true
	
func max_amount_can_buy() -> int:
	return int(GameData.money / float(get_money_buy_cost()))

func buy():
	GameData.money -= get_money_buy_cost()
	
func batch_buy(amount: int):
	GameData.money -= amount * get_money_buy_cost()
	
func refund():
	GameData.money += get_money_buy_cost()
	

	

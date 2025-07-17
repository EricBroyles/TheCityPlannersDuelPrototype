extends GameboardItem
class_name ParkingLot2x2

@onready var curtain_2_lane = %Curtain2Lane
@onready var curtain_4_lane = %Curtain4Lane

const SIZE_IN_TILES: Vector2 = Vector2(2,2) #(r,c)
const ITEM_Z: int = 20

static func create() -> ParkingLot2x2:
	var lot: ParkingLot2x2 = GameComponents.PARKING_LOT_2X2.instantiate()
	lot._setup()
	return lot
	
func clone() -> ParkingLot2x2:
	var new_lot: ParkingLot2x2 = ParkingLot2x2.create() 
	new_lot._set_properties_from(self)
	return new_lot
	
func delete(from_gameboard: Gameboard):
	GameData.money -= get_money_delete_cost()
	super(from_gameboard)
	
func attempt_to_place(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if not gameboard.is_fully_in_bounds(self): return false
	if not gameboard.is_land_fully_owned(self): return false
	if not gameboard.get_items_colliding_with(self).is_empty(): return false
	var new_lot: ParkingLot2x2 = self.clone()
	gameboard.add_component(new_lot)
	new_lot.buy()
	return true

func _setup() -> void:
	self.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE 
	self.elevation = 0 
	self.level = 0 
	self.max_level = 0
	
func _set_properties_from(other: GameboardItem):
	super(other) #position and orientation
	_setup()
	
func _ready():
	z_index = ITEM_Z
	
func get_class_name() -> String:
	return "ParkingLot2x2"

func _on_cutain_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_cutain_hitbox_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
	
func get_money_buy_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_PER_ROAD_2_LANE
	return int(money_cost)

func get_money_upkeep_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN
	return int(money_cost)
	
func get_money_delete_cost() -> int:
	return int(get_money_buy_cost() * .1)
	
func can_delete() -> bool:
	if GameData.money >= get_money_delete_cost(): return true
	return false

func can_buy() -> bool:
	if GameData.money < get_money_buy_cost(): return false
	return true

func buy():
	GameData.money -= get_money_buy_cost()
	
func max_amount_can_buy() -> int:
	return int(GameData.money / float(get_money_buy_cost()))
	
func batch_buy(amount: int):
	GameData.money -= amount * get_money_buy_cost()
	
func refund():
	GameData.money += get_money_buy_cost()

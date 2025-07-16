extends GameboardItem
class_name Road4Lane

@onready var left_parking = %LeftParking
@onready var right_parking = %RightParking
@onready var left_curtain_hitbox = %LeftCurtainHitbox 
@onready var right_curtain_hitbox = %RightCurtainHitbox

enum SETUP {PARKING,NO_PARKING}

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20
const MAX_PARKING_SPOTS: int = 4

var speed: float = 40; #mph

var is_parking: bool
var left_parking_active: bool
var right_parking_active: bool

static func create(type: int) -> Road4Lane:
	var road: Road4Lane = GameComponents.ROAD_4_LANE.instantiate()
	road._setup(type)
	return road
	
func clone() -> Road4Lane:
	var new_road: Road4Lane = Road4Lane.create(SETUP.NO_PARKING) 
	new_road._set_properties_from(self)
	return new_road
	
func delete(from_gameboard: Gameboard):
	GameData.money -= get_money_delete_cost()
	super(from_gameboard)
	
func attempt_to_place(gameboard: Gameboard) -> bool:
	if not self.can_buy(): return false
	if not gameboard.is_fully_in_bounds(self): return false
	if not gameboard.is_land_fully_owned(self) : return false 
	if not gameboard.get_items_colliding_with(self).is_empty(): return false
	var new_road: Road4Lane = self.clone()
	gameboard.add_component(new_road)
	new_road.buy()
	return true

func _setup(parking_status: int) -> void:
	self.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE 
	self.elevation = 0 
	self.level = 0 
	self.max_level = 0
	is_parking = true if parking_status == SETUP.PARKING else false
	
func _set_properties_from(other: GameboardItem):
	super(other) #this sets key info like position and orientation
	var parking_status: int = SETUP.PARKING if other.is_parking else SETUP.NO_PARKING
	_setup(parking_status)
	
func _ready():
	z_index = ITEM_Z
	config_parking() 
	
func get_class_name() -> String:
	return "Road4Lane"

func config_parking():
	#I always need the left/right curtain hitboxes to be !!monitorable!! so curtains from parking lots can detect and decide what type of curtain (monitorable = true in editor)
	#if no parking then I dont need to be !!monitoring!! for a curtain hitbox as there are no parking that would need to be removed.
	if is_parking:
		left_curtain_hitbox.monitoring = true
		right_curtain_hitbox.monitoring = true
	else:
		left_curtain_hitbox.monitoring = false
		right_curtain_hitbox.monitoring = false
		
	left_parking_active = is_parking
	right_parking_active = is_parking

	left_parking.visible = left_parking_active
	right_parking.visible = right_parking_active

func _on_left_curtain_hitbox_area_entered(area: Area2D) -> void:
	#the area will be from the layer curtains which has two groups actual_curtains and curtain_detectors
	#I want to detect when a acutal curtain has collided with this so I can close the parking on this side
	if is_parking and area.is_in_group("actual_curtains"):
		left_parking_active = false
		left_parking.visible = left_parking_active
	
func _on_left_curtain_hitbox_area_exited(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		left_parking_active = true
		left_parking.visible = left_parking_active

func _on_right_curtain_hitbox_area_entered(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		right_parking_active = false
		right_parking.visible = right_parking_active
	
func _on_right_curtain_hitbox_area_exited(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		right_parking_active = true
		right_parking.visible = right_parking_active

func get_amount_of_active_parking_spots() -> int:
	var amount: int = 0
	if left_parking_active: amount += 2
	if right_parking_active: amount += 2
	return amount

func get_money_buy_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_PER_ROAD_2_LANE
	if is_parking: money_cost += GameConstants.MONEY_PER_PARKING_SPOT * MAX_PARKING_SPOTS #yes just overcharge them I am not going to handle refunding parking spots as they change
	return int(money_cost)

func get_money_upkeep_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN
	if is_parking: money_cost += GameConstants.MONEY_TO_UPKEEP_PARKING_SPOT_PER_TURN * get_amount_of_active_parking_spots() 
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
	

	

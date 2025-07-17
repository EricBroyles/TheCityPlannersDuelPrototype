extends GameboardItem
class_name Road4Lane

@onready var left_parking = %LeftParking
@onready var right_parking = %RightParking
@onready var left_curtain_hitbox = %LeftCurtainHitbox 
@onready var right_curtain_hitbox = %RightCurtainHitbox
@onready var top_left_parking_spot = %TopLeftParkingSpot

enum SETUP {PARKING,NO_PARKING}

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20

var cars_per_spot: int = 1
var speed: float = 40; #mph

var is_parking: bool
var left_parking_obj: Parking = Parking.create_empty()
var right_parking_obj: Parking = Parking.create_empty()

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
	if not gameboard.is_land_fully_owned(self): return false

	var change_existing_road_to_parking: bool = false
	for colliding_item in gameboard.get_items_colliding_with(self):
		if colliding_item is Road4Lane and colliding_item.is_parking != self.is_parking and GameHelper.is_comp1_fully_contained_by_comp2(self, colliding_item):
			(colliding_item as Road4Lane).is_parking = self.is_parking
			(colliding_item as Road4Lane).config_parking()
			change_existing_road_to_parking = true; 
		else: return false
	if change_existing_road_to_parking: return true
	
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
	super(other) #position and orientation
	var parking_status: int = SETUP.PARKING if other.is_parking else SETUP.NO_PARKING
	_setup(parking_status)
	
func _ready():
	z_index = ITEM_Z
	config_parking() 
	
func get_class_name() -> String:
	return "Road4Lane"
	
func get_left_parking_spots() -> Array[Vector3]:
	var s1: Vector3 = Vector3(top_left_parking_spot.position.x, top_left_parking_spot.position.y, top_left_parking_spot.rotation_degrees)
	var s2: Vector3 = Vector3(top_left_parking_spot.position.x, -top_left_parking_spot.position.y, top_left_parking_spot.rotation_degrees)
	return [s1, s2]
	
func get_right_parking_spots() -> Array[Vector3]:
	var s1: Vector3 = Vector3(-top_left_parking_spot.position.x, top_left_parking_spot.position.y, 0)
	var s2: Vector3 = Vector3(-top_left_parking_spot.position.x, -top_left_parking_spot.position.y, 0)
	return [s1, s2]

func config_parking():
	if is_parking:
		left_curtain_hitbox.monitoring = true
		right_curtain_hitbox.monitoring = true
		
		if left_parking_obj.is_empty():
			left_parking_obj = Parking.create(get_left_parking_spots(), cars_per_spot)
		elif left_parking_obj.cars_per_spot != cars_per_spot:
			left_parking_obj.change_cars_per_spot(cars_per_spot)
		if right_parking_obj.is_empty():
			right_parking_obj = Parking.create(get_right_parking_spots(), cars_per_spot)
		elif right_parking_obj.cars_per_spot != cars_per_spot:
			right_parking_obj.change_cars_per_spot(cars_per_spot)
		
	else:
		left_curtain_hitbox.monitoring = false
		right_curtain_hitbox.monitoring = false

	left_parking.visible = is_parking
	right_parking.visible = is_parking

func _on_left_curtain_hitbox_area_entered(area: Area2D) -> void:
	#the area will be from the layer curtains which has two groups actual_curtains and curtain_detectors
	#I want to detect when a acutal curtain has collided with this so I can close the parking on this side
	if is_parking and area.is_in_group("actual_curtains"):
		left_parking.visible = false
		left_parking_obj.empty_contents()
	
func _on_left_curtain_hitbox_area_exited(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		left_parking.visible = true
		left_parking_obj = Parking.create(get_left_parking_spots(), cars_per_spot)

func _on_right_curtain_hitbox_area_entered(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		right_parking.visible = false
		right_parking_obj.empty_contents()
	
func _on_right_curtain_hitbox_area_exited(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		right_parking.visible = true
		right_parking_obj = Parking.create(get_right_parking_spots(), cars_per_spot)

func get_money_buy_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_PER_ROAD_2_LANE
	if is_parking: money_cost += GameConstants.MONEY_PER_PARKING_SPOT * (left_parking_obj.count_total_car_spaces() + right_parking_obj.count_total_car_spaces())
	return int(money_cost)

func get_money_upkeep_cost() -> int:
	var money_cost: float = 2.1 * GameConstants.MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN
	if is_parking: money_cost += GameConstants.MONEY_TO_UPKEEP_PARKING_SPOT_PER_TURN * (left_parking_obj.count_total_car_spaces() + right_parking_obj.count_total_car_spaces())
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
	

	

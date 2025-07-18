extends GameboardItem
class_name Road4Lane

@onready var left_parking = %LeftParking
@onready var right_parking = %RightParking
@onready var left_curtain_hitbox = %LeftCurtainHitbox 
@onready var right_curtain_hitbox = %RightCurtainHitbox

enum SETUP {PARKING,NO_PARKING}

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20

var speed: float = 40; #mph

var is_parking: bool
var cars_per_spot: int = 1
var left_parking_obj: Parking = Parking.create_empty()
var right_parking_obj: Parking = Parking.create_empty()
var top_left_parking_spot: Vector3 = Vector3(-136, -46, 0)

static func create(parking_status: int) -> Road4Lane:
	var road: Road4Lane = GameComponents.ROAD_4_LANE.instantiate()
	road.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE 
	road.elevation = 0 
	road.level = 0 
	road.max_level = 0
	road.is_parking = true if parking_status == SETUP.PARKING else false
	return road
	
func clone() -> Road4Lane:
	var new_road: Road4Lane = Road4Lane.create(SETUP.PARKING if self.is_parking else SETUP.NO_PARKING) 
	new_road._set_transform_from(self)
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
	
func _ready():
	z_index = ITEM_Z
	config_parking() 
	
func get_class_name() -> String:
	return "Road4Lane"
	
func get_left_parking_spots() -> Array[Vector3]:
	var s1: Vector3 = Vector3(top_left_parking_spot.x, top_left_parking_spot.y, top_left_parking_spot.z)
	var s2: Vector3 = Vector3(top_left_parking_spot.x, -top_left_parking_spot.y, top_left_parking_spot.z)
	return [s1, s2]
	
func get_right_parking_spots() -> Array[Vector3]:
	var s1: Vector3 = Vector3(-top_left_parking_spot.x, top_left_parking_spot.y, 0)
	var s2: Vector3 = Vector3(-top_left_parking_spot.x, -top_left_parking_spot.y, 0)
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

	if is_parking and area.is_in_group("actual_curtains"):
		left_parking.visible = false
		left_parking_obj.empty_contents()
	
func _on_left_curtain_hitbox_area_exited(_area: Area2D) -> void:
	if not is_parking: return
	await get_tree().physics_frame
	
	if GameHelper.is_hitbox_overlapping_hitbox_in_group(left_curtain_hitbox, "actual_curtains"):
		left_parking.visible = false
		left_parking_obj.empty_contents()
	else:
		left_parking.visible = true
		if left_parking_obj.is_empty(): left_parking_obj = Parking.create(get_left_parking_spots(), cars_per_spot)
		
func _on_right_curtain_hitbox_area_entered(area: Area2D) -> void:
	if is_parking and area.is_in_group("actual_curtains"):
		right_parking.visible = false
		right_parking_obj.empty_contents()
	
func _on_right_curtain_hitbox_area_exited(_area: Area2D) -> void:
	if not is_parking: return
	await get_tree().physics_frame
	
	if GameHelper.is_hitbox_overlapping_hitbox_in_group(right_curtain_hitbox, "actual_curtains"):
		right_parking.visible = false
		right_parking_obj.empty_contents()
	else:
		right_parking.visible = true
		if right_parking_obj.is_empty(): right_parking_obj = Parking.create(get_right_parking_spots(), cars_per_spot)

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
	

	

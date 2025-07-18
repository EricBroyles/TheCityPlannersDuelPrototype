extends GameboardItem
class_name ParkingLot2x2

@onready var main_body = %MainBody
@onready var curtain = %Curtain
@onready var curtain_2_lane = %Curtain2Lane
@onready var curtain_4_lane = %Curtain4Lane
@onready var curtain_hitbox = %CurtainHitbox

const SIZE_IN_TILES: Vector2 = Vector2(2,2) #(r,c)
const ITEM_Z: int = 20
const CURTAIN_START_POSITION = Vector2(200, -100)
const ROW_1_PARKING_SPOT: Vector3 = Vector3(-171, -146, 0)
const ROW_2_PARKING_SPOT: Vector3 = Vector3(-171, -54, 180)
const ROW_3_PARKING_SPOT: Vector3 = Vector3(ROW_1_PARKING_SPOT.x, -ROW_1_PARKING_SPOT.y, ROW_1_PARKING_SPOT.z)
const ROW_4_PARKING_SPOT: Vector3 = Vector3(ROW_2_PARKING_SPOT.x, -ROW_2_PARKING_SPOT.y, ROW_2_PARKING_SPOT.z)
const PARKING_SPOT_H_SEPERATION: float = 40.0
const PARKING_SPOTS_PER_ROW: int = 9

var cars_per_spot: int = 1
var parking_obj: Parking
var main_body_scale: Vector2 = Vector2(1,1)
var curtain_scale: Vector2 = Vector2(1,1)
var curtain_position: Vector2 = CURTAIN_START_POSITION

static func create() -> ParkingLot2x2:
	var lot: ParkingLot2x2 = GameComponents.PARKING_LOT_2X2.instantiate()
	lot.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE 
	lot.elevation = 0 
	lot.level = 0 
	lot.max_level = 0
	lot.parking_obj = Parking.create(lot.get_parking_spots(), lot.cars_per_spot)
	return lot
	
func clone() -> ParkingLot2x2:
	var new_lot: ParkingLot2x2 = ParkingLot2x2.create() 
	new_lot.main_body_scale = self.main_body_scale
	new_lot.curtain_scale = self.curtain_scale
	new_lot.curtain_position = self.curtain_position
	new_lot._set_transform_from(self)
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
	
func _ready():
	z_index = ITEM_Z
	main_body.scale = main_body_scale
	curtain.scale = curtain_scale
	curtain.position = curtain_position
	
func get_class_name() -> String:
	return "ParkingLot2x2"

func _on_curtain_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("curtain_detectors_2_lane"):
		curtain_2_lane.visible = true
		curtain_4_lane.visible = false
	elif area.is_in_group("curtain_detectors_4_lane"):
		curtain_2_lane.visible = false
		curtain_4_lane.visible = true
	return

func _on_curtain_hitbox_area_exited(_area: Area2D) -> void:
	await get_tree().physics_frame
	if curtain_hitbox.get_overlapping_areas().is_empty(): 
		curtain_2_lane.visible = false
		curtain_4_lane.visible = false
	return
	
func get_parking_spots() -> Array[Vector3]:
	var all_parking_spots: Array[Vector3] = []
	for c in PARKING_SPOTS_PER_ROW:
		var h_shift: Vector3 = Vector3(c*PARKING_SPOT_H_SEPERATION, 0, 0)
		all_parking_spots.append(ROW_1_PARKING_SPOT + h_shift)
		all_parking_spots.append(ROW_2_PARKING_SPOT + h_shift)
		all_parking_spots.append(ROW_3_PARKING_SPOT + h_shift)
		all_parking_spots.append(ROW_4_PARKING_SPOT + h_shift)
	return all_parking_spots
	
func get_money_buy_cost() -> int:
	var money_cost: float = GameConstants.MONEY_PER_PARKING_SPOT * parking_obj.count_total_car_spaces()
	return int(money_cost)

func get_money_upkeep_cost() -> int:
	var money_cost: float = GameConstants.MONEY_TO_UPKEEP_PARKING_SPOT_PER_TURN * parking_obj.count_total_car_spaces()
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
	
##Transforms
func perform_reset_orientation():
	super()
	
	main_body_scale = Vector2(1,1)
	curtain_scale = Vector2(1,1)
	curtain_position = CURTAIN_START_POSITION
	
	if main_body == null: return
	
	main_body.scale = Vector2(1,1)
	curtain.scale = Vector2(1,1)
	curtain.position = CURTAIN_START_POSITION

func perform_flip_h():
	
	main_body_scale = Vector2(1, -1)
	curtain_position.y *= -1
	
	if main_body == null: return
	
	main_body.scale = Vector2(1, -1)
	curtain.position.y *= -1
	
func perform_flip_v():
	main_body_scale = Vector2(-1, 1)
	curtain_position.x *= -1
	curtain_scale *= -1
	
	if main_body == null: return
	
	main_body.scale = Vector2(-1, 1)
	curtain.position.x *= -1
	curtain.scale *= -1

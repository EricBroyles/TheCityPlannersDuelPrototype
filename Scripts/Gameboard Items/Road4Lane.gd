extends GameboardItem
class_name Road4Lane

## Road4Lane Use
#  Create
#   1. Create an Instance
#   2. Call setup with the parking status
#   3. Now add it to the scene this calls _ready which sets up left and right parking
#  Duplicate
#   0. Have an old_instance to copy from
#   1. Create an Instance
#   2. (optional step: this get override so dont do this) Call setup with the parking status
#   3. Call set_properties_from(old_instance), this calls setup for the Instance
#   3. Now add it to the scene this calls _ready which sets up left and right parking

@onready var main_body_hitbox = %MainBodyHitbox
@onready var left_parking = %LeftParking
@onready var right_parking = %RightParking
@onready var left_parking_hitbox = %LeftParkingHitbox #I need these hitboxes as variables so that I can disable them when they are not needed
@onready var right_parking_hitbox = %RightParkingHitbox

enum SETUP {
	PARKING,
	NO_PARKING
}

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20
const MAX_PARKING_SPOTS: int = 4

var speed: float = 40; #mph

var is_parking: bool
var left_parking_active: bool
var right_parking_active: bool

func setup(parking_status: int) -> void:
	self.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE #the size to begin with
	self.elevation = 0 #Elevation: 0 base, .5 (halfway), 1 (up a level)
	self.level = 0 #Levels: 0 means that it does not have levels, otherwise starts at level 1
	self.max_level = 0
	
	#notice how left and right parking is set at _ready
	is_parking = true if parking_status == SETUP.PARKING else false
	
	
func set_properties_from(other: GameboardItem):
	super(other) #this sets key info like position and orientation
	var parking_status: int = SETUP.PARKING if other.is_parking else SETUP.NO_PARKING
	setup(parking_status)
	
func _ready():
	z_index = ITEM_Z
	config_parking() #this sets up the left and right parking

func config_parking():
	left_parking_active = is_parking
	right_parking_active = is_parking

	left_parking.visible = left_parking_active
	right_parking.visible = right_parking_active

	left_parking_hitbox.monitoring = left_parking_active
	right_parking_hitbox.monitoring = right_parking_active
	
	left_parking_hitbox.monitorable = left_parking_active
	right_parking_hitbox.monitorable = right_parking_active
	
func _on_left_parking_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	
func _on_right_parking_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.



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
	#to be charged once a turn
	var money_cost: float = 2.1 * GameConstants.MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN
	if is_parking: money_cost += GameConstants.MONEY_TO_UPKEEP_PARKING_SPOT_PER_TURN * get_amount_of_active_parking_spots() 
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
	

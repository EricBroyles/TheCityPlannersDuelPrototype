extends GameboardItem

class_name Road4Lane

@onready var left_parking = %LeftParking
@onready var right_parking = %RightParking
@onready var left_parking_hitbox = %LeftParkingHitbox
@onready var right_parking_hitbox = %RightParkingHitbox

#@onready var left_parking_col = $Parking/LeftParkingColumn

const SIZE_IN_TILES: Vector2 = Vector2(1,2) #(r,c)
const ITEM_Z: int = 20
const MAX_PARKING_SPOTS: int = 4

var speed: float = 40; #mph

var is_parking: bool
var left_parking_active: bool
var right_parking_active: bool

func _init() -> void:
	self.size = Vector2(SIZE_IN_TILES.y, SIZE_IN_TILES.x) * GameConstants.GAMEBOARD_TILE_SIZE #the size to begin with
	self.elevation = 0 #Elevation: 0 base, .5 (halfway), 1 (up a level)
	self.level = 0 #Levels: 0 means that it does not have levels, otherwise starts at level 1
	self.max_level = 0
	
func set_parking(status: bool):
	is_parking = status
	#notice that this is intended to be called after init, and left and right parking active are still null. they will be activated or not activated when _ready
	
func _ready():
	z_index = ITEM_Z
	
	#this sets up the left and right parking
	config_parking(is_parking)

#it is assumed that this is called on an instantiated version and then it will be added to the scene
func set_properties_from(other: GameboardItem):
	super(other)
	set_parking(other.is_parking) #when you add it to the scene it does _ready and triggers the congif_parkng


func get_money_buy_cost() -> int:
	var money_cost = 2.1 * GameConstants.MONEY_PER_ROAD_2_LANE
	if is_parking: money_cost += GameConstants.MONEY_PER_PARKING_SPOT * MAX_PARKING_SPOTS #yes just overcharge them I am not going to handle refunding parking spots as they change
	return money_cost

#to be charged once a turn
func get_money_upkeep_cost() -> int:
	var money_cost = 2.1 * GameConstants.MONEY_TO_UPKEEP_ROAD_2_LANE_PER_TURN
	if is_parking: money_cost += GameConstants.MONEY_TO_UPKEEP_PARKING_SPOT_PER_TURN * get_amount_of_active_parking_spots() 
	return money_cost
	
func get_money_delete_cost() -> int:
	return get_money_buy_cost() * .1
	
func get_amount_of_active_parking_spots() -> int:
	var amount: int = 0
	if left_parking_active: amount += 2
	if right_parking_active: amount += 2
	return amount
	
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
	
# FINISH if need to buy in batches
func max_amount_can_buy() -> int:
	return 0
	
## FINISH
func batch_buy(amount: int):
	print(amount)
	pass
	
	
func config_parking(status: bool):
	left_parking_active = status
	right_parking_active = status

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

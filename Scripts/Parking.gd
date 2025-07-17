extends Resource
class_name Parking

##Rules
# * spot just means the Vector3 for the parking spot
# * each spot can have multiple spaces 
# * each space means a space for a car

var struct: Dictionary #{Vector3: [Cars, ...], ...}
var cars_per_spot: int

static func create_empty() -> Parking:
	var parking: Parking = Parking.new()
	parking.struct = {}
	parking.cars_per_spot = 0
	return parking
	
static func create(spots: Array[Vector3], the_cars_per_spot: int = 1) -> Parking:
	var parking: Parking = Parking.new()
	parking.cars_per_spot = the_cars_per_spot
	for spot in spots:
		var car_spaces: Array = []
		for i in the_cars_per_spot:
			car_spaces.append(null)  
		parking.struct[spot] = car_spaces
		
	return parking

func empty_contents():
	print("warning: I need to improve this and decrease parking spaces, as this invovles deleting cars")
	struct = {}
	cars_per_spot = 0
	
func is_empty():
	return (struct == {} and cars_per_spot == 0)
	
func get_spots() -> Array[Vector3]:
	var spots: Array[Vector3] = []
	for key in struct.keys():
		spots.append(key as Vector3)
	return spots
	
func get_car_spaces() -> Array[Array]:
	var all_car_spaces: Array[Array] = []
	for spaces in struct.values():
		all_car_spaces.append(spaces as Array)
	return all_car_spaces
	
func count_total_spots() -> int:
	return struct.size()
	
func count_total_car_spaces() -> int:
	var total := 0
	for spaces in get_car_spaces():
		total += spaces.size()
	return total
	
func count_available_car_spaces() -> int:
	var available := 0
	for spaces in get_car_spaces():
		for car in spaces:
			if car == null:
				available += 1
	return available
	
func increase_parking_spaces(new_cars_per_spot: int):
	if new_cars_per_spot <= cars_per_spot: return
	
	for key in get_spots():
		var space_array: Array = struct[key]
		var additional_slots := new_cars_per_spot - space_array.size()
		for i in range(additional_slots):
			space_array.append(null)
		struct[key] = space_array
	
	cars_per_spot = new_cars_per_spot
	
func decrease_parking_spaces(new_cars_per_spot: int):
	if new_cars_per_spot >= cars_per_spot: return
	for key in get_spots():
		var space_array: Array = struct[key]
		# Check if we're removing non-empty spaces (optional warning)
		for i in range(space_array.size() - 1, new_cars_per_spot - 1, -1):
			if space_array[i] != null:
				print("Warning: Removing a non-empty parking space at spot I NEEED TO FINIH THIS WHEN I GET AROUND TO CARS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", key)
			space_array.remove_at(i)
		struct[key] = space_array
	
	cars_per_spot = new_cars_per_spot
	
func change_parking_spaces(new_cars_per_spot: int):
	if new_cars_per_spot > cars_per_spot:
		increase_parking_spaces(new_cars_per_spot)
	elif new_cars_per_spot < cars_per_spot:
		decrease_parking_spaces(new_cars_per_spot)
	

###TO BE BUILT
#func get_all_cars() -> Array[Car]:
	#pass
	
#park a car at ...
#remove a car procedure (use during delete
#increase the parking spaces
#decrease the parking spaces handle removal of cars

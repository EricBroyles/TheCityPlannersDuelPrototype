#extends GameboardItem
#
#class_name ParkingLot
#
#@onready var main = $Main
#@onready var curtain = $Curtain
#
#var curtain_start_position: Vector2
#
#
#func _ready():
	#curtain_start_position = curtain.position ## ISSUE
	#
	#
#
#
#
#
#
### ---- Helpers ----
### ---- Transform Helpers ----------- REMEMBER YOU ARE ALWAYS FLIPPING FROM THE STSRTING POSITION
#func reset_real_orientation():
	#super()
	#main.scale = Vector2(1,1)
	#curtain.position = curtain_start_position
	#curtain.scale = Vector2(1,1)
	#
#func flip_h_real_orientation():
	#real_orientation["flip_h"] = !real_orientation["flip_h"]
	#
	##change the scale of flip container to inverted
	#main.scale = Vector2(1, -1)
	#
	##switch the position of the curtain so it is flipped v
	#curtain.position.y *= -1
	#
#func flip_v_real_orientation():
	#real_orientation["flip_v"] = !real_orientation["flip_v"]
	#
	##change the scale of flip container to inverted
	#main.scale = Vector2(-1, 1)
	#
	##switch the position of the curtain so it is flipped v
	#curtain.position.x *= -1 
	#curtain.scale *= -1
	#

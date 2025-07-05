extends Node2D

class_name GameboardSelector

@onready var buy_land_option = %BuyLandOption
@onready var upgrade_option = %UpgradeOption
@onready var delete_option = %DeleteOption

#var upgrade_mouse_texture: Texture2D = preload("res://Assets - User Interface/Icons/Small Icon W Border _ Circle Up Arrow.svg")
#var delete_mouse_texture: Texture2D = preload("res://Assets - User Interface/Icons/Small Icon W Border _ Trashcan.svg")

var size: Vector2 = Vector2(0,0)
# this does not need a type, as this is never being added to the gameboard, it is just a UI visulaize tool

func _ready():
	z_index = 1000

func close():
	close_all_options()
	self.visible = false
	
func open_buy_land_selector():
	close_all_options()
	self.visible = true
	buy_land_option.visible = true
	size = buy_land_option.texture.get_size()
	
func open_upgrade_selector():
	close_all_options()
	self.visible = true
	upgrade_option.visible = true
	size = upgrade_option.texture.get_size()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func open_delete_selector():
	close_all_options()
	self.visible = true
	delete_option.visible = true
	size = delete_option.texture.get_size()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func close_all_options():
	buy_land_option.visible = false
	upgrade_option.visible = false
	delete_option.visible = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	size = Vector2(0,0)

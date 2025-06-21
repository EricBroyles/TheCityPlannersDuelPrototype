extends Node

class_name GameboardSelector

@onready var buy_land_option = %BuyLandOption
@onready var upgrade_option = %UpgradeOption
@onready var delete_option = %DeleteOption

var size: Vector2 = Vector2(0,0)
# this does not need a type, as this is never being added to the gameboard, it is just a UI visulaize tool

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
	
func open_delete_selector():
	close_all_options()
	self.visible = true
	delete_option.visible = true
	size = delete_option.texture.get_size()
	
func close_all_options():
	buy_land_option.visible = false
	upgrade_option.visible = false
	delete_option.visible = false
	size = Vector2(0,0)

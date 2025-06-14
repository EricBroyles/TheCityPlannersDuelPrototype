extends Node

class_name GameboardTile

@onready var body = %Body

var type: int
var oriented_size: Vector2

func _ready() -> void:
	oriented_size = body.size
	
	

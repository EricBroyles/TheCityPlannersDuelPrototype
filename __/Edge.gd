#extends GameboardContainer
#
#class_name Edge
#
#enum LOCATION_TYPES {
	#TOP,
	#BOTTOM,
	#LEFT,
	#RIGHT
#}
#
#var location_type: int
#
#static func create(box_center_pos: Vector2, loc_type: int) -> Edge:
	#var edge = Edge.new()
	#edge.location_type = loc_type
	#
	#match loc_type:
		#LOCATION_TYPES.TOP:
			#edge.center_position = round(box_center_pos + Vector2(0, -.5) * GameConstants.GAMEBOARD_TILE_SIZE)
		#LOCATION_TYPES.BOTTOM:
			#edge.center_position = round(box_center_pos + Vector2(0, +.5) * GameConstants.GAMEBOARD_TILE_SIZE)
		#LOCATION_TYPES.LEFT:
			#edge.center_position = round(box_center_pos + Vector2(-.5, 0) * GameConstants.GAMEBOARD_TILE_SIZE)
		#LOCATION_TYPES.RIGHT:
			#edge.center_position = round(box_center_pos + Vector2(+.5, 0) * GameConstants.GAMEBOARD_TILE_SIZE)
			#
	#return edge
	#

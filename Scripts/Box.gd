extends GameboardContainer
class_name Box

var r: int
var c: int
var top_left_position: Vector2

var top_edge: Edge
var bottom_edge: Edge
var left_edge: Edge
var right_edge: Edge

static func create(row: int, col: int, top_left_pos: Vector2) -> Box:
	var box = Box.new()
	box.r = row
	box.c = col
	box.top_left_position = top_left_pos
	box.center_position = round(top_left_pos + Vector2(.5,.5) * GameConstants.GAMEBOARD_TILE_SIZE)
	
	box.top_edge = Edge.create(box.center_position, Edge.new().LOCATION_TYPES.TOP)
	box.bottom_edge = Edge.create(box.center_position, Edge.new().LOCATION_TYPES.BOTTOM)
	box.left_edge = Edge.create(box.center_position, Edge.new().LOCATION_TYPES.LEFT)
	box.right_edge = Edge.create(box.center_position, Edge.new().LOCATION_TYPES.RIGHT)

	return box
	
#Use this so that shared edges between boxes in a matrix are references to each other
#gets passed a matrix of boxes with edges
func trim_edges(box_matrix: Array[Array]):
	if not box_matrix:
		return

	# Top edge: shared with the box above
	var top_box_index = Vector2(r - 1, c)
	if GameHelper.is_index_in_matrix(top_box_index, box_matrix):
		top_edge = box_matrix[top_box_index.x][top_box_index.y].bottom_edge

	# Left edge: shared with the box to the left
	var left_box_index = Vector2(r, c - 1)
	if GameHelper.is_index_in_matrix(left_box_index, box_matrix):
		left_edge = box_matrix[left_box_index.x][left_box_index.y].right_edge


func get_coord() -> Vector2:
	return Vector2(r,c)

func get_edges() -> Array[Edge]:
	return [top_edge, bottom_edge, left_edge, right_edge]
	
func get_edge_positions() -> Array[Vector2]:
	return [top_edge.center_position, bottom_edge.center_position, left_edge.center_position, right_edge.center_position]
	
func get_edge_at_position(edge_position) -> Edge:
	if edge_position == top_edge.center_position:
		return top_edge
	if edge_position == bottom_edge.center_position:
		return bottom_edge
	if edge_position == left_edge.center_position:
		return left_edge
	if edge_position == right_edge.center_position:
		return right_edge	
	return null
	
	

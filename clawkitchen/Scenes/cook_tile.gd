extends Area2D

# Reference to the spawner node (which should be a Node2D or subclass)
@export var spawner: Node
# Reference to the size of the tile (this will be set from the spawner)
var tile_size: Vector2

# Store the occupied sides of the tile (using Vector2 as directions)
var occupied_sides = {}

# Called when a mouse button is pressed on this tile
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		if spawner and spawner.has_method("spawn_new_cook_tile_at_random_edges"):
			# Call the spawner's spawn_new_cook_tile function
			spawner.spawn_new_cook_tile_at_random_edges()

# Check if a specific side is occupied
func is_side_occupied(direction: Vector2) -> bool:
	return occupied_sides.has(direction)

# Mark a side as occupied
func mark_side_as_occupied(direction: Vector2) -> void:
	occupied_sides[direction] = true

# Mark the sides adjacent to this tile as occupied
func mark_adjacent_sides_as_occupied() -> void:
	var directions = [
		Vector2(0, -tile_size.y), # Top
		Vector2(0, tile_size.y),  # Bottom
		Vector2(-tile_size.x, 0), # Left
		Vector2(tile_size.x, 0)   # Right
	]
	
	# Loop through each direction and mark as occupied
	for direction in directions:
		occupied_sides[direction] = true

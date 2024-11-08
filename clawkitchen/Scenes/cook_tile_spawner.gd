extends Node2D

# Path to the cook tile scene
@export var cook_tile_scene: PackedScene
# Size of each cook tile (set this to match the actual size of the tile in pixels)
@export var tile_size: Vector2 = Vector2(25, 25)
# Maximum number of cook tiles allowed in the scene
@export var max_cook_tiles: int = 200
# Margin from the viewport edges where tiles can spawn (in pixels)
@export var spawn_margin: int = 100

# Keep track of the number of cook tiles in the scene
var current_cook_tiles_count: int = 0

# Called when the node is ready
func _ready() -> void:
	# Optionally spawn a cook tile when the game starts (in the center of the screen)
	spawn_cook_tile(get_viewport_rect().size / 2)

# Function to spawn a new cook tile at a given position
func spawn_cook_tile(position: Vector2) -> void:
	# Clamp the spawn position to ensure the tile doesn't spawn below the viewport
	position.y = clamp(position.y, 0, get_viewport().size.y - tile_size.y)
	position.x = clamp(position.x, spawn_margin, get_viewport().size.x - spawn_margin - tile_size.x)

	# Check if the current number of cook tiles exceeds the maximum allowed
	if current_cook_tiles_count >= max_cook_tiles:
		print("Max number of cook tiles reached. Cannot spawn more.")
		return  # Do not spawn any more tiles if the limit is reached
	
	# Instance a new cook tile from the scene
	var tile = cook_tile_scene.instantiate()
	
	# Set the position of the new tile (clamped value)
	tile.position = position
	
	# Set the spawner reference on the cook tile (so it can call functions back to the spawner)
	tile.spawner = self
	
	# Pass the tile size to the newly created tile
	tile.tile_size = tile_size
	
	# Add the new tile as a child of the spawner node
	add_child(tile)
	
	# Increment the current tile count
	current_cook_tiles_count += 1
	print("New tile spawned. Total tiles: ", current_cook_tiles_count)

# Function to spawn three new cook tiles when a mouse click occurs
func spawn_new_cook_tile_at_random_edges() -> void:
	# If the maximum tile limit is reached, stop spawning
	if current_cook_tiles_count >= max_cook_tiles:
		print("Max number of cook tiles reached. Cannot spawn more.")
		return
	
	# Get all the current cook tiles in the scene
	var all_tiles = get_children()
	
	# Filter out only the cook tiles (assuming the tiles are instances of CookTile)
	var cook_tiles = []
	for tile in all_tiles:
		if tile is Area2D:  # Assuming CookTile extends Area2D
			cook_tiles.append(tile)
	
	print("Found ", cook_tiles.size(), " cook tiles.")  # Debug: Count of cook tiles
	
	# List to store available spawn locations (position and the direction to spawn in)
	var available_spawn_locations = []
	
	# Check all the cook tiles and their unoccupied edges
	for tile in cook_tiles:
		var directions = [
			Vector2(0, -tile_size.y), # Top
			Vector2(0, tile_size.y),  # Bottom
			Vector2(-tile_size.x, 0), # Left
			Vector2(tile_size.x, 0)   # Right
		]
		
		# For each direction, check if it's unoccupied
		for direction in directions:
			if !tile.is_side_occupied(direction):
				var spawn_position = tile.position + direction
				# Clamp spawn position to not go below the viewport and to be within the spawn margin
				spawn_position.y = clamp(spawn_position.y, 0, get_viewport().size.y - tile_size.y)
				spawn_position.x = clamp(spawn_position.x, spawn_margin, get_viewport().size.x - spawn_margin - tile_size.x)
				
				# Ensure spawn position is within the margin from the edges of the viewport
				if spawn_position.x > spawn_margin and spawn_position.x < get_viewport().size.x - spawn_margin:
					available_spawn_locations.append(spawn_position)
					print("Available edge at ", spawn_position)  # Debug: show available spawn positions
				
				# Mark this side as occupied for the tile
				tile.mark_side_as_occupied(direction)
	
	# If there are at least three available spawn locations, randomly choose three
	if available_spawn_locations.size() >= 3:
		var random_spawn_pos_1 = available_spawn_locations[randi() % available_spawn_locations.size()]
		available_spawn_locations.erase(random_spawn_pos_1)  # Remove the first position to ensure the second is different
		
		var random_spawn_pos_2 = available_spawn_locations[randi() % available_spawn_locations.size()]
		available_spawn_locations.erase(random_spawn_pos_2)
		
		var random_spawn_pos_3 = available_spawn_locations[randi() % available_spawn_locations.size()]
		
		# Spawn the new tiles at the selected random positions
		spawn_cook_tile(random_spawn_pos_1)
		spawn_cook_tile(random_spawn_pos_2)
		spawn_cook_tile(random_spawn_pos_3)
		
		print("Three new tiles spawned at: ", random_spawn_pos_1, " and ", random_spawn_pos_2, " and ", random_spawn_pos_3)  # Debugging
	else:
		print("Not enough available edges to spawn three new tiles.")  # Debugging if not enough edges are available

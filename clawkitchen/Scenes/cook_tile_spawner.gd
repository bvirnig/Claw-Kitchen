extends Node2D

# Path to the cook tile scene
@export var cook_tile_scene: PackedScene
# Size of each cook tile (set this to match the actual size of the tile in pixels)
@export var tile_size: Vector2 = Vector2(25, 25)

func _ready() -> void:
	spawn_cook_tile(get_viewport_rect().size / 2)

func spawn_cook_tile(position: Vector2) -> void:
	# Instance a new cook tile
	var tile = cook_tile_scene.instantiate()
	
	# Set the position of the new tile
	tile.position = position
	
	# Set the spawner reference on the cook tile
	tile.spawner = self
	
	# Add the tile to the spawner node
	add_child(tile)

# Function to spawn a new cook tile touching a random edge of the specified tile
func spawn_new_cook_tile(clicked_tile: Area2D) -> void:
	# Determine a random direction to spawn the new tile
	var direction = randi() % 4  # Randomly choose 0 (top), 1 (bottom), 2 (left), or 3 (right)
	var new_position = clicked_tile.position
	
	match direction:
		0: # Top edge
			new_position.y -= tile_size.y
		1: # Bottom edge
			new_position.y += tile_size.y
		2: # Left edge
			new_position.x -= tile_size.x
		3: # Right edge
			new_position.x += tile_size.x
	
	# Spawn a new cook tile at the calculated position
	spawn_cook_tile(new_position)

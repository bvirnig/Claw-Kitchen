extends Node2D

@export var prize_scene: PackedScene  # The scene to be instanced for the prize
@export var rows: int = 3  # Number of rows to spawn
@export var prizes_per_row: int = 6  # Number of prizes per row
@export var spacing: float = 2.0  # Spacing between prizes
@export var prize_textures: Array = []  # Array of textures to choose from

const SCREEN_WIDTH: int = 450  # Fixed screen width
const SCREEN_HEIGHT: int = 648  # Fixed screen height

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_prizes()  # Spawn the prizes when the node is ready

# Function to spawn prizes
func _spawn_prizes() -> void:
	var prize_height = 50  # Assuming each prize has a height of 50 pixels

	# Get textures based on the current level
#	var available_textures = get_textures_for_level(get_current_level())

	for row in range(rows):
		# Calculate the Y position for this row
		var row_y_position = SCREEN_HEIGHT - (row * (prize_height + spacing)) - (prize_height)

		for prize_index in range(prizes_per_row):
			# Instantiate the prize from the scene
			var prize_instance = prize_scene.instantiate()

			# Calculate the X position for each prize in the row
			var prize_x_position = (prize_index + 2.7) * (SCREEN_WIDTH / prizes_per_row * 0.7)

			# Set the prize's position
			prize_instance.position = Vector2(prize_x_position, row_y_position)

			# Assign a random texture from the available textures
#			if available_textures.size() > 0:
#				var random_texture = available_textures[randi() % available_textures.size()]
#				prize_instance.get_node("Sprite2D").texture = random_texture  # Assuming the Sprite node is named "Sprite2D"

			# Add the prize to the scene
			add_child(prize_instance)
			prize_instance.add_to_group("prize")  # Add to the 'prize' group for easy management

# Function to reset prizes, passing current_level to ensure speeds are updated correctly
func reset_prizes(current_level: int) -> void:
	clear_prizes()  # Clear existing prizes
	_spawn_prizes()  # Spawn new prizes
	# After spawning, update the speed of the prizes based on the current level
	for prize in get_tree().get_nodes_in_group("prize"):
		prize.update_speed(current_level)

# Function to clear existing prizes
func clear_prizes() -> void:
	for child in get_children():
		if child.is_in_group("prize"):
			child.queue_free()  # Remove from the scene

# Function to get textures available for the current level
func get_textures_for_level(level: int) -> Array:
	match level:
		1: return [prize_textures[0]]  # Only texture 0 for level 1
		2: return [prize_textures[1], prize_textures[2], prize_textures[3], prize_textures[4]]  # Textures 1-4 for level 2
		3: return [prize_textures[7], prize_textures[12], prize_textures[13], prize_textures[14]]  # Textures 7, 12, 13, 14 for level 3
		4: return [prize_textures[9], prize_textures[10], prize_textures[11]]  # Textures 9, 10, 11 for level 4
		5: return [prize_textures[5], prize_textures[6], prize_textures[8]]  # Textures 5, 6, 8 for level 5
		6: return [prize_textures[15], prize_textures[16], prize_textures[17]]  # Textures 15, 16, 17 for level 6
		_ : return []  # Return empty array for invalid levels

# Placeholder function to get the current level; replace with your actual logic
#func get_current_level() -> int:
#	return get_parent().current_level  # Assuming current_level is accessible from the parent node

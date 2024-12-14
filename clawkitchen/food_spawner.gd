extends Node2D

@export var prize_scene: PackedScene  # The scene to be instanced for the prize
@export var rows: int = 3  # Number of rows to spawn
@export var prizes_per_row: int = 6  # Number of prizes per row
@export var spacing: float = 2.0  # Spacing between prizes
@export var change_food_timer: Timer  # Reference to the timer node

const SCREEN_WIDTH: int = 450  # Fixed screen width
const SCREEN_HEIGHT: int = 648  # Fixed screen height

# List to keep track of spawned prize instances
var spawned_prizes = []

# Food types
var selected_food_types = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_prizes()  # Spawn the initial prizes when the node is ready


# Function to spawn prizes
func _spawn_prizes() -> void:
	var prize_height = 50  # Assuming each prize has a height of 50 pixels

	# Step 1: Randomly select 5 distinct food types
	selected_food_types = _select_random_food_types()

	# Step 2: Randomly assign one of the 5 food types to all prizes
	var food_distribution = _distribute_foods_randomly(selected_food_types)

	# Remove all previously spawned prizes before spawning new ones
	_remove_previous_prizes()

	# Loop to spawn prizes in rows
	for row in range(rows):
		# Calculate the Y position for this row
		var row_y_position = SCREEN_HEIGHT - (row * (prize_height + spacing)) - prize_height

		# Loop to spawn prizes in the row
		for prize_index in range(prizes_per_row):
			# Instantiate the prize from the scene
			var prize_instance = prize_scene.instantiate()

			# Calculate the X position for each prize in the row
			var prize_x_position = (prize_index + 2.7) * (SCREEN_WIDTH / prizes_per_row * 0.7)

			# Get the food type for this prize from the distribution
			var food_type = food_distribution[row * prizes_per_row + prize_index]

			# Check that food_type exists in food_types to avoid out of bounds access
			if food_type in Gamedata.food_types:
				# Get the texture for the food type
				var food_texture = Gamedata.food_textures[Gamedata.food_types.find(food_type)]

				# Ensure prize_instance has the Sprite2D node
				var sprite_node = prize_instance.get_node("Sprite2D")

				# Set the texture for the prize
				sprite_node.texture = food_texture

				# Set the food type and texture index for the prize
				prize_instance.food_type = food_type
				prize_instance.texture_index = Gamedata.food_textures.find(food_texture)

				# Set the prize's position
				prize_instance.position = Vector2(prize_x_position, row_y_position)

				# Add the prize to the scene
				add_child(prize_instance)
				prize_instance.add_to_group("prize")  # Add to the 'prize' group for easy management

				# Track the spawned prize
				spawned_prizes.append(prize_instance)
			else:
				print("ERROR: Food type not found in food_types:", food_type)

# Function to remove all previously spawned prizes
func _remove_previous_prizes() -> void:
	# Iterate through the list of spawned prizes
	for i in range(spawned_prizes.size()):
		# Ensure that the prize exists and is still in the scene tree
		var prize = spawned_prizes[i]
		if prize != null and prize.is_inside_tree():
			prize.queue_free()  # Safely remove it from the scene tree

	# Clear the list after removal
	spawned_prizes.clear()

# Function to randomly select 5 distinct food types from the Gamedata
func _select_random_food_types() -> Array:
	var selected_food_types = []
	while selected_food_types.size() < 5:
		var random_index = randi() % Gamedata.food_types.size()  # Ensure random selection within bounds
		# Debugging log to check random index
		var food_type = Gamedata.food_types[random_index]
		if food_type not in selected_food_types:
			selected_food_types.append(food_type)
	return selected_food_types

# Function to randomly assign one of the 5 food types to each prize
func _distribute_foods_randomly(food_types: Array) -> Array:
	var distribution = []
	var total_prizes = rows * prizes_per_row

	# Step 1: Randomly assign one of the food types to each prize
	for i in range(total_prizes):
		var random_food_type = food_types[randi() % food_types.size()]  # Randomly pick a food type
		distribution.append(random_food_type)

	# Step 2: (Optional) Shuffle the distribution for additional randomness (you can remove this if not needed)
	distribution.shuffle()

	return distribution

# Called when the timer times out
func _on_change_food_timer_timeout() -> void:
	# Randomly select new food types for the next set of prizes
	selected_food_types = _select_random_food_types()

	# Update the food distribution for prizes
	_spawn_prizes()  # Re-spawn the prizes with new food types

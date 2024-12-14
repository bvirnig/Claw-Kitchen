extends Node2D

@export var request_scene: PackedScene  # The scene to be instanced for the request
@export var spacing: float = 2.0  # Spacing (not really needed for just one request)
@export var change_food_timer: Timer  # Reference to the timer node

const SCREEN_WIDTH: int = 450  # Fixed screen width
const SCREEN_HEIGHT: int = 648  # Fixed screen height

# List to keep track of spawned request instances
var spawned_requests = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_request()  # Spawn the initial request when the node is ready

# Function to spawn a single request
func _spawn_request() -> void:
	var request_height = 50  # Assuming each request label has a height of 50 pixels

	# Step 1: Randomly select a food type
	var selected_food_type = _select_random_food_types()[0]  # Get only the first selected food type

	# Remove all previously spawned requests before spawning a new one
	_remove_previous_requests()

	# Instantiate the request from the scene
	var request_instance = request_scene.instantiate()

	# Calculate the X and Y positions for the request (slightly to the right of top center)
	var request_x_position = SCREEN_WIDTH / 2 + 320  # Slightly to the right of the center (adjusted to 20)
	var request_y_position = 50  # Adjusted to 15 pixels down from the very top

	# Get the food texture for the selected food type
	if selected_food_type in Gamedata.food_types:
		var food_texture = Gamedata.food_textures[Gamedata.food_types.find(selected_food_type)]

		# Ensure request_instance has the Sprite2D node
		var sprite_node = request_instance.get_node("Sprite2D2")

		# Set the texture for the request label
		sprite_node.texture = food_texture

		# Set the food type for the request label
		request_instance.food_type = selected_food_type

		# Set the request's position
		request_instance.position = Vector2(request_x_position, request_y_position)

		# Add the request to the scene
		add_child(request_instance)
		request_instance.add_to_group("request")  # Add to the 'request' group for easy management

		# Track the spawned request
		spawned_requests.append(request_instance)
	else:
		print("ERROR: Food type not found in food_types:", selected_food_type)

# Function to remove all previously spawned requests
func _remove_previous_requests() -> void:
	# Iterate through the list of spawned requests
	for i in range(spawned_requests.size()):
		# Ensure that the request exists and is still in the scene tree
		var request = spawned_requests[i]
		if request != null and request.is_inside_tree():
			request.queue_free()  # Safely remove it from the scene tree

	# Clear the list after removal
	spawned_requests.clear()

# Function to randomly select 5 distinct food types from the Gamedata
func _select_random_food_types() -> Array:
	var selected_food_types = []
	while selected_food_types.size() < 5:
		var random_index = randi() % Gamedata.food_types.size()  # Ensure random selection within bounds
		var food_type = Gamedata.food_types[random_index]
		if food_type not in selected_food_types:
			selected_food_types.append(food_type)
	return selected_food_types

# Called when the timer times out (if you want to re-spawn requests after some time)
func _on_change_food_timer_timeout() -> void:
	# Randomly select new food types for the next set of requests
	var selected_food_types = _select_random_food_types()

	# Update the food distribution for requests
	_spawn_request()  # Re-spawn a new request with new food type

extends Node2D

@export var request_scene: PackedScene  # The scene to be instanced for the request
@export var change_food_timer: Timer  # Reference to the timer node
@onready var spawn_timer: Timer = $SpawnTimer  # Reference to your SpawnTimer in the scene tree
@onready var reset_timer: Timer = $ResetTimer  # Reference to your ResetTimer in the scene tree
@export var initial_position: Vector2 = Vector2(520, 50)  # Initial spawn position

const SCREEN_WIDTH: int = 450  # Fixed screen width
const SCREEN_HEIGHT: int = 648  # Fixed screen height
const SPACING: float = 80.0  # Distance between each request label

# Array of 8 fixed positions for the requests
var spawn_positions: Array = []

# List to keep track of spawned request instances
var spawned_requests = []

# Track the current spot to spawn a request at (this will cycle between 0 and 7)
var current_spawn_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Populate the spawn positions array with the fixed positions (8 spots)
	for i in range(8):
		spawn_positions.append(initial_position + Vector2(SPACING * i, 0))

	# Start spawning the first set of requests
	_spawn_request()

	# Start the timers
	spawn_timer.start()  # Start the spawn timer
	reset_timer.start()  # Start the reset timer

# Function to spawn a single request at the current position
func _spawn_request() -> void:
	# If we've already spawned requests at all positions, do nothing
	if spawned_requests.size() >= 8:
		# After the first 8 requests are placed, start overwriting them by cycling the positions.
		# You can skip this condition if you want to keep them from overwriting.
		pass  # The first 8 spots are filled; we'll start overwriting after that.

	# Step 1: Randomly select a food type from the first 10 items
	var selected_food_type = _select_random_food_types()[0]  # Get only the first selected food type

	# Instantiate the request from the scene
	var request_instance = request_scene.instantiate()

	# Get the position for this request (using the current spawn index)
	var spawn_position = spawn_positions[current_spawn_index]

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
		request_instance.position = spawn_position

		# Add the request to the scene
		add_child(request_instance)
		request_instance.add_to_group("request")  # Add to the 'request' group for easy management

		# Track the spawned request
		spawned_requests.append(request_instance)

	# Update the spawn index for the next request
	current_spawn_index = (current_spawn_index + 1) % 8  # This cycles back to 0 after 7

# Function to remove a specific request
func _remove_request(request_to_remove: Node) -> void:
	# Remove the request from the scene
	if request_to_remove != null and request_to_remove.is_inside_tree():
		request_to_remove.queue_free()  # Safely remove it from the scene tree

	# Remove the request from the spawned_requests list
	spawned_requests.erase(request_to_remove)

	# Recalculate positions of remaining requests (if needed)
	_recalculate_positions()

# Function to recalculate positions of the remaining requests
func _recalculate_positions() -> void:
	for i in range(spawned_requests.size()):
		var request_instance = spawned_requests[i]
		# Recalculate the position for each request based on the spawn index
		request_instance.position = spawn_positions[i]

# Function called when the spawn timer times out (every 10 seconds or as needed)
func _on_spawn_timer_timeout() -> void:
	_spawn_request()  # Spawn a new request at the updated position

# Function called when the ResetTimer times out (after 25 seconds)
func _on_reset_timer_timeout() -> void:
	# Reset the spawn index to start at the first spot
	current_spawn_index = 0

	# Spawn a new batch of requests without affecting previous ones
	_spawn_request()

	# Restart the spawn timer to continue spawning new requests
	spawn_timer.start()  # Restart the spawn timer

# Function to randomly select 5 distinct food types from the first 10 items in the Gamedata
func _select_random_food_types() -> Array:
	var selected_food_types = []
	var food_count = min(Gamedata.food_types.size(), 10)  # Limit selection to the first 10 food types
	while selected_food_types.size() < 5 and selected_food_types.size() < food_count:
		var random_index = randi() % food_count  # Ensure random selection within bounds of the first 10
		var food_type = Gamedata.food_types[random_index]
		if food_type not in selected_food_types:
			selected_food_types.append(food_type)
	return selected_food_types

# Function to be called when the Faster Timer times out
func _on_faster_timer_timeout() -> void:
	# Reduce the spawn timer and reset timer by 20 seconds
	if spawn_timer.wait_time > 10:
		spawn_timer.wait_time -= 2.5  # Decrease spawn timer by 20 seconds

	if reset_timer.wait_time > 85:
		reset_timer.wait_time -= 20  # Decrease reset timer by 20 seconds

extends Node2D

@export var stove_scene: PackedScene  # Reference to the stove scene (assigned in the Inspector)

var last_stove_position: Vector2
var stove_count_in_row: int = 0
var max_stoves_per_row: int = 5
var row_offset: float = 100  # Adjust this to control the distance between rows
var stove_spacing: float = 100  # Distance between each stove
var first_stove_offset: float = 550  # Adjust this value to move the first stove further to the right
var max_total_stoves: int = 15  # Maximum total number of stoves
var total_stoves_spawned: int = 0  # Counter for the total number of stoves spawned

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Ensure the stove scene is assigned
	if stove_scene:
		# Set initial position for the first stove
		last_stove_position = Vector2(first_stove_offset, get_viewport().get_size().y / 2)  # Start further to the right
		
		# Spawn the first stove at the start of the game
		_spawn_new_stove()
	else:
		print("Error: Stove scene is not assigned.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if a stove prize is collected (this logic will still work if you want to spawn more stoves)
	if Gamedata.food_counts.has("stove") and Gamedata.food_counts["stove"] > 0:
		# If there is a stove in the inventory, spawn a new stove and decrement the count
		_spawn_new_stove()
		Gamedata.food_counts["stove"] -= 1  # Decrement the stove count after spawning
		print("Stove collected! Remaining stoves: " + str(Gamedata.food_counts["stove"]))

# Function to spawn a new stove to the right of the last one, or on a new row after 5 stoves
func _spawn_new_stove() -> void:
	if stove_scene and total_stoves_spawned < max_total_stoves:
		# Instantiate a new stove
		var stove_instance = stove_scene.instantiate()

		# Set the new stove's position
		stove_instance.position = last_stove_position

		# Add the new stove to the scene
		add_child(stove_instance)

		# Update the position for the next stove
		stove_count_in_row += 1
		last_stove_position.x += stove_spacing
		total_stoves_spawned += 1

		# Check if the current row is full (5 stoves)
		if stove_count_in_row >= max_stoves_per_row:
			# Start a new row
			last_stove_position.x = first_stove_offset
			last_stove_position.y += row_offset
			stove_count_in_row = 0

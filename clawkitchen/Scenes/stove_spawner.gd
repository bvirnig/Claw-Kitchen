extends Node2D

# Reference to the stove scene (you should assign this in the Inspector)
@export var stove_scene: PackedScene

# Variable to store the position of the last spawned stove
var last_stove_position: Vector2

# Counter to track the number of stoves in the current row
var stove_count_in_row: int = 0

# The maximum number of stoves per row before moving to the next row
var max_stoves_per_row: int = 5

# Vertical offset for the next row of stoves
var row_offset: float = 100  # Adjust this to control the distance between rows

# Horizontal spacing between stoves
var stove_spacing: float = 100  # Distance between each stove

# How far to the right to place the first stove
var first_stove_offset: float = 550  # Adjust this value to move the first stove further to the right

# Maximum total number of stoves that can be spawned
var max_total_stoves: int = 15

# Counter for the total number of stoves spawned
var total_stoves_spawned: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if a stove scene is assigned
	if stove_scene:
		# Spawn the first stove at a custom offset to the right
		last_stove_position = Vector2(first_stove_offset, get_viewport().get_size().y / 2)  # Start further to the right
		_spawn_new_stove()  # Spawn the first stove
	else:
		print("Error: Stove scene is not assigned.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Detect if the "0" key was just pressed and if we haven't reached the maximum number of stoves
	if Input.is_action_just_pressed("zero") and total_stoves_spawned < max_total_stoves:
		print("0 key pressed, spawning new stove...")
		_spawn_new_stove()

	# If food is collected (check GameData), spawn a new stove
	if Gamedata.food_collected + 1 > total_stoves_spawned:
		print("Food collected! Spawning a new stove...")
		_spawn_new_stove()

# Function to spawn a new stove to the right of the last one, or on a new row after 5 stoves
func _spawn_new_stove() -> void:
	# Check if a stove scene is assigned and if we haven't reached the total stove limit
	if stove_scene and total_stoves_spawned < max_total_stoves:
		print("Spawning new stove at position: ", last_stove_position)
		# Instantiate a new stove
		var stove_instance = stove_scene.instantiate()

		# Set the new stove's position
		stove_instance.position = last_stove_position

		# Add the new stove to the scene
		add_child(stove_instance)

		# Update the position for the next stove
		stove_count_in_row += 1  # Increment stove counter for the current row
		last_stove_position.x += stove_spacing  # Move the position to the right

		# Increment total stove counter
		total_stoves_spawned += 1

		# Check if the current row is full (5 stoves)
		if stove_count_in_row >= max_stoves_per_row:
			# Start a new row: reset x to the leftmost position and move y down
			last_stove_position.x = first_stove_offset  # Reset x to the custom right position
			last_stove_position.y += row_offset  # Move down by the row offset
			stove_count_in_row = 0  # Reset stove counter for the new row

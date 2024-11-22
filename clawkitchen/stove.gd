extends Area2D

@export var prize_scene: PackedScene  # Reference to the prize scene (the food you want to spawn)
var current_capacity: int = 0
var max_capacity: int = 4
var food2cook_spawner: Node  # Reference to Food2CookSpawner

# Track the current collision shape index for food placement
var current_collision_shape_index : int = 0

# Will store all collision shape global positions
var collision_shapes_positions : Array = []

# Add an ID for each stove to uniquely identify it
@export var stove_id: int  # Unique identifier for this stove, set manually or dynamically

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optional: Print initial state
	print("Stove %d ready! Current capacity: %d, Max capacity: %d", stove_id, current_capacity, max_capacity)

	# Find the Food2CookSpawner node in the scene
	food2cook_spawner = $Food2CookSpawner  # Change path to your actual scene structure
	if food2cook_spawner == null:
		print("Error: food2cook_spawner is not found!")

	# Add this stove to the array and track its information
	collision_shapes_positions = get_collision_shapes_positions()
	print("Collision shapes positions for stove %d: ", stove_id, collision_shapes_positions)

# Function to get the global positions of all the CollisionShape2D nodes of the stove
func get_collision_shapes_positions() -> Array:
	var collision_shapes_positions : Array = []
	
	# Loop through all children to find the CollisionShape2D nodes
	for child in get_children():
		if child is CollisionShape2D:
			# Store the global position of each CollisionShape2D
			print("Child CollisionShape2D local position: ", child.position)
			print("Child CollisionShape2D global position: ", child.global_position)
			collision_shapes_positions.append(child.position)

	# Make sure we found the correct number of collision shapes (4 in this case)
	if collision_shapes_positions.size() != 4:
		print("Warning: Expected 4 CollisionShape2D nodes, found %d", collision_shapes_positions.size())
	
	return collision_shapes_positions

# Called to handle all input events globally (including clicks outside the stove)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Get the mouse position relative to the global coordinates
		var mouse_position = get_global_mouse_position()

		# Debug: Print mouse position when clicked anywhere on screen
		print("Mouse position: ", mouse_position)

		# Get the global position of the stove (ensures correct placement on the screen)
		var stove_global_position = global_position  # The stove's global position

		# Debug: Print the stove's global position
		print("Stove %d global position: ", stove_id, stove_global_position)

		# Ensure GameData is loaded
		if Gamedata == null:
			print("Error: GameData singleton not found!")
			return

		# Get the selected food type from GameData
		var selected_food = Gamedata.get_selected_item()

		# Check if the selected food has been collected (count >= 1)
		if Gamedata.get_food_count(selected_food) >= 1:
			# Ensure food2cook_spawner is valid before calling
			if food2cook_spawner != null:
				# Get the position of the current collision shape for food placement
				var spawn_position = collision_shapes_positions[current_collision_shape_index]

				# Debug: Print the spawn position for the food (from collision shapes)
				print("Stove %d: Spawn position for food: ", stove_id, spawn_position)

				# Instantiate the food at the correct collision shape position
				food2cook_spawner.instantiate_food_at_position(spawn_position)
				
				# Decrease the selected food count by 1 (call the decrement function)
				Gamedata.decrement_food(selected_food, false)  # 'false' indicates it's raw food on the stove
				print("Stove %d: You did it! Here's your food, and your food count has been decremented.", stove_id)
				
				# Move to the next collision shape index (cycle back to 0 after 3)
				current_collision_shape_index = (current_collision_shape_index + 1) % 4
				

				# Ensure only one food item is placed per click. We stop here.
				return  # Exit the function after placing one food item.
			else:
				print("Error: food2cook_spawner is null!")
		else:
			print("Stove %d: You need at least 1 of the selected food to spawn a prize.", stove_id)

# Handling the collision for removing food
func _on_body_entered(body: Node2D) -> void:
	if body is Food:
		body.queue_free()
		print("Stove %d: Food removed from the stove.", stove_id)

extends Area2D

@export var prize_scene: PackedScene  # Reference to the prize scene (the food you want to spawn)
var current_capacity: int = 0
var max_capacity: int = 4
var food2cook_spawner: Node  # Reference to Food2CookSpawner

var collision_shapes_positions: Array = []  # Stores all collision shape global positions
var slot_occupied: Array = []  # Array to track if each slot is occupied (true = occupied, false = free)

@export var stove_id: int  # Unique identifier for this stove, set manually or dynamically

# Flag to prevent multiple food instantiations per click
var player_in_stove: bool = false  # Track whether the player is in the stove area
var is_active_stove: bool = false  # Flag to track if this stove is the active stove

func _ready() -> void:
	print("Stove %d ready! Current capacity: %d, Max capacity: %d", stove_id, current_capacity, max_capacity)

	food2cook_spawner = $Food2CookSpawner
	if food2cook_spawner == null:
		print("Error: food2cook_spawner is not found!")

	collision_shapes_positions = get_collision_shapes_positions()
	print("Collision shapes positions for stove %d: ", stove_id, collision_shapes_positions)

	# Initialize the slot_occupied array with all slots as free (false)
	slot_occupied = []
	for i in range(max_capacity):
		slot_occupied.append(false)

# Get all collision shape positions
func get_collision_shapes_positions() -> Array:
	var collision_shapes_positions: Array = []
	for child in get_children():
		if child is CollisionShape2D:
			collision_shapes_positions.append(child.position)

	if collision_shapes_positions.size() != 4:
		print("Warning: Expected 4 CollisionShape2D nodes, found %d", collision_shapes_positions.size())

	return collision_shapes_positions

# Handle when another object enters the stove's area
func _on_body_entered(body: Node) -> void:
	# Check if the body entering is the player
	if body.name == "Player":
		player_in_stove = true
		is_active_stove = true
		print("Player entered stove %d area. This stove is now active.", stove_id)
		return
	
	# Check if the body entering is an instance of the Food class
	if body is Food:  # Check if the object is an instance of the Food class
		# Find the first free slot and occupy it
		for i in range(max_capacity):
			if !slot_occupied[i]:  # If the slot is free
				slot_occupied[i] = true  # Mark this slot as occupied
				print("Food entered stove %d. Slot %d is now occupied.", stove_id, i)
				break  # Only occupy one slot per food item

# Handle when another object exits the stove's area
func _on_body_exited(body: Node) -> void:
	# Debug to track the exiting body
	print("Body exited stove %d: %s", stove_id, body.name)

	# Check if the body exiting is the player
	if body.name == "Player":
		player_in_stove = false
		is_active_stove = false
		print("Player left stove %d area. This stove is now inactive.", stove_id)
		return
	
	# Check if the body exiting is an instance of the Food class
	if body is Food:  # Check if the object is an instance of the Food class
		# Debug: log the slot occupied before freeing it
		print("Food of type %s exited stove %d. Attempting to free a slot.", body.name, stove_id)
		# Find which slot this food was occupying and free it
		for i in range(max_capacity):
			if slot_occupied[i]:  # If the slot is occupied
				print("Slot %d was occupied. Freeing it now.", i)
				# Reset the slot to free
				slot_occupied[i] = false
				print("Slot %d is now free.", i)
				break  # Only free one slot per food item

# Check for mouse input and spawn food if conditions are met
func _process(delta: float) -> void:
	if is_active_stove and player_in_stove and Input.is_action_just_pressed("mouse_click"):
		var selected_food = Gamedata.get_selected_item()
		print("Selected food: ", selected_food)
		print("Selected food count: ", Gamedata.get_food_count(selected_food))

		if Gamedata.get_food_count(selected_food) >= 1:
			if food2cook_spawner != null:
				# Find the first free slot
				var free_slot_index = -1
				print("Checking for free slots...")
				for i in range(max_capacity):
					if !slot_occupied[i]:  # If slot is free
						free_slot_index = i
						print("Found free slot at index ", i)
						break

				# If there's a free slot available, place food there
				if free_slot_index != -1:
					var spawn_position = collision_shapes_positions[free_slot_index]
					print("Stove %d: Spawn position for food: ", stove_id, spawn_position)

					food2cook_spawner.instantiate_food_at_position(spawn_position, selected_food)

					Gamedata.decrement_food(selected_food, false)
					print("Stove %d: Food count decremented.", stove_id)

					slot_occupied[free_slot_index] = true
					print("Slot %d is now occupied.", free_slot_index)

				else:
					print("Stove %d is full. Cannot place more food.", stove_id)

			else:
				print("Error: food2cook_spawner is null!")

		else:
			print("Stove %d: Not enough food to spawn.", stove_id)

# This function should be called when a food item finishes cooking or is removed from the stove
# It will free up the slot, so food can be placed in that slot again.
func free_up_slot(slot_index: int) -> void:
	if slot_index >= 0 and slot_index < max_capacity:
		slot_occupied[slot_index] = false
		print("Stove %d: Slot %d is now free.", stove_id, slot_index)

# This function will be called when the `queue_frees` signal is emitted from the food2cook_spawner
func _on_food_2_cook_spawner_slot_free(slot_index: int) -> void:
	# Debug: log the received slot index
	print("Food finished cooking and the slot is being freed. Slot index: %d", slot_index)
	# Call the free_up_slot function to unoccupy the slot
	free_up_slot(slot_index)

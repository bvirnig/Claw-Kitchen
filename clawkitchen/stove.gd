extends Area2D

@export var prize_scene: PackedScene  # Reference to the prize scene (the food you want to spawn)
var food2cook_spawner: Node  # Reference to Food2CookSpawner

var collision_shapes_positions: Array = []  # Stores all collision shape global positions
var slot_occupied: Array = []  # Array to track if each slot is occupied (true = occupied, false = free)

@export var stove_id: int  # Unique identifier for this stove, set manually or dynamically

# Flag to prevent multiple food instantiations per click
var player_in_stove: bool = false  # Track whether the player is in the stove area
var is_active_stove: bool = false  # Flag to track if this stove is the active stove

# Track the next slot index for food placement (Cycles through slots)
var next_slot_index: int = 0

# Timer node for periodically freeing up slots
var stove_timer: Timer

# Reference to the AudioStreamPlayer2D for the flame sound
@onready var flame_sound: AudioStreamPlayer2D = $flameSound  # Reference to the flame sound node

func _ready() -> void:
	#print("Stove %d ready! Slots will cycle sequentially.", stove_id)

	food2cook_spawner = $Food2CookSpawner
	if food2cook_spawner == null:
		print("Error: food2cook_spawner is not found!")

	# Initialize the collision shapes for the stove
	collision_shapes_positions = get_collision_shapes_positions()
	#print("Collision shapes positions for stove %d: ", stove_id, collision_shapes_positions)

	# Initialize the slot_occupied array with all slots as free (false)
	slot_occupied = []

	# Add a default number of slots (starting with 4 for simplicity)
	for i in range(4):  # Starting with 4 slots, no fixed limit
		slot_occupied.append(false)

	# Get the reference to the StoveTimer node in the scene
	stove_timer = $StoveTimer
	if stove_timer == null:
		print("Error: StoveTimer not found!")


	# Start the StoveTimer
	stove_timer.start()

# Get all collision shape positions
func get_collision_shapes_positions() -> Array:
	var collision_shapes_positions: Array = []
	for child in get_children():
		if child is CollisionShape2D:
			collision_shapes_positions.append(child.position)

	if collision_shapes_positions.size() != 4:
		#print("Warning: Expected 4 CollisionShape2D nodes, found %d", collision_shapes_positions.size())
		pass
	return collision_shapes_positions

# Handle when another object enters the stove's area
func _on_body_entered(body: Node) -> void:
	# Check if the body entering is the player
	if body.name == "Player":
		player_in_stove = true
		is_active_stove = true
		#print("Player entered stove %d area. This stove is now active.", stove_id)
		return
	
	# Check if the body entering is an instance of the Food class
	if body is Food:  # Check if the object is an instance of the Food class
		# Find the next available slot and occupy it
		var free_slot_index = find_next_slot()
		if free_slot_index != -1:  # If there is an available slot
			slot_occupied[free_slot_index] = true  # Mark this slot as occupied
			body.occupied_slot_index = free_slot_index  # Store the occupied slot index in the food
			print("Food entered stove %d. Slot %d is now occupied.", stove_id, free_slot_index)
		else:
			#print("Stove %d is full. Cannot place more food.", stove_id)
			pass

# Find the next available slot in a cyclic manner
func find_next_slot() -> int:
	# Search for the next free slot in a cyclic manner, even if all slots are occupied
	for i in range(len(slot_occupied)):
		var current_slot = (next_slot_index + i) % len(slot_occupied)
		if !slot_occupied[current_slot]:  # If the slot is free
			next_slot_index = (current_slot + 1) % len(slot_occupied)  # Update next slot for next food
			return current_slot
	
	# If all slots are occupied, return -1 (though the code will attempt to reuse slots anyway)
	return -1

# Handle when another object exits the stove's area
func _on_body_exited(body: Node) -> void:
	# Debug to track the exiting body
	#print("Body exited stove %d: %s", stove_id, body.name)

	# Check if the body exiting is the player
	if body.name == "Player":
		player_in_stove = false
		is_active_stove = false
		#print("Player left stove %d area. This stove is now inactive.", stove_id)
		return
	
	# Check if the body exiting is an instance of the Food class
	if body is Food:  # Check if the object is an instance of the Food class
		# Debug: log the slot occupied before freeing it
		#print("Food of type %s exited stove %d. Attempting to free a slot.", body.name, stove_id)
		
		# Free the slot occupied by the food
		free_up_slot(body.occupied_slot_index)
		#print("Slot %d is now free.", body.occupied_slot_index)

# This function will free up the slot when food exits
func free_up_slot(slot_index: int) -> void:
	if slot_index >= 0 and slot_index < len(slot_occupied):
		slot_occupied[slot_index] = false  # Mark the slot as free
		#print("Stove %d: Slot %d is now free.", stove_id, slot_index)

# The function to free up one slot every time the StoveTimer's timeout signal is emitted
func _on_stove_timer_timeout() -> void:
	# Try to find an occupied slot and free it
	for i in range(len(slot_occupied)):
		if slot_occupied[i]:
			free_up_slot(i)
			return  # Only free one slot per timer interval


func _process(delta: float) -> void:
	if is_active_stove and player_in_stove and Input.is_action_just_pressed("mouse_click"):
		var selected_food = Gamedata.get_selected_item()

		# Ensure there is enough food to place on the stove
		if Gamedata.get_food_count(selected_food) >= 1:
			if food2cook_spawner != null:
				# Find the next available slot
				var free_slot_index = find_next_slot()
				if free_slot_index != -1:
					var spawn_position = collision_shapes_positions[free_slot_index]
					#print("Stove %d: Spawn position for food: ", stove_id, spawn_position)

					# Instantiate the food at the spawn position
					food2cook_spawner.instantiate_food_at_position(spawn_position, selected_food)

					# Decrement the food count after the food has been successfully placed on the stove
					Gamedata.decrement_food(selected_food, false)  # Only decrement once here
					#print("Stove %d: Food count decremented.", stove_id)

					# Mark the slot as occupied
					slot_occupied[free_slot_index] = true

					# Play the flame sound
					if flame_sound:
						flame_sound.play()  # Play the flame sound when food is placed on the stove

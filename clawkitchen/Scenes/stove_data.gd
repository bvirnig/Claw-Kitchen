extends Node

# Dictionary to store the state of each stove, keyed by stove_id
var stove_data: Dictionary = {}

# Initialize stove data for a specific stove with max_capacity
func set_stove_capacity(stove_id: int, max_capacity: int) -> void:
	if not stove_data.has(stove_id):
		# Create the "occupied_slots" array with the correct capacity
		var occupied_slots = Array()
		occupied_slots.resize(max_capacity)  # Resize to the number of slots needed
		occupied_slots.fill(false)  # Fill with "false" values to represent free slots

		stove_data[stove_id] = {
			"max_capacity": max_capacity,
			"occupied_slots": occupied_slots,
			"used_capacity": 0  # Track the number of slots occupied (used capacity)
		}

# Find the first free slot
func find_free_slot(stove_id: int) -> int:
	if stove_data.has(stove_id):
		for i in range(stove_data[stove_id]["max_capacity"]):
			if !stove_data[stove_id]["occupied_slots"][i]:  # If slot is free
				return i
	return -1  # No free slot

# Set a specific slot as occupied or free
func set_slot_occupied(stove_id: int, slot_index: int, occupied: bool) -> void:
	if stove_data.has(stove_id):
		stove_data[stove_id]["occupied_slots"][slot_index] = occupied
		# Update used capacity if a slot is marked as occupied
		if occupied:
			stove_data[stove_id]["used_capacity"] += 1
		else:
			stove_data[stove_id]["used_capacity"] -= 1

# Free a specific slot
func free_up_slot(stove_id: int, slot_index: int) -> void:
	if stove_data.has(stove_id):
		stove_data[stove_id]["occupied_slots"][slot_index] = false
		# Decrease used capacity when a slot is freed
		stove_data[stove_id]["used_capacity"] -= 1
		print("Slot %d freed for stove %d. Used capacity: %d / %d (Max Capacity)", slot_index, stove_id, stove_data[stove_id]["used_capacity"], stove_data[stove_id]["max_capacity"])

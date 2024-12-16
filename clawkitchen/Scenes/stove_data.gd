extends Node

var stove_data: Dictionary = {}


func set_stove_capacity(stove_id: int, max_capacity: int) -> void:
	if not stove_data.has(stove_id):
		var occupied_slots = Array()
		occupied_slots.resize(max_capacity) 
		occupied_slots.fill(false) 

		stove_data[stove_id] = {
			"max_capacity": max_capacity,
			"occupied_slots": occupied_slots,
			"used_capacity": 0  
		}

func find_free_slot(stove_id: int) -> int:
	if stove_data.has(stove_id):
		for i in range(stove_data[stove_id]["max_capacity"]):
			if !stove_data[stove_id]["occupied_slots"][i]:  # If slot is free
				return i
	return -1  


func set_slot_occupied(stove_id: int, slot_index: int, occupied: bool) -> void:
	if stove_data.has(stove_id):
		stove_data[stove_id]["occupied_slots"][slot_index] = occupied
		if occupied:
			stove_data[stove_id]["used_capacity"] += 1
		else:
			stove_data[stove_id]["used_capacity"] -= 1

# Free a specific slot
func free_up_slot(stove_id: int, slot_index: int) -> void:
	if stove_data.has(stove_id):
		stove_data[stove_id]["occupied_slots"][slot_index] = false
		stove_data[stove_id]["used_capacity"] -= 1
		

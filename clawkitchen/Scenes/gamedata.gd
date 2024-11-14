extends Node

@export var food_textures: Array = []  # Array of textures for each food type

# Dictionary to track food types and their counts
var food_counts: Dictionary = {
	"beef": 0,
	"cheese": 0,
	"potato": 0,
	"stove": 0  # Add more food types as needed
}

# Dictionary to track cooked food counts by type
var cooked_food_counts: Dictionary = {
	"beef": 0,
	"cheese": 0,
	"potato": 0,
	"stove": 0  # Add more food types as needed
}

var food_collected: int = 0
var selected_item_index: int = 0
var food_types: Array = [
	"beef",
	"cheese",
	"potato",
	"stove"
]

# Method to increment the food count for a specific type
func collect_food(food_type: String) -> void:
	if food_counts.has(food_type):
		food_counts[food_type] += 1
	else:
		food_counts[food_type] = 1
	food_collected += 1
	print("Collected a " + food_type + "! Total: " + str(food_counts[food_type]))

# Method to increment the cooked food count for a specific type
func cook_food(food_type: String) -> void:
	if cooked_food_counts.has(food_type):
		cooked_food_counts[food_type] += 1
	else:
		cooked_food_counts[food_type] = 1
	print("Cooked a " + food_type + "! Total cooked: " + str(cooked_food_counts[food_type]))

# Method to get the count of a specific food type
func get_food_count(food_type: String) -> int:
	return food_counts.get(food_type, 0)

# Method to get the count of a specific cooked food type
func get_cooked_food_count(food_type: String) -> int:
	return cooked_food_counts.get(food_type, 0)

# Method to decrement the food count for a specific type
func decrement_food(food_type: String) -> void:
	if food_counts.has(food_type) and food_counts[food_type] > 0:
		food_counts[food_type] -= 1
		print(food_type + " count decremented. Remaining: " + str(food_counts[food_type]))
	else:
		print("Error: No " + food_type + " left to decrement!")

# Get the selected food texture based on the selected item index
func get_selected_item() -> String:
	if selected_item_index >= 0 and selected_item_index < food_types.size():
		return food_types[selected_item_index]
	else:
		return ""  # Return an empty string if index is out of bounds

# Set the selected food item by its index
func set_selected_item_by_index(index: int) -> void:
	if index >= 0 and index < food_types.size():
		selected_item_index = index
		print("Selected item set to: " + food_types[selected_item_index])

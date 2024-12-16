extends Node

@export var food_textures: Array = []  # Array of textures for each food type

# Updated food types and counts
var food_counts: Dictionary = {
	"cheese": 0,
	"potato": 0,
	"mushroom": 0,
	"bell_pepper": 0,
	"butter": 0,
	"olive_oil": 0,
	"beef": 0,
	"fish": 0,
	"red_wine": 0,
	"white_wine": 0,
	"stove": 0,
	"bomb": 0,  # Added bomb food type
	"energy_boost": 0  # Added energy_boost food type
}

# Updated cooked food counts
var cooked_food_counts: Dictionary = {
	"cheese": 0,
	"potato": 0,
	"mushroom": 0,
	"bell_pepper": 0,
	"butter": 0,
	"olive_oil": 0,
	"beef": 0,
	"fish": 0,
	"red_wine": 0,
	"white_wine": 0,
	"stove": 0,
	"bomb": 0,  # Added bomb cooked food count
	"energy_boost": 0  # Added energy_boost cooked food count
}

var food_collected: int = 0
var selected_item_index: int = 0
var food_types: Array = [
	"cheese", "potato", "mushroom", "bell_pepper", "butter", "olive_oil", 
	"beef", "fish", "red_wine", "white_wine", "stove", "bomb", "energy_boost"
]

var cooked_food_types: Array = [
	"cooked_potato", "cooked_mushroom", "cooked_bell_pepper", "cooked_butter", "cooked_olive_oil", 
	"cooked_beef", "cooked_fish", "cooked_red_wine", "cooked_white_wine"
]

# Updated cooking times for each food type
var cooking_times: Dictionary = {
	"cheese": 3.0,  # Cheese takes 3 seconds
	"potato": 4.0,   # Potato takes 4 seconds
	"mushroom": 3.5, # Mushroom takes 3.5 seconds
	"bell_pepper": 2.5, # Bell pepper takes 2.5 seconds
	"butter": 2.0,   # Butter takes 2 seconds
	"olive_oil": 1.5, # Olive oil takes 1.5 seconds
	"beef": 5.0,     # Beef takes 5 seconds
	"fish": 4.0,     # Fish takes 4 seconds
	"red_wine": 3.0, # Red wine takes 3 seconds
	"white_wine": 3.0, # White wine takes 3 seconds
	"stove": 2.0,     # Stove-related dishes take 2 seconds
	"bomb": 0.0,  # Bomb doesn't need cooking time
	"energy_boost": 1.0  # Set cooking time for energy boost (example: 1 second)
}

# Counter for completed orders
var completed_orders_count: int = 0  # Keeps track of the number of completed orders

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
	# No cooking for bomb, so we'll return immediately if it's a bomb
	if food_type == "bomb":
		print("Cannot cook a bomb!")
		return
	
	if food_type == "energy_boost":
		print("Energy Boost is ready! Instant item!")
		return
	
	if cooked_food_counts.has(food_type):
		cooked_food_counts[food_type] += 1
	else:
		cooked_food_counts[food_type] = 1
	print("Cooked a " + food_type + "! Total cooked: " + str(cooked_food_counts[food_type]))

func increment_completed_orders() -> void:
	completed_orders_count += 1
	print("Completed Orders: " + str(completed_orders_count))

func get_food_count(food_type: String) -> int:
	return food_counts.get(food_type, 0)

func get_cooked_food_count(food_type: String) -> int:
	return cooked_food_counts.get(food_type, 0)

func decrement_food(food_type: String, is_cooked: bool) -> void:
	# No decrementing of bomb or energy_boost if cooked, as they're not cooked
	if food_type == "bomb" or food_type == "energy_boost":
		print("Cannot decrement bomb or energy boost from cooked food!")
		return
	
	var target_dict = food_counts if not is_cooked else cooked_food_counts
	if target_dict.has(food_type) and target_dict[food_type] > 0:
		target_dict[food_type] -= 1
		print(food_type + " count decremented. Remaining: " + str(target_dict[food_type]))
	else:
		print("Error: No " + food_type + " left to decrement!")

func get_cooking_time(food_type: String) -> float:
	if food_type == "bomb":
		return -1 
	return cooking_times.get(food_type, 0.0) 

func get_selected_item() -> String:
	if selected_item_index >= 0 and selected_item_index < food_types.size():
		return food_types[selected_item_index]
	else:
		return "" 

# Set the selected food item by its index
func set_selected_item_by_index(index: int) -> void:
	if index >= 0 and index < food_types.size():
		selected_item_index = index
	


func get_food_types() -> Array:
	return food_types


func get_food_textures() -> Array:
	return food_textures

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

# Dictionary to define recipes
var recipes: Dictionary = {
	"beef_cheese_burger": {
		"beef": 1,  # 1 beef needed
		"cheese": 1,  # 1 cheese needed
		"potato": 0  # no potato needed
	},
	"cheese_fries": {
		"cheese": 1,
		"potato": 1
	},
	"stove_dish": {
		"beef": 1,
		"stove": 1
	}
}

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

# Generalized method to decrement the food count for either raw or cooked food
func decrement_food(food_type: String, is_cooked: bool) -> void:
	var target_dict = food_counts if not is_cooked else cooked_food_counts
	if target_dict.has(food_type) and target_dict[food_type] > 0:
		target_dict[food_type] -= 1
		print(food_type + " count decremented. Remaining: " + str(target_dict[food_type]))
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

# Method to check if a recipe can be crafted
func can_craft_recipe(recipe_name: String) -> bool:
	if recipes.has(recipe_name):
		var recipe = recipes[recipe_name]
		
		# Check if we have enough ingredients for the recipe
		for ingredient in recipe.keys():
			var required_amount = recipe[ingredient]
			if ingredient in cooked_food_counts:
				if cooked_food_counts[ingredient] < required_amount:
					return false
			elif ingredient in food_counts:
				if food_counts[ingredient] < required_amount:
					return false
			else:
				return false
		return true
	return false

# Method to craft a recipe
func craft_recipe(recipe_name: String) -> void:
	if can_craft_recipe(recipe_name):
		var recipe = recipes[recipe_name]
		
		# Decrement the ingredients from the respective food counts
		for ingredient in recipe.keys():
			var required_amount = recipe[ingredient]
			if ingredient in cooked_food_counts:
				cooked_food_counts[ingredient] -= required_amount
				print("Used " + str(required_amount) + " " + ingredient + " from cooked food.")
			elif ingredient in food_counts:
				food_counts[ingredient] -= required_amount
				print("Used " + str(required_amount) + " " + ingredient + " from raw food.")
		
		# Optionally, you can add a new crafted item or food item here.
		print("Crafted: " + recipe_name)
	else:
		print("Not enough ingredients to craft: " + recipe_name)

# New method to return the food types (array of food items)
func get_food_types() -> Array:
	return food_types

# New method to return the food textures (you need to fill this array in the Inspector)
func get_food_textures() -> Array:
	return food_textures

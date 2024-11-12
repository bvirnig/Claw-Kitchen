extends Node

# Variable to store the number of collected food items
var food_collected: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function to increment the food count
func collect_food() -> void:
	food_collected += 1
	print("Food collected: " + str(food_collected))  # Optional: print the count to the console

# Function to get the current food count
func get_food_count() -> int:
	return food_collected

# Optional: Reset the food count to 0 (useful for starting a new game or resetting progress)
func reset_food_count() -> void:
	food_collected = 0
	print("Food count reset.")

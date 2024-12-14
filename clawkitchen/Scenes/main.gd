extends Node2D

@onready var food_label = $FoodLabel  # Assuming you have a Label node named FoodLabel in the scene
@onready var cheese_label = $CheeseLabel  # Assuming you have a Label node named CheeseLabel in the scene
@onready var food_label_timer = $FoodLabelTimer  # Assuming you have a Timer node named FoodLabelTimer in the scene

# New labels for each food type (these should not change)
@onready var potato_label = $PotatoLabel  # Potato Label
@onready var mushroom_label = $MushroomLabel  # Mushroom Label
@onready var bell_pepper_label = $BellPepperLabel  # Bell Pepper Label
@onready var butter_label = $ButterLabel  # Butter Label
@onready var olive_oil_label = $OliveOilLabel  # Olive Oil Label
@onready var beef_label = $BeefLabel  # Beef Label
@onready var fish_label = $FishLabel  # Fish Label
@onready var red_wine_label = $RedWineLabel  # Red Wine Label
@onready var white_wine_label = $WhiteWineLabel  # White Wine Label
@onready var inventory_update_timer = $InventoryUpdateTimer  # New Timer node for updating the inventory

# Timer for checking the request label update (every second)
@onready var request_label_check_timer = $RequestLabelCheckTimer  # New Timer node for checking the request label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Initialize the food label with the selected item and its count
	update_food_label()

	# Start the inventory update timer to trigger every 1 second (independent of food_label)
	inventory_update_timer.wait_time = 1.0  # Set interval to 1 second
	inventory_update_timer.start()  # Start the timer

	# Update all food labels immediately
	update_food_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the food counter display by fetching the updated count from GameData
	var food_counter_label = get_node("FoodCounter")
	if food_counter_label:
		food_counter_label.text = "Food Collected: " + str(Gamedata.food_collected)

	# Handle cycling through food types using mouse wheel scroll
	if Input.is_action_just_pressed("mouse_scroll_up"):
		var new_index = (Gamedata.selected_item_index + 1) % Gamedata.food_types.size()
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	elif Input.is_action_just_pressed("mouse_scroll_down"):
		var new_index = (Gamedata.selected_item_index - 1 + Gamedata.food_types.size()) % Gamedata.food_types.size()
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()


# Update the food label to show the selected food and its count
func update_food_label() -> void:
	var selected_item = Gamedata.get_selected_item()  # Get the currently selected food type
	var count = Gamedata.get_food_count(selected_item)  # Get the count for the selected food type
	food_label.text = selected_item + ": " + str(count)  # Update the label with the current count
	
	# Every time the food label is updated, also update the cheese label
	update_cheese_label()

# Update the CheeseLabel with the current number of cheese in inventory
func update_cheese_label() -> void:
	# Fetch the count of "cheese" from the GameData singleton
	var cheese_count = Gamedata.get_food_count("cheese")  # Get the count of cheese
	cheese_label.text = "X " + str(cheese_count)  # Update the label with the current cheese count

# Simulate using cheese for cooking
func use_cheese_for_cooking() -> void:
	# Ensure the player has enough cheese to use
	var cheese_count = Gamedata.get_food_count("cheese")
	if cheese_count > 0:
		# Use one cheese for cooking (you can customize this logic)
		Gamedata.decrease_food_count("cheese", 1)  # Assuming you have a function to decrease the food count
		print("Used one cheese for cooking!")  # Debug message
		
		# Update the cheese label after using it
		update_cheese_label()
		
		# Update the food label after using cheese
		update_food_label()

# Function to be called every 1 second by the timer to update the food label
func _on_food_label_timer_timeout() -> void:
	update_food_label()

# Update the food labels for all food types dynamically (Restoring these back to the original state)
func update_food_labels() -> void:
	# Loop through all food types in Gamedata
	var food_types = Gamedata.food_types
	for food_type in food_types:
		# Get the current count of the food type from Gamedata
		var food_count = Gamedata.get_food_count(food_type)

		# Update the labels for each food type dynamically
		match food_type:
			"cheese":
				if cheese_label: cheese_label.text = "X " + str(food_count)
			"potato":
				if potato_label: potato_label.text = "X " + str(food_count)
			"mushroom":
				if mushroom_label: mushroom_label.text = "X " + str(food_count)
			"bell_pepper":
				if bell_pepper_label: bell_pepper_label.text = "X " + str(food_count)
			"butter":
				if butter_label: butter_label.text = "X " + str(food_count)
			"olive_oil":
				if olive_oil_label: olive_oil_label.text = "X " + str(food_count)
			"beef":
				if beef_label: beef_label.text = "X " + str(food_count)
			"fish":
				if fish_label: fish_label.text = "X " + str(food_count)
			"red_wine":
				if red_wine_label: red_wine_label.text = "X " + str(food_count)
			"white_wine":
				if white_wine_label: white_wine_label.text = "X " + str(food_count)

# Called when the food enters the collection bin
func _on_collection_bin_body_entered(body: Node2D) -> void:
	if body is Food:
		# Collect the food in the GameData singleton
		body.collect()  # Call the Food's collect method
		
		# Pass the food's type to collect_food function in GameData
		Gamedata.collect_food(body.food_type)  # Pass the food type from the body (the Food object)
		
		print("Collected food: ", body.food_type)  # Debug output

		# Update both the FoodLabel and CheeseLabel
		update_food_labels()  # This updates all food-related labels

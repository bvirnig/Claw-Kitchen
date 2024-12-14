extends Node2D

@onready var inventory_update_timer = $InventoryUpdateTimer  # New Timer node for updating the inventory
@onready var request_label_check_timer = $RequestLabelCheckTimer  # New Timer node for checking the request label
@onready var raw_food_gui = $RawGUI  # Reference to RawFoodGUI scene where labels are handled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start the inventory update timer to trigger every 1 second (independent of food_label)
	inventory_update_timer.wait_time = 1.0  # Set interval to 1 second
	inventory_update_timer.start()  # Start the timer

	# Update all food labels immediately by calling the update method in RawFoodGUI
	raw_food_gui.update_food_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the food counter display by fetching the updated count from GameData
	var food_counter_label = get_node("FoodCounter")
	if food_counter_label:
		food_counter_label.text = "Food Collected: " + str(Gamedata.food_collected)

	# Handle cycling through food types using mouse wheel scroll
	if Input.is_action_just_pressed("mouse_scroll_up"):
		# Cycle up, but restrict to the first 10 items
		var new_index = (Gamedata.selected_item_index + 1) % min(Gamedata.food_types.size(), 10)
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	elif Input.is_action_just_pressed("mouse_scroll_down"):
		# Cycle down, but restrict to the first 10 items
		var new_index = (Gamedata.selected_item_index - 1 + Gamedata.food_types.size()) % min(Gamedata.food_types.size(), 10)
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

# Update the food label to show the selected food and its count
func update_food_label() -> void:
	var selected_item = Gamedata.get_selected_item()  # Get the currently selected food type
	var count = Gamedata.get_food_count(selected_item)  # Get the count for the selected food type
	# Assuming that the food label is part of RawFoodGUI and will be updated from there
	raw_food_gui.update_food_labels()

# Called when the food enters the collection bin
func _on_collection_bin_body_entered(body: Node2D) -> void:
	if body is Food:
		# Collect the food in the GameData singleton
		body.collect()  # Call the Food's collect method
		
		# Pass the food's type to collect_food function in GameData
		Gamedata.collect_food(body.food_type)  # Pass the food type from the body (the Food object)
		
		print("Collected food: ", body.food_type)  # Debug output

		# Update both the FoodLabel and CheeseLabel via the RawFoodGUI
		raw_food_gui.update_food_labels()  # This updates all food-related labels

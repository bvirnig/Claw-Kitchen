extends Node2D

@onready var inventory_update_timer = $InventoryUpdateTimer  # New Timer node for updating the inventory
@onready var request_label_check_timer = $RequestLabelCheckTimer  # New Timer node for checking the request label
@onready var raw_food_gui = $RawGUI  # Reference to RawFoodGUI scene where labels are handled
@onready var collectSound = $collectSound  # Reference to the AudioStreamPlayer2D node for playing sound
@onready var game_timer = $GameTimer  # Reference to GameTimer node
@onready var game_timer_label = $GameTimerCountdownLabel  # Reference to the GameTimerCountdownLabel node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start the inventory update timer to trigger every 1 second (independent of food_label)
	inventory_update_timer.wait_time = 1.0  # Set interval to 1 second
	inventory_update_timer.start()  # Start the timer

	# Update all food labels immediately by calling the update method in RawFoodGUI
	raw_food_gui.update_food_labels()

	# Start the GameTimer (if necessary)
	game_timer.start()  # Starts the GameTimer node (ensure it has a wait_time set if you want to count down)

	# Update GameTimer label immediately with current countdown
	update_game_timer_label()

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
		# Decrement index and wrap around if it goes below 0
		var new_index = Gamedata.selected_item_index - 1
		if new_index < 0:
			new_index = min(Gamedata.food_types.size(), 10) - 1  # Wrap to the last valid index (size capped to 10)
		
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	# Update the GameTimer label every frame
	update_game_timer_label()

# Update the food label to show the selected food and its count
func update_food_label() -> void:
	var selected_item = Gamedata.get_selected_item()  # Get the currently selected food type
	var count = Gamedata.get_food_count(selected_item)  # Get the count for the selected food type
	# Assuming that the food label is part of RawFoodGUI and will be updated from there
	raw_food_gui.update_food_labels()

# Update the GameTimer countdown label
func update_game_timer_label() -> void:
	# Get the remaining time from the GameTimer node
	var remaining_time = game_timer.time_left  # Get the remaining time in seconds
	if game_timer_label:
		game_timer_label.text = "Time Left: " + str(int(remaining_time))  # Update label with countdown
	else:
		print("Error: GameTimerCountdownLabel not found!")
		
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

		# Play the collection sound when food is collected
		collectSound.play()  # Play the sound

extends Node2D

@onready var food_label = $FoodLabel  # Assuming you have a Label node named FoodLabel in the scene
@onready var request_label = $RequestLabel  # Assuming you have a Label node named RequestLabel in the scene
@onready var request_timer = $RequestTimer  # Assuming you have a Timer node named RequestTimer in the scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure GameData is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return

	# Initialize the food label with the selected item and its count
	update_food_label()

	# Initialize the request label with a random food request
	update_request_label()

	# Set the timer to repeat every 10 seconds and start it
	request_timer.wait_time = 10.0  # Set the timer's interval to 10 seconds
	request_timer.start()  # Start the timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the food counter display by fetching the updated count from GameData
	var food_counter_label = get_node("FoodCounter")
	if food_counter_label:
		food_counter_label.text = "Food Collected: " + str(Gamedata.food_collected)

	# Handle cycling through food types
	if Input.is_action_just_pressed("ui_up"):
		# Move up through the food types array
		var new_index = (Gamedata.selected_item_index + 1) % Gamedata.food_types.size()
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	elif Input.is_action_just_pressed("ui_down"):
		# Move down through the food types array
		var new_index = (Gamedata.selected_item_index - 1 + Gamedata.food_types.size()) % Gamedata.food_types.size()
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	# Detect if the "0" key is pressed to restart the game
	if Input.is_action_just_pressed("ui_cancel"):  # Replace "ui_cancel" with the input action of your choice
		restart_game()

# Update the food label to show the selected food and its count
func update_food_label() -> void:
	var selected_item = Gamedata.get_selected_item()  # Get the currently selected food type
	var count = Gamedata.get_food_count(selected_item)  # Get the count for the selected food type
	food_label.text = selected_item + ": " + str(count)  # Update the label with the current count

# Update the request label with a random food item from the first three items
func update_request_label() -> void:
	# Ensure Gamedata is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return
	
	# Only select from the first three items in food_types
	var requestable_food_types = Gamedata.food_types.slice(0, 3)
	var random_food = requestable_food_types[randi() % requestable_food_types.size()]

	# Set the request label's text to ask for the random food item
	request_label.text = "Requesting: " + random_food

# Called when the food enters the collection bin
func _on_collection_bin_body_entered(body: Node2D) -> void:
	if body is Food:
		# Collect the food in the GameData singleton
		body.collect()  # Call the Food's collect method
		
		# Pass the food's type to collect_food function in GameData
		Gamedata.collect_food(body.food_type)  # Pass the food type from the body (the Food object)
		
		print("Total food collected in GameData: ", Gamedata.food_collected)  # Debug output

# Restart the game by reloading the current scene
func restart_game() -> void:
	print("Restarting the game...")  # Debug message
	get_tree().reload_current_scene()  # Reloads the current scene, effectively restarting the game

# Timer timeout callback to update the request label with a new random food request
func _on_request_timer_timeout() -> void:
	update_request_label()

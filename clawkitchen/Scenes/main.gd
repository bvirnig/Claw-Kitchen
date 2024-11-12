extends Node2D

# Reference to the GameData singleton
# (No need to declare it as a Node since it's an Autoload singleton now)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure GameData is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return

	# Create and add a label to display the collected food count
	var food_counter_label = Label.new()
	food_counter_label.name = "FoodCounter"
	food_counter_label.position = Vector2(10, 10)  # Position the label at the top-left
	food_counter_label.text = "Food Collected: " + str(Gamedata.food_collected)  # Initialize with the current count
	add_child(food_counter_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the food counter display by fetching the updated count from GameData
	var food_counter_label = get_node("FoodCounter")
	if food_counter_label:
		food_counter_label.text = "Food Collected: " + str(Gamedata.food_collected)

# Called when the food enters the collection bin
func _on_collection_bin_body_entered(body: Node2D) -> void:
	if body is Food:
		# Collect the food in the GameData singleton
		body.collect()  # Call the Food's collect method
		Gamedata.collect_food()  # Increment the food count in the GameData singleton
		print("Total food collected in GameData: ", Gamedata.food_collected)  # Debug output

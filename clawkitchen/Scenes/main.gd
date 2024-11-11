extends Node2D

# Keep track of the food collected
var food_collected: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create and add a label to display the collected food count
	var food_counter_label = Label.new()
	food_counter_label.name = "FoodCounter"
	food_counter_label.position = Vector2(10, 10)  # Position the label at the top-left
	food_counter_label.text = "Food Collected: " + str(food_collected)
	add_child(food_counter_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the food counter display
	var food_counter_label = get_node("FoodCounter")
	if food_counter_label:
		food_counter_label.text = "Food Collected: " + str(food_collected)

# Called when the food enters the collection bin
func _on_collection_bin_body_entered(body: Node2D) -> void:
	if body is Food:
		body.collect()  # Collect the food
		food_collected += 1  # Increment the food collected counter
		print("Total food collected: ", food_collected)  # Debug output

extends Node2D

@export var food_scene: PackedScene  # The scene to be instantiated for food
var stove_positions: Array = []  # To store positions of all stoves

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Ensure GameData is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return

	# Ensure there are stoves spawned before proceeding
	if stove_positions.size() == 0:
		print("Error: No stoves are available to spawn food on!")
		return

	# Debug: Print stove positions for verification
	print("Stove positions: ", stove_positions)

# Function to instantiate the selected food at a given position
func instantiate_food_at_position(position: Vector2) -> void:
	# Ensure GameData is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return
	
	# Fetch the food types and textures from GameData
	var food_types = Gamedata.get_food_types()  # Assuming GameData has a method to get food types
	var food_textures = Gamedata.get_food_textures()  # Assuming GameData has a method to get food textures

	# Get the selected food from GameData
	var selected_food = Gamedata.get_selected_item()

	# Ensure the selected food exists in the food_types array
	var selected_food_index = food_types.find(selected_food)
	if selected_food_index == -1:
		print("Error: Selected food not found in food_types!")
		return

	# Get the texture for the selected food
	var selected_texture = food_textures[selected_food_index]

	# Debug: Print the food selection and texture
	print("Selected food: ", selected_food, " Texture: ", selected_texture)

	# Instantiate the food item from the scene (the food is the same for all types)
	var food_instance = food_scene.instantiate()

	# Ensure food_instance has the Sprite2D node
	var sprite_node = food_instance.get_node("Sprite2D")
	if sprite_node == null:
		print("Error: No Sprite2D node found in food scene!")
		return

	# Set the texture for the food item
	sprite_node.texture = selected_texture

	# Set the food's position to the stove's global position (or collision shape position)
	food_instance.position = position

	# Debug: Print the food spawn position
	print("Food spawned at position: ", position)

	# Add the food item to the scene
	get_parent().add_child(food_instance)  # Assuming this is a child of the main scene
	food_instance.add_to_group("food")  # Optional: Add to group for easy management

	# Add a timer for this specific food instance
	add_timer_to_food(food_instance, selected_food)

# Function to add a timer to the food item
func add_timer_to_food(food_instance: Node, food_type: String) -> void:
	# Create a new Timer node for this food instance
	var timer = Timer.new()

	# Set the timer duration based on the food type from GameData
	var cook_time = Gamedata.get_cooking_time(food_type)
	timer.wait_time = cook_time
	timer.one_shot = true  # Ensures the timer stops after 1 cycle

	# Add the timer as a child of the food instance (so it stays with it)
	food_instance.add_child(timer)

	# Connect the timer's timeout signal to a custom callback
	timer.connect("timeout", Callable(self, "_on_food_cook_timeout").bind(food_instance))

	# Start the timer
	timer.start()

# Callback function when the timer times out (after cooking time)
func _on_food_cook_timeout(food_instance: Node) -> void:
	# Mark the food as cooked or free it
	if Gamedata != null:
		var food_type = Gamedata.get_selected_item()  # Assuming selected_item is still the same
		Gamedata.cook_food(food_type)
		print("Cooked food: ", food_type)

	# Remove the food instance from the scene
	food_instance.queue_free()
	print("Food instance freed after cooking.")

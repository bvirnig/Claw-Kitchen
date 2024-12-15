extends Node

@export var food_scene: PackedScene  # The scene to be instantiated for food
signal addcookedfood

@onready var orderUpSound: AudioStreamPlayer2D = $orderUpSound # Reference to the AudioStreamPlayer2D node (yumSound)

# Function to instantiate the selected food at a given position
func instantiate_food_at_position(position: Vector2, selected_food: String) -> void:
	# Ensure GameData is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return
	
	# Fetch the food types and textures from GameData
	var food_types = Gamedata.get_food_types()  # This should now work
	var food_textures = Gamedata.get_food_textures()  # This should now work

	# Get the selected food from GameData
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

	# Set the food's position to the provided position (from the stove clicked)
	food_instance.position = position

	# Debug: Print the food spawn position
	print("Food spawned at position: ", position)

	# Add the food item to the scene
	get_parent().add_child(food_instance)  # Assuming this is a child of the main scene
	food_instance.add_to_group("food")  # Optional: Add to group for easy management

	# Decrement the uncooked food count (because the food is now on the stove)
	# Gamedata.decrement_food(selected_food, false)  # False for uncooked food

	# Add a timer for this specific food instance (optional)
	add_timer_to_food(food_instance, selected_food)

# Function to add a timer to the food item (optional)
func add_timer_to_food(food_instance: Node, food_type: String) -> void:
	var timer = Timer.new()
	var cook_time = Gamedata.get_cooking_time(food_type)
	timer.wait_time = cook_time
	timer.one_shot = true

	food_instance.add_child(timer)
	timer.connect("timeout", Callable(self, "_on_food_cook_timeout").bind(food_instance, food_type))  # Pass the food_type to the timeout function
	timer.start()

func _on_food_cook_timeout(food_instance: Node, food_type: String) -> void:
	# Increment the cooked food count in Gamedata when food is cooked
	Gamedata.cook_food(food_type)  # This method should handle the increment for cooked food counts
	
	# Alternatively, if you need to manually increment the cooked_food_counts:
	# Gamedata.cooked_food_counts[food_type] = Gamedata.cooked_food_counts.get(food_type, 0) + 1

	# Print the food that was cooked
	print("Food cooked: ", food_instance)

	# Play the yumSound when the food is cooked
	if orderUpSound:
		orderUpSound.play()  # Play the sound when food is cooked

	# Queue the food instance for removal from the scene
	food_instance.queue_free()

	# Emit the signal to notify that a slot is free
	emit_signal("addcookedfood")

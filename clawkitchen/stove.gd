extends Area2D

@export var prize_scene: PackedScene  # Reference to the prize scene (the prize you want to spawn)
var current_capacity: int = 0
var max_capacity: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optional: Print initial state
	print("Stove ready! Current capacity: %d, Max capacity: %d", current_capacity, max_capacity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when there is an input event on this Area2D node (e.g., mouse click).
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Print the message when the stove is clicked
		print("Hello, it's me a stove!")

		var mouse_position = get_global_mouse_position()
		
		# Ensure GameData is loaded
		if Gamedata == null:
			print("Error: GameData singleton not found!")
			return
		
		# Get the selected food type from GameData
		var selected_food = Gamedata.get_selected_item()
		
		# Check if the selected food has been collected (count >= 1)
		if Gamedata.get_food_count(selected_food) >= 1:
			# Spawn the prize with the selected food texture if the food count is 1 or more
			spawn_prize(mouse_position, selected_food)
			# Decrease the selected food count by 1
			Gamedata.collect_food(selected_food)
			print("You did it! Here's a prize.")
		else:
			print("You need at least 1 of the selected food to spawn a prize.")

# Function to spawn a prize at a specific position with the selected food texture
func spawn_prize(position: Vector2, selected_food: String) -> void:
	# Ensure GameData is loaded and has food textures
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return
	
	if Gamedata.food_textures.size() == 0:
		print("Error: No food textures found in GameData!")
		return
	
	# Check if the selected food exists in the food_types and food_textures
	var selected_food_index = Gamedata.food_types.find(selected_food)
	if selected_food_index == -1:
		print("Error: Selected food not found in food_types!")
		return
	
	# Get the texture for the selected food
	var selected_texture = Gamedata.food_textures[selected_food_index]
	
	# Instantiate the prize scene (the food prize)
	var prize_instance = prize_scene.instantiate()

	# Set the selected texture for the prize's Sprite
	var sprite = prize_instance.get_node("Sprite2D")  # Assuming the prize has a Sprite2D node
	sprite.texture = selected_texture
	
	# Optionally: Set the food type and texture index for the prize instance
	prize_instance.food_type = selected_food
	prize_instance.texture_index = selected_food_index
	
	# Set the position of the prize
	prize_instance.position = position
	
	# Add the prize instance to the scene
	get_parent().add_child(prize_instance)  # Assuming this is a child of the main scene
	prize_instance.add_to_group("prize")  # Optional: Add to group for easy management

extends Area2D

@export var request_scene: PackedScene  # Assign the Request scene in the inspector
@onready var timer: Timer = $RequestCheckTimer  # Reference to your Timer node in the scene
@onready var sprite2: Sprite2D = $Sprite2D2  # Reference to the second sprite

var requested_food_type: String = ""  # Store the current requested food type
var current_request_instance: Node = null  # To keep track of the current request instance

func _ready() -> void:
	spawn_request()  # Spawn the initial request
	timer.start()  # Start the timer

func _on_request_check_timer_timeout() -> void:
	# Check if there is a cooked version of the requested food in the GameData
	if Gamedata.get_cooked_food_count(requested_food_type) > 0:
		print("Cooked " + requested_food_type + " found in inventory! Resetting request.")
		
		# Queue the current request for removal if it exists
		if current_request_instance != null and current_request_instance.is_inside_tree():
			current_request_instance.queue_free()  # Remove the current request from the scene

		reset_request()  # Reset the request to a new one
	else:
		print("No cooked " + requested_food_type + " found.")
	
	timer.start()  # Restart the timer after each check

func spawn_request() -> void:
	# Ensure the request_scene is valid
	if request_scene == null:
		print("Error: No request scene assigned!")
		return

	# Create an instance of the request scene
	var request_instance = request_scene.instantiate()
	add_child(request_instance)

	# Get the screen size and calculate the adjusted position
	var viewport_rect = get_viewport().get_visible_rect()
	var adjusted_position = Vector2(
		viewport_rect.size.x - 600,  # 550 + 50 = 600 px adjustment to the left
		55  # 35 + 20 = 55 px adjustment downward
	)

	# Adjust position based on the size of the request instance
	var sprite_size = calculate_request_size(request_instance)
	request_instance.position = adjusted_position - Vector2(sprite_size.x / 2, sprite_size.y / 2)  # Center the sprite

	# Get the list of food types that have cooked versions available
	var available_cooked_foods = get_available_cooked_foods()

	if available_cooked_foods.size() > 0:
		# Randomly select a cooked food item
		var random_index = randi() % available_cooked_foods.size()
		requested_food_type = available_cooked_foods[random_index]

		# Get the corresponding texture for the requested food
		var food_textures = Gamedata.get_food_textures()  # Access the singleton directly
		var selected_food_texture = food_textures[Gamedata.food_types.find(requested_food_type)]

		# Set the texture for the second sprite (Sprite2D2)
		set_food_texture(selected_food_texture)

		print("Request spawned for cooked: " + requested_food_type)
	else:
		print("No cooked food available to request!")

	# Keep track of the current request instance
	current_request_instance = request_instance

# Helper function to calculate the size of the request instance based on its sprites
func calculate_request_size(request_instance: Node) -> Vector2:
	var size = Vector2(0, 0)

	# Iterate through the children to find Sprite nodes
	for child in request_instance.get_children():
		if child is Sprite2D:
			var sprite = child as Sprite2D
			size.x = max(size.x, sprite.texture.get_width())
			size.y = max(size.y, sprite.texture.get_height())

	return size

# Function to set the food texture on the second sprite (Sprite2D2)
func set_food_texture(texture: Texture) -> void:
	if sprite2:
		sprite2.texture = texture
	else:
		print("Error: Sprite2 not found!")

# Function to return the list of available cooked food types
func get_available_cooked_foods() -> Array:
	var available_foods = []

	# Check the cooked food counts for each food type
	for food_type in Gamedata.food_types:
		if Gamedata.get_cooked_food_count(food_type) > 0:
			available_foods.append(food_type)

	return available_foods

# Reset the request to a new one
func reset_request() -> void:
	# Clear any existing requests
	for child in get_children():
		child.queue_free()  # Remove old request
	spawn_request()  # Spawn a new request

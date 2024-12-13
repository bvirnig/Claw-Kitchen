extends Node2D

@export var request_scene: PackedScene  # Assign the Request scene in the inspector

func _ready() -> void:
	spawn_request()

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
	request_instance.position = adjusted_position - Vector2(sprite_size.x, 0)  # Offset for sprite size

	# Randomly select one of the first 10 food items
	var food_types = Gamedata.get_food_types()  # Access the singleton directly
	var food_textures = Gamedata.get_food_textures()  # Access the singleton directly
	var random_index = randi() % 10  # Use the first 10 food items
	var selected_food_type = food_types[random_index]
	var selected_food_texture = food_textures[random_index]

	# Pass the texture to the Request instance
	if request_instance.has_method("set_food_texture"):
		request_instance.set_food_texture(selected_food_texture)
	else:
		print("Error: Request instance does not have a 'set_food_texture' method!")

	print("Request spawned for: " + selected_food_type)

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

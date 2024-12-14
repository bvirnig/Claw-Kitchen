extends Area2D

@export var food_type: String  # Define a property to store the food type

# Optionally, you can add any other variables or methods that are needed for your request label

# This function could be used to handle the texture setting for the sprite node
func set_food_texture(texture: Texture) -> void:
	var sprite_node = $Sprite2D2  # Reference to the sprite node in your request label
	if sprite_node:
		sprite_node.texture = texture
	else:
		print("Error: Sprite node not found!")

# Called every frame to check if the food type exists in the cooked_food_counts
func _process(delta: float) -> void:
	# Check if the food type exists in Gamedata's cooked_food_counts and if its amount is >= 1
	if food_type in Gamedata.cooked_food_counts and Gamedata.cooked_food_counts[food_type] >= 1:
		queue_free()  # Remove the request label if the amount is >= 1

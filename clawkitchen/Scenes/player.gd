extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = $Sprite2D  # Reference to the player's Sprite2D node

func _ready() -> void:
	# Set the player's initial position to the mouse position
	position = get_global_mouse_position()

	# Make sure the sprite's anchor point is set correctly (ensure it's centered)
	player_sprite.centered = true  # This ensures the sprite is centered around its position
	
	# Set the player's sprite texture based on the selected item
	set_player_sprite()

func _process(delta: float) -> void:
	# Update the player position based on the mouse position
	position = get_global_mouse_position()

	# Update the player's sprite texture based on the selected item
	set_player_sprite()

# Function to update the player's sprite based on the selected food item
func set_player_sprite() -> void:
	# Get the currently selected item from the gamedata singleton
	var selected_item = Gamedata.get_selected_item()

	# Check if the selected item is valid and has an associated texture (only consider first 10 items)
	if selected_item != "":
		# Retrieve the index of the selected item, but restrict to the first 10 items
		var selected_item_index = Gamedata.food_types.find(selected_item)

		# Ensure that the selected item is within the first 10 food types
		if selected_item_index != -1 and selected_item_index < 10 and selected_item_index < Gamedata.food_textures.size():
			var selected_texture = Gamedata.food_textures[selected_item_index]
			
			# Set the player's sprite texture to the selected texture
			player_sprite.texture = selected_texture
		else:
			print("Error: No valid texture found for selected item: " + selected_item)
	else:
		print("Error: Invalid selected item.")

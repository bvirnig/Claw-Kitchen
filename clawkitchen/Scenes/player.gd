extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = $Sprite2D  # Reference to the player's Sprite2D node

func _ready() -> void:
	# Start by setting the player position to the mouse position
	position = get_global_mouse_position()

	# Set the player's sprite texture to the selected item's texture
	set_player_sprite()

func _process(delta: float) -> void:
	# Directly set the player's position to the current mouse position
	position = get_global_mouse_position()

	# Update the player's sprite based on the selected item in the gamedata singleton
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

# Function to cycle through the first 10 food items
func cycle_selected_item() -> void:
	# Get the current index of the selected item
	var current_index = Gamedata.selected_item_index

	# Increase the index by 1 (or wrap back to 0 if it exceeds the first 10 items)
	current_index = (current_index + 1) % 10

	# Set the selected item index to the new value
	Gamedata.set_selected_item_by_index(current_index)

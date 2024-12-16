extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = $Sprite2D  # Reference to the player's Sprite2D node

func _ready() -> void:
	
	position = get_global_mouse_position()

	player_sprite.centered = true  
	

	set_player_sprite()

func _process(delta: float) -> void:
	position = get_global_mouse_position()

	set_player_sprite()


func set_player_sprite() -> void:
	var selected_item = Gamedata.get_selected_item()

	if selected_item != "":
		var selected_item_index = Gamedata.food_types.find(selected_item)

		if selected_item_index != -1 and selected_item_index < 10 and selected_item_index < Gamedata.food_textures.size():
			var selected_texture = Gamedata.food_textures[selected_item_index]
		
			player_sprite.texture = selected_texture
		else:
			print("Error: No valid texture found for selected item: " + selected_item)
	else:
		print("Error: Invalid selected item.")

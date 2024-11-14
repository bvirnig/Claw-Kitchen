extends Node2D

@export var prize_scene: PackedScene  # The scene to be instanced for the prize
@export var rows: int = 3  # Number of rows to spawn
@export var prizes_per_row: int = 6  # Number of prizes per row
@export var spacing: float = 2.0  # Spacing between prizes

const SCREEN_WIDTH: int = 450  # Fixed screen width
const SCREEN_HEIGHT: int = 648  # Fixed screen height

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_prizes()  # Spawn the prizes when the node is ready

# Function to spawn prizes
func _spawn_prizes() -> void:
	var prize_height = 50  # Assuming each prize has a height of 50 pixels

	# Make sure GameData is loaded
	if Gamedata == null:
		print("Error: GameData singleton not found!")
		return

	# Check if food textures are available in GameData
	if Gamedata.food_textures.size() == 0:
		print("Error: food_textures array is empty in GameData!")
		return

	# Loop to spawn prizes in rows
	for row in range(rows):
		# Calculate the Y position for this row
		var row_y_position = SCREEN_HEIGHT - (row * (prize_height + spacing)) - prize_height

		# Loop to spawn prizes in the row
		for prize_index in range(prizes_per_row):
			# Instantiate the prize from the scene
			var prize_instance = prize_scene.instantiate()

			# Calculate the X position for each prize in the row
			var prize_x_position = (prize_index + 2.7) * (SCREEN_WIDTH / prizes_per_row * 0.7)
			print("Spawning prize at X:", prize_x_position, " Y:", row_y_position)

			# Randomly select a texture from GameData's food textures
			var random_texture = Gamedata.food_textures[randi() % Gamedata.food_textures.size()]
			print("Selected texture:", random_texture)

			# Ensure prize_instance has the Sprite2D node
			var sprite_node = prize_instance.get_node("Sprite2D")
			if sprite_node == null:
				print("Error: No Sprite2D node found in prize scene!")
				return

			# Set the texture for the prize
			sprite_node.texture = random_texture

			# Set the food type based on the selected texture
			var food_name = ""
			var texture_index = Gamedata.food_textures.find(random_texture)

			# Assign the food type based on the texture index
			match texture_index:
				0:
					food_name = "bacon"
				1:
					food_name = "potatoes"
				2:
					food_name = "cheese"
				3:
					food_name = "stove"
				_:
					food_name = "unknown_food"  # Default case if the texture doesn't match any known food

			# Assign the food type and texture index to the prize_instance
			prize_instance.food_type = food_name
			prize_instance.texture_index = texture_index

			# Set the prize's position
			prize_instance.position = Vector2(prize_x_position, row_y_position)

			# Add the prize to the scene
			add_child(prize_instance)
			prize_instance.add_to_group("prize")  # Add to the 'prize' group for easy management

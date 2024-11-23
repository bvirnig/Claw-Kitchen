extends Area2D

@export var prize_scene: PackedScene  # Reference to the prize scene (the food you want to spawn)
var current_capacity: int = 0
var max_capacity: int = 4
var food2cook_spawner: Node  # Reference to Food2CookSpawner

var current_collision_shape_index: int = 0  # Track the current collision shape index for food placement
var collision_shapes_positions: Array = []  # Stores all collision shape global positions

@export var stove_id: int  # Unique identifier for this stove, set manually or dynamically

# Flag to prevent multiple food instantiations per click
var is_food_instantiating: bool = false

func _ready() -> void:
	print("Stove %d ready! Current capacity: %d, Max capacity: %d", stove_id, current_capacity, max_capacity)

	food2cook_spawner = $Food2CookSpawner
	if food2cook_spawner == null:
		print("Error: food2cook_spawner is not found!")

	collision_shapes_positions = get_collision_shapes_positions()
	print("Collision shapes positions for stove %d: ", stove_id, collision_shapes_positions)

func get_collision_shapes_positions() -> Array:
	var collision_shapes_positions: Array = []
	for child in get_children():
		if child is CollisionShape2D:
			collision_shapes_positions.append(child.position)

	if collision_shapes_positions.size() != 4:
		print("Warning: Expected 4 CollisionShape2D nodes, found %d", collision_shapes_positions.size())

	return collision_shapes_positions

# Handle when another object enters the stove's area
func _on_body_entered(body: Node) -> void:
	# Ensure the body is the expected one (e.g., mouse cursor or specific player interaction node)
	if body.name != "Player":  # Replace with the correct condition for your project
		return

	if is_food_instantiating:
		# Prevent multiple interactions simultaneously
		print("Stove %d: Currently handling a spawn; ignoring additional input.", stove_id)
		return

	# Block further spawns until this one is handled
	is_food_instantiating = true

	if Gamedata == null:
		print("Error: GameData singleton not found!")
		is_food_instantiating = false
		return

	# Get the selected food type
	var selected_food = Gamedata.get_selected_item()
	if Gamedata.get_food_count(selected_food) >= 1:
		if food2cook_spawner != null:
			# Get the position of the next collision shape
			var spawn_position = collision_shapes_positions[current_collision_shape_index]
			print("Stove %d: Spawn position for food: ", stove_id, spawn_position)

			# Spawn the food item
			food2cook_spawner.instantiate_food_at_position(spawn_position)

			# Decrease the food count
			Gamedata.decrement_food(selected_food, false)
			print("Stove %d: Food count decremented.", stove_id)

			# Cycle to the next collision shape index
			current_collision_shape_index = (current_collision_shape_index + 1) % 4
		else:
			print("Error: food2cook_spawner is null!")
	else:
		print("Stove %d: Not enough food to spawn.", stove_id)

	# Re-enable food instantiation
	is_food_instantiating = false

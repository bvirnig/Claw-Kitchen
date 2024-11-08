extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # No initialization needed here for now

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if the "0" key is pressed (numeric "0" key on the keyboard)
	if Input.is_key_pressed(KEY_0):
		reset_game()

# Function to reset the game
func reset_game() -> void:
	# Reload the current scene to reset the game
	get_tree().reload_current_scene()

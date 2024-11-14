extends CharacterBody2D

func _ready() -> void:
	# Start by setting the player position to the mouse position
	position = get_global_mouse_position()

func _process(delta: float) -> void:
	# Directly set the player's position to the current mouse position
	position = get_global_mouse_position()

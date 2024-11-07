extends Area2D

# Reference to the spawner
@export var spawner: Node

# Called when a mouse button is pressed on this tile
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		if spawner:
			spawner.spawn_new_cook_tile(self)

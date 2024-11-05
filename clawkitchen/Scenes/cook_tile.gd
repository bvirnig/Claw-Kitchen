extends Area2D

# This function will be called when a body enters the Area2D.
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("players"):  # Check if the body is a player
		print("Player has entered the cook tile area.")

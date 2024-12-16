extends Control


const MAIN_SCENE_PATH = "res://Scenes/main.tscn"  # Update this with the correct path to your main game scene

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file(MAIN_SCENE_PATH)  # Change to the main game scene

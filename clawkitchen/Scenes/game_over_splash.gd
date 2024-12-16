extends Control

@onready var score_label: Label = $ScoreLabel  # Assumes there's a Label node called ScoreLabel in the scene

const START_SPLASH_SCENE_PATH = "res://Scenes/splash_start.tscn"  # Update this with the correct path to your StartSplash scene

func _ready() -> void:
	var completed_orders = Gamedata.completed_orders_count 
	

	score_label.text = str(completed_orders) 


func _input(event):
	if Input.is_action_just_pressed("zero"):  
		get_tree().change_scene_to_file(START_SPLASH_SCENE_PATH)

extends Control

# Reference to the ScoreLabel node
@onready var score_label: Label = $ScoreLabel  # Assumes there's a Label node called ScoreLabel in the scene

# Path to the Start Splash scene
const START_SPLASH_SCENE_PATH = "res://Scenes/splash_start.tscn"  # Update this with the correct path to your StartSplash scene

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Fetch the number of completed orders from the Gamedata singleton
	var completed_orders = Gamedata.completed_orders_count  # Reference the completed_orders_count directly from Gamedata
	
	# Set the text of the ScoreLabel to display the completed orders
	score_label.text = str(completed_orders)  # Display the completed orders in the label

# Detect "zero" input to go back to the Start Splash screen
func _input(event):
	# Check if the "zero" input action is triggered
	if Input.is_action_just_pressed("zero"):  # "zero" is the custom input action
		get_tree().change_scene_to_file(START_SPLASH_SCENE_PATH)  # Switch to the Start Splash scene

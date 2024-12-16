extends Node2D

@onready var inventory_update_timer = $InventoryUpdateTimer  # New Timer node for updating the inventory
@onready var request_label_check_timer = $RequestLabelCheckTimer  # New Timer node for checking the request label
@onready var raw_food_gui = $RawGUI  # Reference to RawFoodGUI scene where labels are handled
@onready var collectSound = $collectSound  # Reference to the AudioStreamPlayer2D node for playing sound
@onready var game_timer = $GameTimer  # Reference to GameTimer node
@onready var game_timer_label = $GameTimerCountdownLabel  # Reference to the GameTimerCountdownLabel node


const GAME_OVER_SCENE_PATH = "res://Scenes/game_over_splash.tscn"


func _ready() -> void:
	# Start the inventory update timer to trigger every 1 second (independent of food_label)
	inventory_update_timer.wait_time = 1.0  # Set interval to 1 second
	inventory_update_timer.start()  # Start the timer

	# Update all food labels immediately by calling the update method in RawFoodGUI
	raw_food_gui.update_food_labels()

	# Start the GameTimer 
	game_timer.start()  


	update_game_timer_label()


func _process(delta: float) -> void:
	var food_counter_label = get_node("FoodCounter")
	if food_counter_label:
		food_counter_label.text = "Food Collected: " + str(Gamedata.food_collected)


	if Input.is_action_just_pressed("mouse_scroll_up"):
		var new_index = (Gamedata.selected_item_index + 1) % min(Gamedata.food_types.size(), 10)
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	elif Input.is_action_just_pressed("mouse_scroll_down"):
		var new_index = Gamedata.selected_item_index - 1
		if new_index < 0:
			new_index = min(Gamedata.food_types.size(), 10) - 1  # Wrap to the last valid index (size capped to 10)
		
		Gamedata.set_selected_item_by_index(new_index)
		update_food_label()

	update_game_timer_label()


func update_food_label() -> void:
	var selected_item = Gamedata.get_selected_item()  
	var count = Gamedata.get_food_count(selected_item)  
	# 
	raw_food_gui.update_food_labels()


func update_game_timer_label() -> void:
	var remaining_time = game_timer.time_left  
	if game_timer_label:
		game_timer_label.text = "Time Left: " + str(int(remaining_time)) 
	else:
		print("Error: GameTimerCountdownLabel not found!")
		
func _on_collection_bin_body_entered(body: Node2D) -> void:
	if body is Food:
		body.collect() 
		
	
		Gamedata.collect_food(body.food_type)  
		
		print("Collected food: ", body.food_type)  

	
		raw_food_gui.update_food_labels() 

		
		collectSound.play()   


func _on_game_timer_timeout():
	print("Game Over! Timer has ended.")
	get_tree().change_scene_to_file(GAME_OVER_SCENE_PATH) 

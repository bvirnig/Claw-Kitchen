extends Control

@onready var cooked_potato_label = $CookedPotatoLabel
@onready var cooked_mushroom_label = $MushroomLabel
@onready var cooked_bell_pepper_label = $BellPepperLabel
@onready var cooked_butter_label = $ButterLabel
@onready var cooked_olive_oil_label = $OliveOilLabel
@onready var cooked_beef_label = $BeefLabel
@onready var cooked_fish_label = $FishLabel
@onready var cooked_red_wine_label = $RedWineLabel
@onready var cooked_white_wine_label = $WhiteWineLabel
@onready var update_timer = $UpdateTimer


func _ready() -> void:
	# Update food labels immediately when the scene is ready
	update_food_labels()
	# Start the timer
	update_timer.start()

# Update the cooked food labels for all cooked food types 
func update_food_labels() -> void:
	var cooked_food_types = Gamedata.cooked_food_counts  # Assuming you have the cooked food counts in Gamedata
	for cooked_food_type in cooked_food_types:
		# Get the current count of the cooked food type from Gamedata
		var food_count = Gamedata.get_cooked_food_count(cooked_food_type)

		# Update the labels for each cooked food type 
		match cooked_food_type:
			"potato":
				if cooked_potato_label: cooked_potato_label.text = str(food_count)
			"mushroom":
				if cooked_mushroom_label: cooked_mushroom_label.text = str(food_count)
			"bell_pepper":
				if cooked_bell_pepper_label: cooked_bell_pepper_label.text = str(food_count)
			"butter":
				if cooked_butter_label: cooked_butter_label.text = str(food_count)
			"olive_oil":
				if cooked_olive_oil_label: cooked_olive_oil_label.text = str(food_count)
			"beef":
				if cooked_beef_label: cooked_beef_label.text = str(food_count)
			"fish":
				if cooked_fish_label: cooked_fish_label.text = str(food_count)
			"red_wine":
				if cooked_red_wine_label: cooked_red_wine_label.text = str(food_count)
			"white_wine":
				if cooked_white_wine_label: cooked_white_wine_label.text = str(food_count)

func _on_update_timer_timeout() -> void:
	update_food_labels()

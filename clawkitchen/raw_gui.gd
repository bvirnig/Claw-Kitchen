extends Control

@onready var food_label = $FoodLabel  # FoodLabel inside RawFoodGUI
@onready var cheese_label = $CheeseLabel  # CheeseLabel inside RawFoodGUI
@onready var potato_label = $PotatoLabel  # Potato Label inside RawFoodGUI
@onready var mushroom_label = $MushroomLabel  # Mushroom Label inside RawFoodGUI
@onready var bell_pepper_label = $BellPepperLabel  # Bell Pepper Label inside RawFoodGUI
@onready var butter_label = $ButterLabel  # Butter Label inside RawFoodGUI
@onready var olive_oil_label = $OliveOilLabel  # Olive Oil Label inside RawFoodGUI
@onready var beef_label = $BeefLabel  # Beef Label inside RawFoodGUI
@onready var fish_label = $FishLabel  # Fish Label inside RawFoodGUI
@onready var red_wine_label = $RedWineLabel  # Red Wine Label inside RawFoodGUI
@onready var white_wine_label = $WhiteWineLabel  # White Wine Label inside RawFoodGUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Update all food labels immediately when the scene is ready
	update_food_labels()

# Update the food labels for all food types dynamically (Restoring these back to the original state)
func update_food_labels() -> void:
	# Loop through all food types in Gamedata
	var food_types = Gamedata.food_types
	for food_type in food_types:
		# Get the current count of the food type from Gamedata
		var food_count = Gamedata.get_food_count(food_type)

		# Update the labels for each food type dynamically
		match food_type:
			"cheese":
				if cheese_label: cheese_label.text = str(food_count)
			"potato":
				if potato_label: potato_label.text = str(food_count)
			"mushroom":
				if mushroom_label: mushroom_label.text = str(food_count)
			"bell_pepper":
				if bell_pepper_label: bell_pepper_label.text = str(food_count)
			"butter":
				if butter_label: butter_label.text = str(food_count)
			"olive_oil":
				if olive_oil_label: olive_oil_label.text = str(food_count)
			"beef":
				if beef_label: beef_label.text = str(food_count)
			"fish":
				if fish_label: fish_label.text = str(food_count)
			"red_wine":
				if red_wine_label: red_wine_label.text = str(food_count)
			"white_wine":
				if white_wine_label: white_wine_label.text = str(food_count)

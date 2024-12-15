extends Control

@onready var meals_cooked_label = $MealsCookedAmountLabel  # Reference to the MealsCookedAmountLabel node

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Initialize the label with the current completed orders count from Gamedata
	update_meals_cooked_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Continuously update the label with the current completed orders count
	update_meals_cooked_label()

# Function to update the MealsCookedAmountLabel with the completed orders count
func update_meals_cooked_label() -> void:
	if meals_cooked_label:
		# Get the current completed orders count from Gamedata and set the label text
		meals_cooked_label.text = str(Gamedata.completed_orders_count)
	else:
		print("Error: MealsCookedAmountLabel not found!")

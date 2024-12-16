extends Control

@onready var meals_cooked_label = $MealsCookedAmountLabel  # Reference to the MealsCookedAmountLabel node

func _ready() -> void:
	update_meals_cooked_label()


func _process(delta: float) -> void:
	update_meals_cooked_label()

func update_meals_cooked_label() -> void:
	if meals_cooked_label:
		# Get the current completed orders count from Gamedata and set the label text
		meals_cooked_label.text = str(Gamedata.completed_orders_count)
	else:
		print("Error: MealsCookedAmountLabel not found!")

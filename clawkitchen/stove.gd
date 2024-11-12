extends Area2D

# Define the current and maximum capacity
var current_capacity: int = 0
var max_capacity: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optional: Print initial state
	print("Stove ready! Current capacity: %d, Max capacity: %d", current_capacity, max_capacity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when there is an input event on this Area2D node (e.g., mouse click).
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Print the message when the stove is clicked
		print("Hello, it's me a stove!")
		
		# Optionally: Update and print the capacity
		# current_capacity = (current_capacity + 1) % (max_capacity + 1)  # You can use this line to simulate filling the stove
		# print("Current capacity: %d", current_capacity)

extends CharacterBody2D
class_name Food

@export var food_type: String = "unknown_food"  # Default food type, will be set by the spawner
@export var texture_index: int = -1  # The index of the texture in the prize_textures array
@export var prize_textures: Array = []  # Array of possible textures

var is_lifted: bool = false
var fall_chance: float = 0.1
var fall_speed: float = 150.0
var is_falling: bool = false
var has_fallen: bool = false
const BASE_SPEED: float = 150

var initial_position_y: float
var direction: int = 1
var speed: float = BASE_SPEED

# Set fixed boundaries for the food to move left/right
const LEFT_BOUNDARY: float = 40.0
const RIGHT_BOUNDARY: float = 410.0  # Adjust based on your game's design

signal food_dropped

# Initialization
func _ready() -> void:
	initial_position_y = position.y
	# Set the texture based on the assigned texture index
	if prize_textures.size() > 0 and texture_index >= 0 and texture_index < prize_textures.size():
		var sprite = $Sprite2D
		if sprite:
			sprite.texture = prize_textures[texture_index]  # Directly assign the texture from the array
	else:
		print("Warning: Invalid texture index or prize_textures array is empty.")

# Process each frame
func _process(delta: float) -> void:
	if is_lifted and not is_falling:
		position.y -= speed * delta
		if position.y < 200:  # Limit position so food doesn't go too high
			position.y = 200
			move_left_right(delta)

	elif is_falling:
		position.y += fall_speed * delta  # Make food fall if it's lifted

	# Listen for the spacebar press to drop the food
	if Input.is_action_just_pressed("ui_accept"):  # Spacebar or a custom input action
		print("Spacebar pressed, food will start falling.")
		if is_lifted:  # Only fall if the food is lifted
			fall()  # Trigger the fall function when the spacebar is pressed

# Move food left/right within boundaries
func move_left_right(delta: float) -> void:
	position.x += direction * speed * delta
	if position.x <= LEFT_BOUNDARY or position.x >= RIGHT_BOUNDARY:
		direction *= -1

# Triggered when the claw hits the food
func hit():
	if not is_lifted and not has_fallen:
		print("Food hit by claw at position: ", position)  # Debug: Log when food is hit
		is_lifted = true
		var timer_duration = randf_range(0.3, 4.0)  # Random fall timer duration
	#	$FallTimer.start(timer_duration)  # Start a timer to decide if food falls

# Handle the timeout of the fall timer
func _on_fall_timer_timeout():
	if not has_fallen and is_lifted:
		if randf() < fall_chance:
			fall()  # Call the fall function if the chance is met

# Make the food fall
func fall() -> void:
	is_falling = true
	has_fallen = true
	emit_signal("food_dropped")

# Additional function to trigger the fall manually (useful if needed)
func fall_signal():
	fall()

# Empty handler for food dropped signal
func _on_food_dropped() -> void:
	pass
	
# Function to collect the food (when it touches the collection bin)
func collect():
	print("Food collected: " + food_type)  # Debug output showing the collected food type
	emit_signal("food_dropped")  # Emit a signal to notify that the food has been collected
	queue_free()  # Remove the food node from the scene

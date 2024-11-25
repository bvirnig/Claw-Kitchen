extends Area2D
class_name Claw

const BASE_SPEED: float = 250.0
const SCREEN_WIDTH: int = 425  # Adjusted screen width to account for border
const SCREEN_HEIGHT: int = 648  # Fixed screen height

var direction: int = 1
var speed: float = BASE_SPEED
var is_descending: bool = false
var is_ascending: bool = false
var is_holding: bool = false
var is_moving_left_right: bool = false  # Track left/right movement
var original_y_position: float = 150.0  # Set the starting y position to 150
var food: Food = null  # Store the currently held food item

func _ready() -> void:
	position.x = 6  # Set starting x position to 6 (5 pixels from the left edge)
	position.y = original_y_position  # Set the starting y position to 150
	update_speed()

func update_speed() -> void:
	# You can leave this function in place to update speed later when you add levels.
	speed = BASE_SPEED  # Keep it simple for now

func _process(delta: float) -> void:
	handle_input()

	if is_descending:
		descend_claw(delta)
	elif is_ascending:
		ascend_claw(delta)
	else:
		move_left_right(delta)

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		stop_block()  # Start descending when space is just pressed

	if Input.is_action_pressed("ui_accept"):
		if not is_holding:
			var overlapping_bodies = get_overlapping_bodies()
			for body in overlapping_bodies:
				if body is Food:
					pick_up_food(body)  # Pick up the food if touching one
					break  # Exit loop after picking up

	if Input.is_action_just_released("ui_accept"):
		drop_food()  # Drop the food when space is released
		ascend_claw(0)  # Trigger ascending immediately upon release

func move_left_right(delta: float) -> void:
	# Get the claw width
	var claw_width = get_node("CollisionShape2D").shape.get_size().x  # Assuming the claw's width is defined by its CollisionShape2D

	position.x += direction * speed * delta
	is_moving_left_right = true  # Set to true while moving left/right

	# Boundary checks
	if position.x <= 20 + claw_width / 2:  # Adjust left boundary to be 30 pixels from the left edge
		position.x = 30 + claw_width / 2  # Prevent moving too far left
		direction = 1  # Change direction to right
	elif position.x >= SCREEN_WIDTH - claw_width / 2:  # Adjust for claw's width
		position.x = SCREEN_WIDTH - claw_width / 2  # Prevent moving too far right
		direction = -1  # Change direction to left

func descend_claw(delta: float) -> void:
	position.y += speed * delta
	var bottom_edge = position.y + get_node("CollisionShape2D").shape.get_size().y / 2

	if bottom_edge >= SCREEN_HEIGHT:
		position.y = SCREEN_HEIGHT - get_node("CollisionShape2D").shape.get_size().y
		is_descending = false
		is_ascending = true  # Start ascending immediately

func ascend_claw(delta: float) -> void:
	if position.y > original_y_position:
		position.y -= speed * delta
	else:
		position.y = original_y_position
		is_ascending = false
		is_descending = false

		direction = 1  # Reset direction to right
		move_left_right(0)

func stop_block() -> void:
	direction = 0
	is_descending = true  # Start descending immediately
	is_holding = false  # Ensure we are not holding food
	
func pick_up_food(body: Food) -> void:
	food = body
	food.hit()  # Trigger the hit method on the food

	position.y = body.position.y - (body.get_node("CollisionShape2D").shape.get_size().y / 2) - (get_node("CollisionShape2D").shape.get_size().y / 2)

	is_ascending = true
	is_descending = false  # Stop descending
	is_holding = true  # Now holding food

func drop_food() -> void:
	if is_holding and food:
		position.y = original_y_position  # Drop at original position
		food = null  # Release the food
		is_holding = false  # No longer holding food

func is_over_collection_area() -> bool:
	# Check if the claw is over the collection area (bottom of the screen)
	return position.y >= SCREEN_HEIGHT - 100  # Example condition; adjust as needed

func _on_body_entered(body: Node2D) -> void:
	if is_descending and body is Food and not is_holding:
		pick_up_food(body)

func _on_body_exited(body: Node2D) -> void:
	if is_moving_left_right and body is Food:
		if randf() < 0.5:  # 50% chance
			body.fall_signal()  # Call the fall signal on the food



func _on_collection_bin_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

extends Area2D

@export var food_type: String  # Define a property to store the food type
@onready var idiotSandwich: AudioStreamPlayer2D = $idiotSandwich  # Reference to the AudioStreamPlayer2D node in the scene tree
@onready var yesChef: AudioStreamPlayer2D = $yesChef  # Reference to the new AudioStreamPlayer2D node (yesChef)
@onready var sprite_animation_player: AnimationPlayer = $AnimationPlayer  # Reference to the AnimationPlayer in Sprite2D2
@onready var life_timer: Timer = $LifeTimer  # Reference to the LifeTimer node
@onready var faster_timer: Timer = $FasterTimer  # Reference to the FasterTimer node (if needed)
@onready var yumSound: AudioStreamPlayer2D = $yumSound

signal playSound

# This function could be used to handle the texture setting for the sprite node
func set_food_texture(texture: Texture) -> void:
	var sprite_node = $Sprite2D2  # Reference to the sprite node in your request label
	if sprite_node:
		sprite_node.texture = texture
	else:
		print("Error: Sprite node not found!")

# Called when the node enters the scene tree (this is when the object is "spawned")
func _ready() -> void:
	# Play the "yesChef" sound when the request is instantiated
	if yesChef:
		yesChef.play()  # Play the "yesChef" sound

	# Play the animation when the request is spawned
	if sprite_animation_player:
		sprite_animation_player.play("request")  # Replace with the correct animation name
	else:
		print("Error: AnimationPlayer not found!")

	# Debugging message to confirm the FasterTimer has started
	print("FasterTimer started with wait time: " + str(faster_timer.wait_time))

# Called every frame to check if the food type exists in the cooked_food_counts
func _process(delta: float) -> void:
	# Check if the food type exists in Gamedata's cooked_food_counts and if its amount is >= 1
	if food_type in Gamedata.cooked_food_counts and Gamedata.cooked_food_counts[food_type] >= 1:
		# Decrement the cooked food count by 1 when the request is removed
		Gamedata.cooked_food_counts[food_type] -= 1
		
		# Increment completed orders in Gamedata
		Gamedata.increment_completed_orders()
		yumSound.play()
		

# Called when the life timer times out (if applicable)
func _on_life_timer_timeout() -> void:
	idiotSandwich.play()  # Play the sound when the timer runs out

# Called when the audio finishes playing
func _on_idiot_sandwich_finished() -> void:
	queue_free()  # Remove the request label after the sound is finished

# Called when the Faster Timer times out
func _on_faster_timer_timeout() -> void:
	# Debugging message for FasterTimer timeout
	print("FasterTimer has timed out.")

	# Reduce the life timer's wait time by 20 seconds (if the timer's wait_time is greater than 20)
	if life_timer.wait_time > 0:
		life_timer.wait_time -= 96  # Decrease the life timer by 35 seconds (can be adjusted as needed)
		print("LifeTimer wait_time reduced to: " + str(life_timer.wait_time))  # Debug message
	else:
		# If the wait time is 20 seconds or less, you can set it to the minimum value you want
		life_timer.wait_time = 1  # Setting it to 1 second (or adjust based on your needs)
		print("LifeTimer wait_time set to minimum value: " + str(life_timer.wait_time))  # Debug message
	
	# Increase the speed of the animation (speed_scale greater than 1 makes it faster)
	if sprite_animation_player:
		sprite_animation_player.speed_scale *= 1.2  # Increase the speed by 20%. Adjust this multiplier as needed
		print("Animation speed_scale increased to: " + str(sprite_animation_player.speed_scale))  # Debug message
	else:
		print("Error: AnimationPlayer not found!")


func _on_yum_sound_finished() -> void:
	# Remove the request label from the scene
	queue_free()  # Remove the request label

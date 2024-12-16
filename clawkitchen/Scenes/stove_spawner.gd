extends Node2D

@export var stove_scene: PackedScene 
var last_stove_position: Vector2
var stove_count_in_row: int = 0
var max_stoves_per_row: int = 5
var row_offset: float = 100  
var stove_spacing: float = 100  # Distance between each stove
var first_stove_offset: float = 550  
var max_total_stoves: int = 15  # Maximum total number of stoves
var total_stoves_spawned: int = 0 


func _ready() -> void:
	if stove_scene:
		last_stove_position = Vector2(first_stove_offset, get_viewport().get_size().y / 2)  # Start further to the right
		
		_spawn_new_stove()



func _process(delta: float) -> void:
	if Gamedata.food_counts.has("stove") and Gamedata.food_counts["stove"] > 0:
		_spawn_new_stove()
		Gamedata.food_counts["stove"] -= 1  
		print("Stove collected! Remaining stoves: " + str(Gamedata.food_counts["stove"]))


func _spawn_new_stove() -> void:
	if stove_scene and total_stoves_spawned < max_total_stoves:
		var stove_instance = stove_scene.instantiate()

		stove_instance.position = last_stove_position

		add_child(stove_instance)


		stove_count_in_row += 1
		last_stove_position.x += stove_spacing
		total_stoves_spawned += 1

		if stove_count_in_row >= max_stoves_per_row:
			last_stove_position.x = first_stove_offset
			last_stove_position.y += row_offset
			stove_count_in_row = 0

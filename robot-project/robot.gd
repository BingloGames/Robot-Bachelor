extends CharacterBody2D


var SPEED = 100


var direction = Vector2i.RIGHT
var target_position
var next_tile


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and target_position == null:
		print("pressed! up")
		forward()
		
	if Input.is_action_just_pressed("ui_left") and target_position == null:
		print("pressed! left")
		left()
	
	if Input.is_action_just_pressed("ui_right") and target_position == null:
		print("pressed! right")
		right()


func _physics_process(delta: float) -> void:
	if next_tile == null:
		return
	
	set_velocity((direction)*SPEED)
	move_and_slide()
	
	
	var halv_a_tile = get_node("/root/Node2D/TileMapLayer").tile_set.tile_size/2
	var current_tile = get_node("/root/Node2D/TileMapLayer").local_to_map(Vector2i(global_position)-(halv_a_tile*direction))
	
	
	if current_tile == next_tile:
		position = get_node("/root/Node2D/TileMapLayer").map_to_local(next_tile)
		next_tile = null


func forward():
	var current_tile = get_node("/root/Node2D/TileMapLayer").local_to_map(global_position)
	next_tile = current_tile + direction


func left():
	direction = Vector2(direction).rotated(-PI/2)
	direction = Vector2i(direction)
	print("Left! direction: ", direction)


func right():
	direction = Vector2(direction).rotated(PI/2)
	direction = Vector2i(direction)
	print("Right! direction: ", direction)

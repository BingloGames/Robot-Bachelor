extends CharacterBody2D


var SPEED = 100


var direction = Vector2i.RIGHT
var next_tile


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and next_tile == null:
		print("pressed! up")
		forward()
		
	elif Input.is_action_just_pressed("ui_left") and next_tile == null:
		print("pressed! left")
		left()
	
	elif Input.is_action_just_pressed("ui_right") and next_tile == null:
		print("pressed! right")
		right()
	
	elif Input.is_action_just_pressed("ui_down") and next_tile == null:
		print("pressed! down")
		right()
	
	elif next_tile == null:
		idle()


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


func play_animation(animation: String) -> void:
	if get_node("AnimationPlayer").get_current_animation() == animation:
		return
	get_node("AnimationPlayer").play(animation)


func idle() -> void:
	play_animation("idle")


func walk_animation() -> void:
	match direction:
		Vector2i.LEFT:
			play_animation("walk left")
		Vector2i.RIGHT:
			play_animation("walk right")
		Vector2i.UP:
			play_animation("walk up")
		Vector2i.DOWN:
			play_animation("walk down")
		_:
			play_animation("idle")


func forward() -> void:
	var current_tile = get_node("/root/Node2D/TileMapLayer").local_to_map(global_position)
	next_tile = current_tile + direction
	
	walk_animation()


func backward() -> void:
	var current_tile = get_node("/root/Node2D/TileMapLayer").local_to_map(global_position)
	next_tile = current_tile - direction
	
	walk_animation()


func left() -> void:
	direction = Vector2(direction).rotated(-PI/2)
	direction = Vector2i(direction)
	print("Left! direction: ", direction)


func right() -> void:
	direction = Vector2(direction).rotated(PI/2)
	direction = Vector2i(direction)
	print("Right! direction: ", direction)

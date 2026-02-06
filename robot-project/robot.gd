extends CharacterBody2D


var SPEED = 100

var start_direction = Vector2i.RIGHT
var direction = start_direction
var walking_backwards = false

var next_tile


#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_up") and next_tile == null:
		#print("pressed! up")
		#forward()
		#
	#elif Input.is_action_just_pressed("ui_left") and next_tile == null:
		#print("pressed! left")
		#left()
	#
	#elif Input.is_action_just_pressed("ui_right") and next_tile == null:
		#print("pressed! right")
		#right()
	#
	#elif Input.is_action_just_pressed("ui_down") and next_tile == null:
		#print("pressed! down")
		#right()
	#
	#elif next_tile == null:
		#idle()


func _physics_process(delta: float) -> void:
	if next_tile == null:
		return
	
	
	var halv_a_tile = get_node("/root/Node2D/special").tile_set.tile_size/2
	var current_tile = get_node("/root/Node2D/special").local_to_map(Vector2i(global_position)-(halv_a_tile*direction))
	
	
	#set_velocity((direction)*SPEED)
	var collision = move_and_collide(direction*SPEED*delta)
	
	
	if collision:
		print("Collided!")
		#play animation before running this code?
		Global.restart_level()
		return
	
	
	if current_tile == next_tile:
		position = get_node("/root/Node2D/special").map_to_local(next_tile)
		if walking_backwards:
			direction *= -1
			walking_backwards = false
		
		
		next_tile = null
		get_node("/root/Node2D/code").waiting = false
		check_tile()


func respawn():
	scale = Vector2(1,1)
	global_position = get_node("/root/Node2D/start point").global_position
	next_tile = null
	walking_backwards = false
	direction = start_direction
	
	idle()


func play_animation(animation: String) -> void:
	if get_node("AnimationPlayer").get_current_animation() == animation:
		return
	get_node("AnimationPlayer").play(animation)


func idle() -> void:
	match direction:
		Vector2i.LEFT:
			play_animation("idle left")
		Vector2i.RIGHT:
			play_animation("idle right")
		Vector2i.UP:
			play_animation("idle up")
		Vector2i.DOWN:
			play_animation("idle down")
		_:
			print("????????????????")


func walk_animation() -> void:
	var walking_direction = direction
	
	
	if walking_backwards:
		walking_direction *= -1
	
	
	match walking_direction:
		Vector2i.LEFT:
			play_animation("walk left")
		Vector2i.RIGHT:
			play_animation("walk right")
		Vector2i.UP:
			play_animation("walk up")
		Vector2i.DOWN:
			play_animation("walk down")
		_:
			idle()


func check_tile():
	var current_tile = get_node("/root/Node2D/special").local_to_map(global_position)
	var tile_data = get_node("/root/Node2D/special").get_cell_tile_data(current_tile)
	
	
	if tile_data == null:
		print("nothing special...")
		return
	
	
	if not tile_data.has_custom_data("Property"):
		print("nothing special again")
		return
	
	
	var custom_data = tile_data.get_custom_data("Property")
	match custom_data:
		"Hole":
			get_node("AnimationPlayer").play("fall in hole")
			get_node("/root/Node2D/code").waiting = true


func check_end() -> void:
	var current_tile = get_node("/root/Node2D/special").local_to_map(global_position)
	var tile_data = get_node("/root/Node2D/special").get_cell_tile_data(current_tile)
	
	
	if tile_data == null:
		#loses and restarts
		die()
		return
	
	
	if not tile_data.get_custom_data("Property") == "End":
		#loses and restarts
		die()
		return
	
	
	get_node("/root/Node2D/end_particles").emitting = true
	get_node("/root/Node2D/star counter").save_stars()
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("/root/Node2D/black"),"modulate:a", 1, 0.5)
	tween.tween_callback(Callable(Global, "next_level_player_1")).set_delay(0.2)


func die():
	print("Lost! restarting...")
	Global.restart_level()


func forward() -> void:
	var current_tile = get_node("/root/Node2D/special").local_to_map(global_position)
	next_tile = current_tile + direction
	
	walk_animation()


func backward() -> void:
	direction *= -1
	walking_backwards = true
	forward()
	
	
	walk_animation()


func left() -> void:
	direction = Vector2(direction).rotated(-PI/2)
	direction = Vector2i(direction)
	forward()
	print("Left! direction: ", direction)


func right() -> void:
	direction = Vector2(direction).rotated(PI/2)
	direction = Vector2i(direction)
	forward()
	print("Right! direction: ", direction)

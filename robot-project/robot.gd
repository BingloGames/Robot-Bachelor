extends CharacterBody2D
class_name Robot


var SPEED = 100

@export var start_direction: Vector2i = Vector2i.RIGHT
var direction = start_direction
var walking_backwards = false
var died = false


@onready var start_point = global_position
var next_tile


var conveyoring = false # are you on a conveyor belt?
var conveyor_speed = 0 # how fast is the conveyor belt?
var conveyor_duration = 0 # how long have the robot been on the conveyor?


func _ready() -> void:
	direction = start_direction
	#using this instead of autoplay is to stop visual glitches for multiplayer
	#and to make sure that the correct idle animation plays if start direction is not default
	idle()


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float):
	if next_tile == null:
		return
	
	
	var halv_a_tile = get_node("/root/Node2D/special").tile_set.tile_size/2
	var current_tile = get_node("/root/Node2D/special").local_to_map(Vector2i(global_position)-(halv_a_tile*direction))
	
	
	var collision = move_and_collide(direction*SPEED*delta)
	
	
	if collision:
		print(name + " collided with: ", collision.get_collider().name, " at position: ", collision.get_position())
		#play animation before running this code?
		die()
		return
	
	
	if current_tile == next_tile:
		position = get_node("/root/Node2D/special").map_to_local(next_tile)
		if walking_backwards:
			direction *= -1
			walking_backwards = false
		
		
		next_tile = null
		get_node("/root/Node2D/code").robot_changes_wait(self, false)
		check_tile()
		


func respawn() -> void:
	scale = Vector2(1,1)
	rotation_degrees = 0
	global_position = start_point
	next_tile = null
	walking_backwards = false
	direction = start_direction
	died = false
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


func check_tile() -> void:
	var current_tile = get_node("/root/Node2D/special").local_to_map(global_position)
	
	
	check_conveyor(current_tile)
	var tile_data = get_node("/root/Node2D/special").get_cell_tile_data(current_tile)
	
	
	if tile_data == null:
		return
	
	
	if not tile_data.has_custom_data("Property"):
		return
	
	
	var custom_data = tile_data.get_custom_data("Property")
	match custom_data:
		"Hole":
			print("hole!")
			get_node("AnimationPlayer").play("fall in hole")
			get_node("/root/Node2D/code").robot_changes_wait(self, true)


func check_conveyor(current_tile: Vector2i):
	var conveyor_belt_node = get_node_or_null("/root/Node2D/ConveyorBelt")
	if conveyor_belt_node == null:
		return
	
	
	var cb_data = conveyor_belt_node.get_cell_tile_data(current_tile)
	if cb_data == null:
		stop_conveyor()
		return
	
	
	if not conveyoring:
		conveyoring = true
		conveyor_speed = cb_data.get_custom_data("Speed")
	else:
		if conveyor_duration >= conveyor_speed:
			#temporarily stop the conveyor belt for the robot to run a line of code
			stop_conveyor()
			return
	
	
	continue_conveyor(current_tile, cb_data)


func continue_conveyor(current_tile: Vector2i, cb_data: TileData):
	var dir = cb_data.get_custom_data("dir")
	#print(dir)
	var turn = cb_data.get_custom_data("Turn")
	get_node("/root/Node2D/code").running_code = false
	
	
	match turn:
		"left":
			direction = Vector2(direction).rotated(-PI/2)
			direction = Vector2i(direction)
			next_tile = current_tile + (dir)
			#idle()
		"right":
			direction = Vector2(direction).rotated(PI/2)
			direction = Vector2i(direction)
			next_tile = current_tile + (dir)
			#idle()
		_:
			next_tile = current_tile + (dir)
			#idle()
	
	
	conveyor_duration += 1


func stop_conveyor():
	conveyoring = false
	conveyor_speed = 0
	conveyor_duration = 0
	get_node("/root/Node2D/code").running_code = true





func check_end() -> void:
	var current_tile = get_node("/root/Node2D/special").local_to_map(global_position)
	var tile_data = get_node("/root/Node2D/special").get_cell_tile_data(current_tile)
	
	
	if tile_data == null:
		die()
		return
	
	
	if not tile_data.get_custom_data("Property") == "End":
		die()
		return
	
	
	get_node("/root/Node2D/star counter").save_stars()
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("/root/Node2D/black"),"modulate:a", 1, 0.5)
	tween.tween_callback(Callable(Global, "next_level_player_1")).set_delay(0.2)


func die() -> void:
	died = true
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


func right() -> void:
	direction = Vector2(direction).rotated(PI/2)
	direction = Vector2i(direction)
	forward()


func wait() -> void:
	get_node("/root/Node2D/code").robot_changes_wait(self, true)
	get_node("wait").start(get_node("/root/Node2D/ground").tile_set.tile_size.x/SPEED)


func _on_wait_timeout() -> void:
	get_node("/root/Node2D/code").robot_changes_wait(self, false)

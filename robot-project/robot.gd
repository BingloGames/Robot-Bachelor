extends CharacterBody2D
class_name Robot


const SPEED = 100
var movement_speed = SPEED


@onready var special_tilemap = get_node("/root/Node2D/special")
@onready var conveyor_belt_tilemap = get_node_or_null("/root/Node2D/ConveyorBelt")
@onready var code_node = get_node("/root/Node2D/code")
#@onready var star_counter = get_node("/root/Node2D/star counter")
@onready var anim_player = get_node("AnimationPlayer")
@onready var wait_timer = get_node("wait")



@export var start_direction: Vector2i = Vector2i.RIGHT
var robot_direction = start_direction
var movement_direction = robot_direction
var walking_backwards = false
var died = false


@onready var start_point = global_position#does this need to be @onready?
var next_tile


var conveyoring = false # are you on a conveyor belt?
var conveyor_speed = 0 # how fast is the conveyor belt?
var conveyor_duration = 0 # how long have the robot been on the conveyor?


func _ready() -> void:
	robot_direction = start_direction
	movement_direction = robot_direction
	#using this instead of autoplay is to stop visual glitches for multiplayer
	#and to make sure that the correct idle animation plays if start direction is not default
	idle()


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta: float) -> void:
	if next_tile == null or died:
		return
	
	
	var collision = move_and_collide(movement_direction*movement_speed*delta)
	
	
	if collision:
		print(name + " collided with: ", collision.get_collider().name, " at position: ", collision.get_position())
		#play animation before running this code?
		print("conveyoring: ", conveyoring)
		die()
		return
	
	
	var halv_a_tile = special_tilemap.tile_set.tile_size/2
	var current_tile = special_tilemap.local_to_map(Vector2i(global_position)-(halv_a_tile*movement_direction))
	
	
	if current_tile == next_tile:
		position = special_tilemap.map_to_local(next_tile)
		if walking_backwards:
			movement_direction *= -1
			#direction *= -1
			walking_backwards = false
		
		
		next_tile = null
		code_node.robot_changes_wait(self, false)#this feel awkward. change?
		check_tile()
		


func respawn() -> void:
	print("respawning robot: ", name)
	scale = Vector2(1,1)
	rotation_degrees = 0
	set_position(start_point)
	next_tile = null
	walking_backwards = false
	robot_direction = start_direction
	movement_direction = robot_direction
	died = false
	
	
	print(name, "'s position is: ", position)
	
	
	stop_conveyor()
	code_node.running_code = false
	idle()


func play_animation(animation: String) -> void:
	if anim_player.get_current_animation() == animation:
		return
	anim_player.play(animation)


func play_directional_animation(anim_start: String, direction: Vector2i = robot_direction) -> void:
	var anim = anim_start + " "
	
	
	match direction:
		Vector2i.LEFT:
			anim += "left"
		Vector2i.RIGHT:
			anim += "right"
		Vector2i.UP:
			anim += "up"
		Vector2i.DOWN:
			anim += "down"
		_:
			print("????????????????")
	
	
	play_animation(anim)


func idle() -> void:
	if died:
		return
	play_directional_animation("idle")


func walk_animation() -> void:
	#if walking_backwards:
		#walking_direction *= -1
	play_directional_animation("walk")


func check_tile() -> void:
	if died:
		return
	
	
	var current_tile = special_tilemap.local_to_map(global_position)
	
	
	check_conveyor(current_tile)
	var tile_data = special_tilemap.get_cell_tile_data(current_tile)
	
	
	if tile_data == null:
		return
	
	
	if not tile_data.has_custom_data("Property"):
		return
	
	
	var custom_data = tile_data.get_custom_data("Property")
	match custom_data:
		"Hole":
			print("hole!")
			anim_player.play("fall in hole")
			code_node.robot_changes_wait(self, true)


func check_conveyor(current_tile: Vector2i) -> void:
	if conveyor_belt_tilemap == null:
		return
	
	
	var cb_data = conveyor_belt_tilemap.get_cell_tile_data(current_tile)
	if cb_data == null:
		print("no conveyor belt data: ", name)
		stop_conveyor()
		return
	
	
	if not cb_data.has_custom_data("dir"):
		print("conveyor belt tile does not have dir for robot: ", name)
		stop_conveyor()
		return
	
	
	print("conveyoring_tile: ", current_tile)
	
	
	if not conveyoring:
		print("start conveyoring: ", name)
		conveyoring = true
		conveyor_speed = cb_data.get_custom_data("Speed")
		movement_speed *= conveyor_speed
	else:
		if conveyor_duration >= conveyor_speed:
			movement_direction = robot_direction
			#temporarily stop the conveyor belt for the robot to run a line of code
			stop_conveyor()
			return
	
	
	continue_conveyor(current_tile, cb_data)


func continue_conveyor(current_tile: Vector2i, cb_data: TileData) -> void:
	print("continue conveyoring: ", name)
	var dir = cb_data.get_custom_data("dir")
	#print(dir)
	var turn = cb_data.get_custom_data("Turn")
	code_node.running_code = false
	
	
	movement_direction = dir
	
	
	match turn:
		"left":
			robot_direction = Vector2(robot_direction).rotated(-PI/2)
			robot_direction = Vector2i(robot_direction)
			next_tile = current_tile + (dir)
			#idle()
		"right":
			robot_direction = Vector2(robot_direction).rotated(PI/2)
			robot_direction = Vector2i(robot_direction)
			next_tile = current_tile + (dir)
			#idle()
		_:
			next_tile = current_tile + (dir)
			#idle()
	
	print("conveyor belt next tile: ", next_tile)
	conveyor_duration += 1


func stop_conveyor() -> void:
	print("stop conveyoring: ", name)
	movement_speed = SPEED
	conveyoring = false
	conveyor_speed = 0
	conveyor_duration = 0
	code_node.running_code = true


func check_end() -> void:
	var current_tile = special_tilemap.local_to_map(global_position)
	var tile_data = special_tilemap.get_cell_tile_data(current_tile)
	
	
	if tile_data == null:
		die()
		return
	
	
	if not tile_data.get_custom_data("Property") == "End":
		die()
		return
	
	
	Global.complete_level_player_1()


func die() -> void:
	died = true
	play_directional_animation("die", movement_direction)


func robot_finished_dying():
	Global.restart_level()


func forward() -> void:
	var current_tile = special_tilemap.local_to_map(global_position)
	next_tile = current_tile + movement_direction
	
	
	walk_animation()


func backward() -> void:
	movement_direction = robot_direction * -1
	walking_backwards = true
	forward()
	
	
	walk_animation()


func left() -> void:
	robot_direction = Vector2(robot_direction).rotated(-PI/2)
	robot_direction = Vector2i(robot_direction)
	movement_direction = robot_direction
	
	
	forward()


func right() -> void:
	robot_direction = Vector2(robot_direction).rotated(PI/2)
	robot_direction = Vector2i(robot_direction)
	movement_direction = robot_direction
	
	
	forward()


func wait() -> void:
	code_node.robot_changes_wait(self, true)
	wait_timer.start(special_tilemap.tile_set.tile_size.x/SPEED)


func _on_wait_timeout() -> void:
	code_node.robot_changes_wait(self, false)
	check_tile()

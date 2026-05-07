extends CharacterBody2D
class_name Robot


const SPEED = 100
##Movement speed of the Robot.
var movement_speed = SPEED

##Gets the special TileMapLayer.
@onready var special_tilemap = get_node("/root/Node2D/special")
##Gets the ConveyorBelt TileMapLayer if exists.
@onready var conveyor_belt_tilemap = get_node_or_null("/root/Node2D/ConveyorBelt")
##Gets the Code window.
@onready var code_node = get_node("/root/Node2D/code")
##Gets the AnimationPlayer node from the Robot.
@onready var anim_player = get_node("AnimationPlayer")
##Gets the wait timer.
@onready var wait_timer = get_node("wait")


##Start direction of the Robot, can be changed in the Inspector.
@export var start_direction: Vector2i = Vector2i.RIGHT
##Variable that indicates the Robot direction.
var robot_direction = start_direction
##Variable that indicates the Robot movement direction.
var movement_direction = robot_direction
##Variable that indicates if the robot is walking backwards.
var walking_backwards = false
##Variable that indicates if the Robot is dead.
var died = false

##Start point for the Robot.
@onready var start_point = global_position
##Variable that indicates the next tile the Robot will move to.
var next_tile

##Variable that indicates if the Robot is in a conveyor belt.
var conveyoring = false 
##Variable that indicates how many tiles the Conveyor belt moves the Robot.
var conveyor_speed = 0 
##Variable that indicates how long the Robot has been in the conveyor belt.
var conveyor_duration = 0 


func _ready() -> void:
	robot_direction = start_direction
	movement_direction = robot_direction
	#using this instead of autoplay is to stop visual glitches for multiplayer
	#and to make sure that the correct idle animation plays if start direction is not default
	idle()

func _physics_process(delta: float) -> void:
	move(delta)

##Gets the SPEED value.
static func get_speed() -> int:
	return SPEED

##Makes robot walk forward one tile.
func forward() -> void:
	var current_tile = special_tilemap.local_to_map(global_position)
	next_tile = current_tile + movement_direction
	
	walk_animation()

##Makes robot walk backwards one tile.
func backward() -> void:
	movement_direction = robot_direction * -1
	walking_backwards = true
	forward()
	
	walk_animation()

##Makes robot turn 90 degrees to the left, the moves forward one tile.
func left() -> void:
	robot_direction = Vector2(robot_direction).rotated(-PI/2)
	robot_direction = Vector2i(robot_direction)
	movement_direction = robot_direction
	
	forward()

##Makes robot turn 90 degrees to the right, the moves forward one tile.
func right() -> void:
	robot_direction = Vector2(robot_direction).rotated(PI/2)
	robot_direction = Vector2i(robot_direction)
	movement_direction = robot_direction
	
	forward()

##Leaves the Robot idle for one turn.
func wait() -> void:
	code_node.robot_changes_wait(self, true)
	wait_timer.start(special_tilemap.tile_set.tile_size.x/SPEED)

func _on_wait_timeout() -> void:
	code_node.robot_changes_wait(self, false)
	check_tile()

##Starts the correct animation.
func play_animation(animation: String) -> void:
	if anim_player.get_current_animation() == animation:
		return
	anim_player.play(animation)

##Finds which animation the robot needs to do.
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
			anim += "left"
	
	play_animation(anim)

##Idle animation
func idle() -> void:
	if died:
		return
	play_directional_animation("idle")

##Walk animation
func walk_animation() -> void:
	play_directional_animation("walk")



##Plays the dying animation.
func die() -> void:
	died = true
	play_directional_animation("die", movement_direction)

##After the robots finishes the dying animation, restarts the level.
func robot_finished_dying():
	Global.restart_level()

##Resets Robot
func respawn() -> void:
	scale = Vector2(1,1)
	rotation_degrees = 0
	set_position(start_point)
	next_tile = null
	walking_backwards = false
	robot_direction = start_direction
	movement_direction = robot_direction
	died = false

	stop_conveyor()
	code_node.running_code = false
	idle()


##Starts the Robot movement.
func move(delta: float) -> void:
	if next_tile == null or died:
		return
	
	var collision = move_and_collide(movement_direction*movement_speed*delta)
	
	if collision:
		die()
		return
	
	var halv_a_tile = special_tilemap.tile_set.tile_size/2
	var current_tile = special_tilemap.local_to_map(Vector2i(global_position)-(halv_a_tile*movement_direction))
	
	if current_tile == next_tile:
		position = special_tilemap.map_to_local(next_tile)
		if walking_backwards:
			movement_direction *= -1
			walking_backwards = false
		
		next_tile = null
		code_node.robot_changes_wait(self, false)
		check_tile()

##Checks if the robot is on top of a special tile.
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
			anim_player.play("fall in hole")
			code_node.robot_changes_wait(self, true)

##Checks if the robot is on top of a Conveyor belt.
func check_conveyor(current_tile: Vector2i) -> void:
	if conveyor_belt_tilemap == null:
		return
	
	var cb_data = conveyor_belt_tilemap.get_cell_tile_data(current_tile)
	if cb_data == null:
		stop_conveyor()
		return
	
	if not cb_data.has_custom_data("dir"):
		stop_conveyor()
		return
	
	if not conveyoring:
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

##Moves the Robot the appropiate number of tiles according to the Conveyot belt activated.
func continue_conveyor(current_tile: Vector2i, cb_data: TileData) -> void:
	var dir = cb_data.get_custom_data("dir")
	
	var turn = cb_data.get_custom_data("Turn")
	code_node.running_code = false
	
	movement_direction = dir
	
	match turn:
		"left":
			robot_direction = Vector2(robot_direction).rotated(-PI/2)
			robot_direction = Vector2i(robot_direction)
			next_tile = current_tile + (dir)
		
		"right":
			robot_direction = Vector2(robot_direction).rotated(PI/2)
			robot_direction = Vector2i(robot_direction)
			next_tile = current_tile + (dir)
		
		_:
			next_tile = current_tile + (dir)
		
	conveyor_duration += 1

##Stops the Conveyor movement of the Robot.
func stop_conveyor() -> void:
	movement_speed = SPEED
	conveyoring = false
	conveyor_speed = 0
	conveyor_duration = 0
	code_node.running_code = true

##If the robot its not moving, checks if its standing on an End tile.
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

extends Node2D
class_name MultiplayerGeneral

##Tilemap that contains the special tiles.
@onready var special_tilemap_node = get_node("special")
##Star counter node in the scene.
@onready var star_counter_node = get_node("star counter")
##The black node for the fadeout.
@onready var black_fade_node = get_node("black")

##Robot paths that has finished the code.
var robots_finished = []


func _ready() -> void:
	if multiplayer.is_server():
		get_node("robots/robot1").highlight_name()
	else:
		get_node("robots/robot2").highlight_name()
	
	ConnectionController.peer_ready_sync.rpc()

##Marks the robot as finished and if all players have finished, checks if they win.
func robot_finished(robot_path: NodePath) -> void:
	if robot_path in robots_finished:
		return
	
	robots_finished.append(robot_path)
	
	if not multiplayer.is_server():
		return
	
	if len(robots_finished) == ConnectionController.NUM_PLAYERS:
		check_both_robot_end()

##Checks if they win and restart the level or go to next level.
func check_both_robot_end() -> void:
	var robots_succeded = []
	
	for robot_path in robots_finished:
		var robot = get_node(robot_path)
		var current_tile = special_tilemap_node.local_to_map(robot.global_position)
		var tile_data = special_tilemap_node.get_cell_tile_data(current_tile)
		
		if tile_data == null:
			robot.die()
			return
		
		if not tile_data.get_custom_data("Property") == "End":
			robot.die()
			return
		
		robots_succeded.append(robot)
	
	if len(robots_succeded) == ConnectionController.NUM_PLAYERS:
		success.rpc()
		return
	
	Global.restart_level()

##Fade to black, save the stars and go to next level.
@rpc("authority", "call_local", "reliable")
func success() -> void:
	print("success!")
	star_counter_node.save_stars()
	
	for sync in get_tree().get_nodes_in_group("synchronizers"):
		sync.set_visibility_public(false)
	
	var tween = get_tree().create_tween()
	tween.tween_property(black_fade_node,"color:a", 1, 0.5)
	tween.tween_callback(Callable(Global, "next_level_player_2")).set_delay(0.2)

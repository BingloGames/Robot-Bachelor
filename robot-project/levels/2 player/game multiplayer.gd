extends Node2D


@onready var special_tilemap_node = get_node("special")
@onready var star_counter_node = get_node("star counter")
@onready var black_fade_node = get_node("black")


var robots_finished = []


func _ready() -> void:
	if multiplayer.is_server():
		get_node("robots/robot1").highlight_name()
	else:
		get_node("robots/robot2").highlight_name()
	
	
	ConnectionController.peer_ready_sync.rpc()


func robot_finished(robot_path: NodePath) -> void:
	if robot_path in robots_finished:
		return
	
	
	print("robot finished: ", robot_path, "!")
	robots_finished.append(robot_path)
	
	
	if not multiplayer.is_server():
		return
	
	
	if len(robots_finished) == 2:
		check_both_robot_end()


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
	
	
	if len(robots_succeded) == 2:
		success.rpc()
		return
	
	
	Global.restart_level()


@rpc("authority", "call_local", "reliable")
func success() -> void:
	print("success!")
	star_counter_node.save_stars()
	
	
	for sync in get_tree().get_nodes_in_group("synchronizers"):
		sync.set_visibility_public(false)
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(black_fade_node,"modulate:a", 1, 0.5)
	tween.tween_callback(Callable(Global, "next_level_player_2")).set_delay(0.2)

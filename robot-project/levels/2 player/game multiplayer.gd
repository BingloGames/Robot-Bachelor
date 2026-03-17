extends Node2D


var robots_finished = []


func robot_finished(robot_path: NodePath):
	if robot_path in robots_finished:
		return
	
	
	print("robot finished: ", robot_path, "!")
	robots_finished.append(robot_path)
	
	
	if not multiplayer.is_server():
		return
	
	
	if len(robots_finished) == 2:
		check_both_robot_end()


func check_both_robot_end():
	var robots_succeded = []
	
	
	for robot_path in robots_finished:
		var robot = get_node(robot_path)
		var current_tile = get_node("/root/Node2D/special").local_to_map(robot.global_position)
		var tile_data = get_node("/root/Node2D/special").get_cell_tile_data(current_tile)
		
		
		if tile_data == null:
			robot.die()
			continue
		
		
		if not tile_data.get_custom_data("Property") == "End":
			robot.die()
			continue
		
		
		robots_succeded.append(robot)
	
	
	if len(robots_succeded) == 2:
		success.rpc()
		return
	
	
	Global.restart_level()


@rpc("authority", "call_local", "reliable")
func success():
	print("success!")
	get_node("/root/Node2D/star counter").save_stars()
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("/root/Node2D/black"),"modulate:a", 1, 0.5)
	tween.tween_callback(Callable(Global, "next_level_player_2")).set_delay(0.2)

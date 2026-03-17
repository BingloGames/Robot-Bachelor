extends Robot
class_name MultiplayerRobot


func _ready() -> void:
	super._ready()
	
	
	print("Direction: ", direction)
	#this can be done better, right?
	for player in ConnectionController.players.keys():
		var player_name = ConnectionController.players[player]
		
		
		if name == "robot1" and player == 1:
			get_node("name").text = player_name
		elif name == "robot2" and not player == 1:
			get_node("name").text = player_name
	
	
	if not multiplayer.is_server():
		get_node("AnimationPlayer").stop()
	
	
	await get_tree().process_frame
	await get_tree().process_frame
	get_node("MultiplayerSynchronizer").set_visibility_public(true)


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		move(delta)


func respawn() -> void:
	super.respawn()
	get_node("/root/Node2D/code").robot_waiting_data[self]["running_code"] = false
	get_node("/root/Node2D/code").is_ready = false
	get_node("/root/Node2D/code").reset_ready.rpc()


func check_end() -> void:
	get_node("/root/Node2D").robot_finished(self.get_path())

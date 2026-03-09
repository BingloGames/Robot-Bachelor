extends Robot
class_name MultiplayerRobot


func _ready() -> void:
	#this can be done better, right?
	for player in ConnectionController.players.keys():
		var player_name = ConnectionController.players[player]
		
		
		if name == "robot1" and player == 1:
			get_node("name").text = player_name
		elif name == "robot2" and not player == 1:
			get_node("name").text = player_name


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		move(delta)


func respawn() -> void:
	super.respawn()
	get_node("/root/Node2D/code").robot_waiting_data[self]["running_code"] = false
	get_node("/root/Node2D/code").is_ready = false
	get_node("/root/Node2D/code").ready_pressed.rpc(false)


func check_end() -> void:
	get_node("/root/Node2D").robot_finished.rpc(self.get_path())

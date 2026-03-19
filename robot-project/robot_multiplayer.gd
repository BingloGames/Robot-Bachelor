extends Robot
class_name MultiplayerRobot


func _ready() -> void:
	super._ready()
	
	
	#this can be done better, right?
	for player in ConnectionController.players.keys():
		var player_name = ConnectionController.players[player]
		
		
		if name == "robot1" and player == 1:
			get_node("name").text = player_name
		elif name == "robot2" and not player == 1:
			get_node("name").text = player_name
	
	
	if not multiplayer.is_server():
		get_node("AnimationPlayer").stop()


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		move(delta)


func check_end() -> void:
	get_node("/root/Node2D").robot_finished(self.get_path())


func highlight_name():
	get_node("name").add_theme_constant_override("outline_size", 3)

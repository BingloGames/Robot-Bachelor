extends Robot
class_name MultiplayerRobot


@onready var name_node = get_node("name")


func _ready() -> void:
	super._ready()
	
	
	#this can be done better, right?
	for player in ConnectionController.players.keys():
		var player_name = ConnectionController.players[player]
		
		
		if name == "robot1" and player == 1:
			name_node.text = player_name
		elif name == "robot2" and not player == 1:
			name_node.text = player_name
	
	
	if not multiplayer.is_server():
		anim_player.stop()


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		move(delta)


func continue_conveyor(current_tile: Vector2i, cb_data: TileData) -> void:
	super.continue_conveyor(current_tile, cb_data)
	
	
	#for robot in code_node.robot_waiting_data:
	code_node.robot_waiting_data[self]["running_code"] = false


func stop_conveyor() -> void:
	super.stop_conveyor()
	
	
	#for robot in code_node.robot_waiting_data:
	code_node.robot_waiting_data[self]["running_code"] = true


func respawn() -> void:
	super.respawn()
	
	
	#for robot in code_node.robot_waiting_data:
	code_node.robot_waiting_data[self]["running_code"] = false


func die() -> void:
	if multiplayer.is_server():
		super.die()


func check_end() -> void:
	get_node("/root/Node2D").robot_finished(self.get_path())


func highlight_name() -> void:
	name_node.add_theme_constant_override("outline_size", 3)

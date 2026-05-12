extends Robot
class_name MultiplayerRobot
##The character that the user will control in a multiplayer setting.


@onready var name_node = get_node("name")


func _ready() -> void:
	super._ready()
	
	
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

##Moves the Robot the appropiate number of tiles according to the Conveyor belt activated.
func continue_conveyor(current_tile: Vector2i, cb_data: TileData) -> void:
	super.continue_conveyor(current_tile, cb_data)
	code_node.robot_waiting_data[self]["running_code"] = false

##Stops the Conveyor movement of the Robot.
func stop_conveyor() -> void:
	super.stop_conveyor()
	code_node.robot_waiting_data[self]["running_code"] = true

##Resets Robot.
func respawn() -> void:
	super.respawn()
	code_node.robot_waiting_data[self]["running_code"] = false

##Plays the dying animation. Only works in from the server.
func die() -> void:
	if multiplayer.is_server():
		super.die()

##Marks the Robot as finished. If all Robots are finished, finish the game.
func check_end() -> void:
	get_node("/root/Node2D").robot_finished(self.get_path())

##Highlight the name. Used to mark who the player controlling.
func highlight_name() -> void:
	name_node.add_theme_constant_override("outline_size", 3)

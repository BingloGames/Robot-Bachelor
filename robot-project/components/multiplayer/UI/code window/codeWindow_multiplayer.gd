extends CodeWindow
class_name MultiplayerCodeWindow
##Code window for the player to code the Robots commands in a multiplayer setting.

##If true, the player has written their code and is ready to play.
var is_ready = false
##The players that is ready.
var ready_players = []

##The different robot codes.
var robot_code = {}
##The robots that is done with the robot code.
var robots_done = []

##The line that the robots is at in the code.
var robot_current_line = {}


##The default for loop data for each robot.
var robot_for_loop_data_default = {"for_looping" : false, "for_loop_count" : 0, 
"for_loop_line" : 0, "for_loop_contents" : [], "for_loop_max" : 0} 
##The for loop data for each robot.
var robot_for_loop_data = {}

##The default waiting data for each robot.
var robot_waiting_data_default = {"waiting" : false, "running_code" : false}
##The waiting data for each robot.
var robot_waiting_data = {}


func _ready() -> void:
	get_node("line limit").text += str(line_limit)
	
	
	if multiplayer.is_server():
		for temp_robot in get_node("/root/Node2D/robots").get_children():
			robot_for_loop_data[temp_robot] = robot_for_loop_data_default.duplicate_deep()
			robot_waiting_data[temp_robot] = robot_waiting_data_default.duplicate()
			robot_current_line[temp_robot] = 0


func _process(delta: float) -> void:
	if multiplayer.is_server():
		for temp_robot in robot_code.keys():
			robot = temp_robot
			
			
			#set the current for loop data to the one that is specific to the current robot
			for for_loop_data in robot_for_loop_data[robot].keys():
				set(for_loop_data, robot_for_loop_data[robot][for_loop_data])
			
			
			for for_waiting_data in robot_waiting_data[robot].keys():
				set(for_waiting_data, robot_waiting_data[robot][for_waiting_data])
			
			
			codeLines = robot_code[robot]
			turn = robot_current_line[robot]
			
			
			super._process(delta)
			
			
			#incase the game ends in the middle of the process
			#for example if there are no code lines left and a robot dies
			if robot_code.is_empty():
				break
			
			
			robot_code[robot] = codeLines
			robot_current_line[robot] = turn
			
			
			for for_loop_data in robot_for_loop_data[robot].keys():
				robot_for_loop_data[robot][for_loop_data] = get(for_loop_data)
			
			
			for for_waiting_data in robot_waiting_data[robot].keys():
				robot_waiting_data[robot][for_waiting_data] = get(for_waiting_data)


func _on_go_button_pressed() -> void:
	is_ready = !is_ready
	ready_pressed.rpc(is_ready)

##Set waiting for the current robot.
func set_waiting(value: bool) -> void:
	super.set_waiting(value)
	if robot == null:
		return
	robot_waiting_data[robot]["waiting"] = value

##RPC that marks the player as ready or not ready. 
##Starts the game if all players are ready, but only from the server.
@rpc("any_peer", "call_local", "reliable")
func ready_pressed(peer_is_ready: bool) -> void:
	if not peer_is_ready:
		ready_players.erase(multiplayer.get_remote_sender_id())
		return
	
	
	ready_players.append(multiplayer.get_remote_sender_id())
	if multiplayer.is_server():
		var all_ready = true
		
		
		for player_id in ConnectionController.players.keys():
			if not player_id in ready_players:
				all_ready = false
				break
		
		
		if all_ready:
			start_code()

##RPC that unmarks all players as ready.
@rpc("call_local")
func reset_ready() -> void:
	is_ready = false
	ready_players.clear()

##Start the code. Only meant to be called from the server.
func start_code() -> void:
	go_button.hide()
	stop_button.show()
	robot_code[get_node("/root/Node2D/robots/robot1")] = codeLines
	init_code_lines.rpc()
	
	
	if get_node("/root/Node2D").has_node("lasers"):
		for laser in get_node("/root/Node2D/lasers").get_children():
			laser.start()

##RPC that only the server can call. Gets the code from the other clients.
@rpc("authority", "call_local", "reliable")
func init_code_lines() -> void:
	super.init_code_lines()
	
	
	for player_id in ConnectionController.players.keys():
		if player_id == multiplayer.get_unique_id():
			continue
		get_robot_code.rpc_id(player_id, codeLines)

##RPC that saves the code from the server/clients.
@rpc("any_peer", "call_local", "reliable")
func get_robot_code(code_lines: Array) -> void:
	if multiplayer.is_server():
		robot_code[get_node("/root/Node2D/robots/robot2")] = code_lines
	else:
		robot_code[get_node("/root/Node2D/robots/robot1")] = code_lines
	
	
	#the server got the code for both of the robots, we are ready to start
	for temp_robot in robot_waiting_data.keys():
		robot_waiting_data[temp_robot]["running_code"] = true
	
	
	running_code = true


func problem_warning() -> void:
	for temp_robot in robot_current_line:
		if not temp_robot.died:
			continue
		
		
		var temp_turn = robot_current_line[temp_robot]
		if temp_robot.name == "robot1":#???
			problem_warning_multiplayer(temp_turn)
			continue
		
		
		problem_warning_multiplayer.rpc(temp_turn)

##RPC that shows the line that caused the failure.
@rpc
func problem_warning_multiplayer(robot_turn: int) -> void:
	turn = robot_turn
	super.problem_warning()

##Stops the player's commands from running.
func stop_running_code() -> void:
	for temp_robot in robot_code.keys():
		robot_waiting_data[temp_robot] = robot_waiting_data_default.duplicate()
		robot_for_loop_data[temp_robot] = robot_for_loop_data_default.duplicate_deep()
		robot_current_line[temp_robot] = 0
	robot_code.clear()
	
	
	super.stop_running_code()
	
	
	reset_ready.rpc()

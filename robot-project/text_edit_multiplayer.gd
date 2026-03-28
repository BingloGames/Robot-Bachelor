extends "res://text_edit.gd"


var is_ready = false
var ready_players = []


var robot_code = {}
var robots_done = []


var robot_current_line = {}


#save for looping data in dictonary for each robot
var robot_for_loop_data_default = {"for_looping" : false, "for_loop_count" : 0, 
"for_loop_line" : 0, "for_loop_contents" : [], "for_loop_max" : 0, "for_loop_string" : ""}
var robot_for_loop_data = {}


var robot_waiting_data_default = {"waiting" : false, "running_code" : false}
var robot_waiting_data = {}


func _ready() -> void:
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
			
			
			robot_code[robot] = codeLines
			robot_current_line[robot] = turn
			
			
			for for_loop_data in robot_for_loop_data[robot].keys():
				robot_for_loop_data[robot][for_loop_data] = get(for_loop_data)
			
			
			for for_waiting_data in robot_waiting_data[robot].keys():
				robot_waiting_data[robot][for_waiting_data] = get(for_waiting_data)


func _on_go_button_pressed() -> void:
	is_ready = !is_ready
	ready_pressed.rpc(is_ready)


func set_waiting(value: bool) -> void:
	super.set_waiting(value)
	if robot == null:
		return
	robot_waiting_data[robot]["waiting"] = value


@rpc("any_peer", "call_local", "reliable")
func ready_pressed(peer_is_ready: bool) -> void:
	print("ready pressed with id: ", multiplayer.get_remote_sender_id())
	if not peer_is_ready:
		ready_players.erase(multiplayer.get_remote_sender_id())
		return
	
	
	ready_players.append(multiplayer.get_remote_sender_id())
	print("new ready players: ", ready_players)
	if multiplayer.is_server():
		var all_ready = true
		
		
		for player_id in ConnectionController.players.keys():
			if not player_id in ready_players:
				all_ready = false
				print("not all players ready: ", player_id)
				break
		
		
		if all_ready:
			print("all ready!")
			start_code()


@rpc("call_local")
func reset_ready() -> void:
	is_ready = false
	ready_players.clear()


func start_code() -> void:
	go_button.hide()
	stop_button.show()
	robot_code[get_node("/root/Node2D/robots/robot1")] = codeLines
	init_code_lines.rpc()
	
	
	if get_node("/root/Node2D").has_node("lasers"):
		for laser in get_node("/root/Node2D/lasers").get_children():
			laser.start()


@rpc("authority", "call_local", "reliable")
func init_code_lines() -> void:
	super.init_code_lines()
	
	
	#this can be done better, right?
	for player_id in ConnectionController.players.keys():
		if player_id == multiplayer.get_unique_id():
			continue
		print("get code from id: ", player_id)
		get_robot_code.rpc_id(player_id, codeLines)


@rpc("any_peer", "call_local", "reliable")
func get_robot_code(code_lines: Array) -> void:
	#this code can be done better, right?
	if multiplayer.is_server():
		robot_code[get_node("/root/Node2D/robots/robot2")] = code_lines
	else:
		robot_code[get_node("/root/Node2D/robots/robot1")] = code_lines
	
	
	#the server got the code for both of the robots, we are ready to start
	print("gets code from other peer")
	for temp_robot in robot_waiting_data.keys():
		robot_waiting_data[temp_robot]["running_code"] = true
	
	
	running_code = true


func problem_warning() -> void:
	for temp_robot in robot_current_line:
		#print("checking if ", temp_robot.name, " died")
		if not temp_robot.died:
			continue
		
		
		#print(temp_robot.name, " died!")
		
		
		var temp_turn = robot_current_line[temp_robot]
		if temp_robot.name == "robot1":#???
			problem_warning_multiplayer(temp_turn)
			continue
		
		
		problem_warning_multiplayer.rpc(temp_turn)


@rpc
func problem_warning_multiplayer(robot_turn: int) -> void:
	turn = robot_turn
	super.problem_warning()


func stop_running_code() -> void:
	for temp_robot in robot_code.keys():
		robot_waiting_data[temp_robot] = robot_waiting_data_default.duplicate()
		robot_for_loop_data[temp_robot] = robot_for_loop_data_default.duplicate_deep()
		robot_current_line[temp_robot] = 0
		robot_code.clear()
	
	
	super.stop_running_code()
	
	
	reset_ready.rpc()
	
	print("new ready players: ", ready_players)

extends "res://text_edit.gd"


var is_ready = false
var ready_players = []


var robot_code = {}
var robots_done = []


var robot_for_loop_data = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		robot = get_node("/root/Node2D/robots/robot1")
	else:
		robot = get_node("/root/Node2D/robots/robot2")


func _process(delta: float) -> void:
	super._process(delta)


func _on_button_pressed() -> void:
	is_ready = !is_ready
	
	
	#if is_ready:
		#ready_players.append(multiplayer.get_unique_id())
	#else:
		#ready_players.erase(multiplayer.get_unique_id())
	#
	#
	ready_pressed.rpc(is_ready)


@rpc("any_peer", "call_local", "reliable")
func ready_pressed(peer_is_ready: bool):
	print("ready pressed with id: ", multiplayer.get_remote_sender_id())
	if not peer_is_ready:
		ready_players.erase(multiplayer.get_remote_sender_id())
		return
	
	
	ready_players.append(multiplayer.get_remote_sender_id())
	if multiplayer.is_server():
		var all_ready = true
		
		
		for player_id in ConnectionController.players.keys():
			if not player_id in ready_players:
				all_ready = false
				print("not all players ready: ", player_id)
				break
		
		
		if all_ready:
			print("all ready!")
			start_code.rpc()


@rpc("any_peer", "call_local", "reliable")
func start_code():
	print("start code multiplayer! with id: ", multiplayer.get_unique_id())
	super.start_code()
	
	
	robot_code[robot] = codeLines
	
	#this can be done better, right?
	for player_id in ConnectionController.players.keys():
		if player_id == multiplayer.get_unique_id():
			continue
		ConnectionController.get_robot_code.rpc_id(player_id, codeLines)
	
	
	#the client tries to move the robot instead of the server
	#try to have the server move both of the robots?
	
	
	print("robot codes: ", robot_code)
	
	print("waiting: ", waiting)
	print("running_code: ", running_code)
	print("code lines: ", codeLines)

extends "res://door.gd"


func open() -> void:
	if not multiplayer.is_server():
		return
	open_multiplayer.rpc()


@rpc("call_local")
func open_multiplayer() -> void:
	for robot in code_node.robot_waiting_data.keys():
		code_node.robot_waiting_data[robot]["running_code"] = false
	
	
	super.open()


func close() -> void:
	if not multiplayer.is_server():
		return
	close_multiplayer.rpc()


@rpc("call_local")
func close_multiplayer() -> void:
	for robot in code_node.robot_waiting_data.keys():
		code_node.robot_waiting_data[robot]["running_code"] = false
	
	
	super.close()


func finished() -> void:
	if not multiplayer.is_server():
		return
	
	
	super.finished()
	
	
	print("door finished opening")
	for robot in code_node.robot_waiting_data.keys():
		code_node.robot_waiting_data[robot]["running_code"] = true


func reset() -> void:
	if not multiplayer.is_server():
		return
	reset_multiplayer.rpc()


@rpc("call_local")
func reset_multiplayer() -> void:
	super.reset()

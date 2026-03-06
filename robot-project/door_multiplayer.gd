extends "res://door.gd"


func open():
	if not multiplayer.is_server():
		return
	open_multiplayer.rpc()


@rpc("call_local")
func open_multiplayer():
	super.open()


func close():
	if not multiplayer.is_server():
		return
	close_multiplayer.rpc()


@rpc("call_local")
func close_multiplayer():
	super.close()


func finished():
	if not multiplayer.is_server():
		return
	
	
	super.finished()
	
	
	for robot in get_node("/root/Node2D/code").robot_waiting_data.keys():
		get_node("/root/Node2D/code").robot_waiting_data[robot]["running_code"] = true


func reset():
	if not multiplayer.is_server():
		return
	reset_multiplayer.rpc()


@rpc("call_local")
func reset_multiplayer():
	super.reset()

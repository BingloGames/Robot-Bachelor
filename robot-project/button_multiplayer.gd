extends "res://button.gd"


func activate():
	if not multiplayer.is_server():
		return
	activate_multiplayer.rpc()


@rpc("call_local")
func activate_multiplayer():
	super.activate()
	
	
	for temp_robot in get_node("/root/Node2D/code").robot_waiting_data.keys():
		get_node("/root/Node2D/code").robot_waiting_data[temp_robot]["running_code"] = false


func deactivate():
	if not multiplayer.is_server():
		return
	deactivate_multiplayer.rpc()


@rpc("call_local")
func deactivate_multiplayer():
	super.deactivate()

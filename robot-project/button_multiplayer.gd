extends "res://button.gd"


func activate():
	if not multiplayer.is_server():
		return
	activate_multiplayer.rpc()


@rpc("call_local")
func activate_multiplayer():
	print("activate button multiplayer")
	super.activate()


func deactivate():
	if not multiplayer.is_server():
		return
	deactivate_multiplayer.rpc()


@rpc("call_local")
func deactivate_multiplayer():
	super.deactivate()

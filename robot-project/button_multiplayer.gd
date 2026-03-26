extends "res://button.gd"


func activate() -> void:
	if not multiplayer.is_server():
		return
	activate_multiplayer.rpc()


@rpc("call_local")
func activate_multiplayer() -> void:
	print("activate button multiplayer")
	super.activate()


func deactivate() -> void:
	if not multiplayer.is_server():
		return
	deactivate_multiplayer.rpc()


@rpc("call_local")
func deactivate_multiplayer() -> void:
	super.deactivate()

extends "res://button.gd"
class_name MultiplayerRobotButton
##An RobotButton that is suppose to be used in a multiplayer setting.

##Calls activate_multiplayer.rpc() on all clients and server. Does not do anything if not called on the server.
func activate() -> void:
	if not multiplayer.is_server():
		return
	activate_multiplayer.rpc()

##Shows the question if question is true, or opens the doors if question is false.
@rpc("call_local")
func activate_multiplayer() -> void:
	print("activate button multiplayer")
	super.activate()

##Calls deactivate_multiplayer.rpc() on all clients and server. Does not do anything if not called on the server.
func deactivate() -> void:
	if not multiplayer.is_server():
		return
	deactivate_multiplayer.rpc()

##If needs_holding is true, the doors closes. Does not do anything if needs_holding is false.
@rpc("call_local")
func deactivate_multiplayer() -> void:
	super.deactivate()

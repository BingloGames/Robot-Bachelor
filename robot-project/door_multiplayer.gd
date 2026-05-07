extends "res://door.gd"
class_name MultiplayerDoor
##A door that is only suppose to be used in a multiplayer setting. Relies on functionality from the door class.


##Calls open_multiplayer.rpc() on all clients and server. Does not do anything if not called on the server.
func open() -> void:
	if not multiplayer.is_server():
		return
	open_multiplayer.rpc()

##An RPC that opens the door on the client/server.
@rpc("call_local")
func open_multiplayer() -> void:
	for robot in code_node.robot_waiting_data.keys():
		code_node.robot_waiting_data[robot]["running_code"] = false
	
	
	super.open()

##Calls close_multiplayer.rpc() on all clients and server. Does not do anything if not called on the server.
func close() -> void:
	if not multiplayer.is_server():
		return
	close_multiplayer.rpc()

##An RPC that closes the door on the client/server.
@rpc("call_local")
func close_multiplayer() -> void:
	for robot in code_node.robot_waiting_data.keys():
		code_node.robot_waiting_data[robot]["running_code"] = false
	
	
	super.close()

##Resumes the game when the door is ready. Automatically called when the door animation is finished. 
func finished() -> void:
	if not multiplayer.is_server():
		return
	
	
	super.finished()
	
	
	print("door finished opening")
	for robot in code_node.robot_waiting_data.keys():
		code_node.robot_waiting_data[robot]["running_code"] = true

##Calls reset_multiplayer.rpc() on all clients and server. Does not do anything if not called on the server.
func reset() -> void:
	if not multiplayer.is_server():
		return
	reset_multiplayer.rpc()

##An RPC that resets the door sprite and collision on client/server.
@rpc("call_local")
func reset_multiplayer() -> void:
	super.reset()

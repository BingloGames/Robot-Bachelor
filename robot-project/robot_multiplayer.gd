extends Robot
class_name MultiplayerRobot


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		move(delta)


func respawn() -> void:
	super.respawn()
	get_node("/root/Node2D/code").robot_waiting_data[self]["running_code"] = false
	get_node("/root/Node2D/code").is_ready = false
	get_node("/root/Node2D/code").ready_pressed.rpc(false)

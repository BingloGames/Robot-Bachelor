extends "res://laser.gd"





func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		super._physics_process(_delta)


func ready_timer() -> void:
	if multiplayer.is_server():
		super.ready_timer()


func check_collision() -> void:
	var raycast_point = raycast.get_collision_point()
	check_raycast_collider()
	visual_change.rpc(raycast_point)


@rpc("call_local")
func visual_change(collision_point: Vector2) -> void:
	super.visual_change(collision_point)


func turn_off() -> void:
	if multiplayer.is_server():
		turn_off_multiplayer.rpc()
@rpc("call_local")
func turn_off_multiplayer() -> void:
	super.turn_off()


func turn_on() -> void:
	if multiplayer.is_server():
		turn_on_multiplayer.rpc()
@rpc("call_local")
func turn_on_multiplayer() -> void:
	super.turn_on()


func reset() -> void:
	if multiplayer.is_server():
		restart_multiplayer.rpc()
@rpc("call_local")
func restart_multiplayer() -> void:
	super.reset()

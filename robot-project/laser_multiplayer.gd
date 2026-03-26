extends "res://laser.gd"


func _process(_delta: float) -> void:
	if multiplayer.is_server():
		super._process(_delta)


func check_collision() -> void:
	var raycast_point = raycast.get_collision_point()
	check_raycast_collider()
	visual_change.rpc(raycast_point)


@rpc("call_local")
func visual_change(collision_point: Vector2) -> void:
	#print("visual change!")
	super.visual_change(collision_point)


func turn_off() -> void:
	turn_off_multiplayer.rpc()


@rpc("call_local")
func turn_off_multiplayer() -> void:
	super.turn_off()


func turn_on() -> void:
	turn_on_multiplayer.rpc()


@rpc("call_local")
func turn_on_multiplayer() -> void:
	super.turn_on()

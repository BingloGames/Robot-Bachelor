extends "res://laser.gd"
class_name MultiplayerLaser
##A laser that is only suppose to be used in a multiplayer setting. Relies on functionality from the laser class



func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		super._physics_process(_delta)

##Changes the state of the laser to be ready to start, but does not start the laser. Only works on the server
func ready_timer() -> void:
	if multiplayer.is_server():
		super.ready_timer()

##Checks the collision and updates the laser visually on clients/server.
func check_collision() -> void:
	var raycast_point = raycast.get_collision_point()
	check_raycast_collider()
	visual_change.rpc(raycast_point)

##An RPC that updates the laser visually.
@rpc("call_local")
func visual_change(collision_point: Vector2) -> void:
	super.visual_change(collision_point)

##Turn off the laser on all clients/server. Only works if called from the server.
func turn_off() -> void:
	if multiplayer.is_server():
		turn_off_multiplayer.rpc()
		
##An RPC that turn off the laser.
@rpc("call_local")
func turn_off_multiplayer() -> void:
	super.turn_off()

##Turn on the laser on all clients/server. Only works if called from the server.
func turn_on() -> void:
	if multiplayer.is_server():
		turn_on_multiplayer.rpc()
		
##An RPC that turn on the laser.
@rpc("call_local")
func turn_on_multiplayer() -> void:
	super.turn_on()

##Reset the laser on all clients/server. Only works if called from the server.
func reset() -> void:
	if multiplayer.is_server():
		restart_multiplayer.rpc()

##An RPC that resets the laser.
@rpc("call_local")
func restart_multiplayer() -> void:
	super.reset()

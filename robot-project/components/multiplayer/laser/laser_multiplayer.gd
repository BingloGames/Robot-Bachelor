extends Laser
class_name MultiplayerLaser
##A laser that is only suppose to be used in a multiplayer setting. Relies on functionality from the laser class

#stop the ready in Laser class
func _ready() -> void:
	return


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		super._physics_process(delta)


func _multiplayer_ready():
	super._ready()


##Changes the state of the laser to be ready to start, but does not start the laser. Only works on the server
func ready_timer() -> void:
	if not multiplayer.is_server():
		return
	
	if start_active:
		turn_on_multiplayer.rpc()
		timer.set_wait_time(laser_on_time_interval)
		return
	
	
	turn_off_multiplayer.rpc()
	timer.set_wait_time(laser_off_time_interval)


##Checks the collision and updates the laser visually on clients/server.
func check_collision() -> void:
	var raycast_point = raycast.get_collision_point()
	check_raycast_collider()
	visual_change.rpc(raycast_point)


##An RPC that updates the laser visually.
@rpc("call_local")
func visual_change(collision_point: Vector2) -> void:
	super.visual_change(collision_point)


#region Turn off
##Turn off the laser on all clients/server. Only works if called from the server.
func turn_off() -> void:
	if multiplayer.is_server():
		turn_off_multiplayer.rpc()
		
##An RPC that turn off the laser.
@rpc("call_local")
func turn_off_multiplayer() -> void:
	super.turn_off()

#endregion

#region Turn on
##Turn on the laser on all clients/server. Only works if called from the server.
func turn_on() -> void:
	if multiplayer.is_server():
		turn_on_multiplayer.rpc()
		
##An RPC that turn on the laser.
@rpc("call_local")
func turn_on_multiplayer() -> void:
	super.turn_on()
#endregion

#region Reset
##Reset the laser on all clients/server. Only works if called from the server.
func reset() -> void:
	if multiplayer.is_server():
		restart_multiplayer.rpc()

##An RPC that resets the laser.
@rpc("call_local")
func restart_multiplayer() -> void:
	super.reset()
#endregion

extends StarCounter
class_name MultiplayerStarCounter
##Keeps track and shows how many stars have been picked up in a multiplayer setting.

#region New star
##Marks the star as picked up on server/clients.
func new_star(star_index) -> void:
	if multiplayer.is_server():
		new_star_multiplayer.rpc(star_index)

##RPC that picks up the star.
@rpc("call_local", "reliable")
func new_star_multiplayer(star_index: int) -> void:
	super.new_star(star_index)
#endregion


#region Reset
##Resets the stars on server/clients.
func restart_stars() -> void:
	restart_stars_multiplayer.rpc()

##RPC that resets the stars.
@rpc("call_local", "reliable")
func restart_stars_multiplayer() -> void:
	super.restart_stars()
#endregion

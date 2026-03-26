extends "res://star_counter.gd"



func new_star(star_index) -> void:
	if multiplayer.is_server():
		new_star_multiplayer.rpc(star_index)


@rpc("call_local", "reliable")
func new_star_multiplayer(star_index: int) -> void:
	print("multiplayer new star!")
	super.new_star(star_index)


func restart_stars() -> void:
	restart_stars_multiplayer.rpc()


@rpc("call_local", "reliable")
func restart_stars_multiplayer() -> void:
	super.restart_stars()

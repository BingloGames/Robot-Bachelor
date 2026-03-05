extends "res://star_counter.gd"



func new_star(star_node_path) -> void:
	if multiplayer.is_server():
		new_star_multiplayer.rpc(star_node_path)


@rpc("call_local", "reliable")
func new_star_multiplayer(star_node_path):
	print("multiplayer new star!")
	super.new_star(star_node_path)


func restart_stars() -> void:
	restart_stars_multiplayer.rpc()


@rpc("call_local", "reliable")
func restart_stars_multiplayer():
	super.restart_stars()

extends "res://star_counter.gd"


@rpc
func new_star(star_node: Star) -> void:
	super.new_star(star_node)


@rpc
func restart_stars() -> void:
	super.restart_stars()

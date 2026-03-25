extends "res://back.gd"


func _init():
	player_menu_file = "res://2_player_level_selector.tscn"


func back():
	back_multiplayer.rpc()


@rpc("any_peer", "call_local")
func back_multiplayer():
	get_tree().change_scene_to_file(player_menu_file)

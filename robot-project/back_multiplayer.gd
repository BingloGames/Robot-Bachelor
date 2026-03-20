extends "res://back.gd"


func back():
	print("back")
	back_multiplayer.rpc()


@rpc("any_peer", "call_local")
func back_multiplayer():
	print("back multiplayer")
	get_tree().change_scene_to_file("res://2_player_level_selector.tscn")

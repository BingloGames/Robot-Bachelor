extends "res://components/singleplayer/UI/back button/back.gd"
class_name MultiplayerBackButton

func _init():
	player_menu_file = "res://menus/2_player_level_selector.tscn"

##calls the back_multiplayer function in rpc.
func back():
	back_multiplayer.rpc()

##loads the multi player level selector in both players screens.
@rpc("any_peer", "call_local")
func back_multiplayer():
	get_tree().change_scene_to_file(player_menu_file)

extends "res://1_player_menu.gd"


func _init() -> void:
	levels_path = "res://levels/2 player"


func _ready() -> void:
	Global.load_stars()
	add_buttons_from_files()


#func add_level_buttons(levels: Array) -> void:
	#for level in levels:
		#level = str(level)
		#
		#
		#var button = level_buttons.instantiate()
		#
		#
		#if Global.stars[Global.num_players].has(level):
			#button.add_stars(Global.stars[Global.num_players][level])
		#
		#
		#button.level_file_name = levels_path+"/"+levels_file_start+level+path_end
		#button.level = int(level)
		#button.get_child(0).text = level
		#
		#
		#get_node("levels").add_child(button, true)



func change_level(level_file_name: String, level: int) -> void:
	if not multiplayer.is_server():
		return
	change_level_multiplayer.rpc(level_file_name, level)


@rpc("call_local","reliable")
func change_level_multiplayer(level_file_name: String, level: int):
	super.change_level(level_file_name, level)


func _on_level_pressed(level: String) -> void:
	if not multiplayer.is_server():
		return
	change_level.rpc(level)


func back():
	ConnectionController.close_game.rpc()

extends "res://1_player_menu.gd"
class_name MultiPlayerMenu
##Multi player menu level selector

func _init() -> void:
	levels_path = "res://levels/2 player"

func _ready() -> void:
	Global.load_stars()
	add_buttons_from_files()

##Starts the transition to change the scene to the star menu.
@rpc("call_local","reliable")
func change_level_multiplayer(level_file_name: String, level: int) -> void:
	super.change_level(level_file_name, level)

##Sincronizes the transition between scenes for both players.
func change_level(level_file_name: String, level: int) -> void:
	if not multiplayer.is_server():
		return
	change_level_multiplayer.rpc(level_file_name, level)

func _on_level_pressed(level: String) -> void:
	if not multiplayer.is_server():
		return
	change_level.rpc(level)

##Closes connection and goes back to multiplayer connection screen.
func back() -> void:
	ConnectionController.close_game.rpc()

extends "res://1_player_menu.gd"


func _init() -> void:
	levels_path = "res://levels/2 player"


func add_level_buttons(levels: Array) -> void:
	for level in levels:
		var button = Button.new()
		button.connect("pressed", _on_level_pressed.bind(level))
		button.text = level
		
		get_node("levels").add_child(button, true)


@rpc("call_local","reliable")
func change_level(level: String) -> void:
	super.change_level(level)


func _on_level_pressed(level: String) -> void:
	#multiplayer needs these two functions to be seperate
	change_level.rpc(level)

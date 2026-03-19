extends CenterContainer


var level_file_name = ""
var level = 0


func _on_level_pressed() -> void:
	#multiplayer needs these two functions to be seperate
	get_parent().get_parent().change_level(level_file_name, level)

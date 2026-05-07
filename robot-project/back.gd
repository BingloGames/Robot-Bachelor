extends Button
##Back button, takes you back to level selector

##Path to the single player menu scene
var player_menu_file = "res://1_player_menu.tscn"

##Changes the scene to the single player player menu file
func back():
	get_tree().change_scene_to_file(player_menu_file)

func _on_back_pressed() -> void:
	back()

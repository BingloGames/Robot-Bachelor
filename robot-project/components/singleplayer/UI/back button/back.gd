extends Button
class_name BackButton
##Back button, takes you back to single player level selector.

##Path to the single player menu scene.
var player_menu_file = "res://menus/1_player_menu.tscn"

##Changes the scene to the single player player menu file.
func back():
	get_tree().paused = false
	get_tree().change_scene_to_file(player_menu_file)

func _on_back_pressed() -> void:
	back()

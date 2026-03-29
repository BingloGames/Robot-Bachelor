extends Button


var single_player_menu = "res://1_player_menu.tscn"


func _on_back_pressed() -> void:
	print("back pressed")
	back()


func back() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(single_player_menu)

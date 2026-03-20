extends Button


func _on_back_pressed() -> void:
	back()


func back():
	get_tree().change_scene_to_file("res://1_player_menu.tscn")

extends CenterContainer
class_name LevelButton
##Button with the number of the level and the already obtained and saved stars. 

##Sprite of a full star.
var full_star = preload("res://components/singleplayer/star/star full.png")


var level_file_name = ""
var level = 0


func _on_level_pressed() -> void:
	#multiplayer needs these two functions to be seperate
	get_parent().get_parent().change_level(level_file_name, level)

##Fills up the number of already obtained stars from the save file.
func add_stars(num_stars: int):
	for i in range(num_stars):
		get_node("level/HBoxContainer").get_child(i).texture = full_star

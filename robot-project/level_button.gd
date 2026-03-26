extends CenterContainer


@onready var container = get_node("level/HBoxContainer")


var full_star = preload("res://star full.png")


var level_file_name = ""
var level = 0


func _on_level_pressed() -> void:
	#multiplayer needs these two functions to be seperate
	get_parent().get_parent().change_level(level_file_name, level)


func add_stars(num_stars: int):
	for i in range(num_stars):
		container.get_child(i).texture = full_star

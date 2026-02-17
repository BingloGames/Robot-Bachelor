extends Node


var levels_1_player_path = "res://levels/1 player"
var levels_file_start = "Level"
var path_end = ".tscn"

var text_path = "res://Texts"
var text_language = "/ENG/"

var inventory = []

var stars = []
var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func save_stars(star_count: int) -> void:
	stars.insert(current_level-1, star_count)


func restart_level() -> void:
	get_node("/root/Node2D/star counter").restart_stars()
	get_node("/root/Node2D/robot").respawn()
	get_node("/root/Node2D/code").stop_running_code()
	
	
	if get_node("/root/Node2D").has_node("doors"):
		for door in get_node("/root/Node2D/doors").get_children():
			door.reset()
	
	
	if get_node("/root/Node2D").has_node("items"):
		get_node("/root/Node2D/items").reset_items()


func next_level_player_1() -> void:
	current_level = current_level+1
	
	
	var level_file_name = levels_1_player_path+"/"+levels_file_start+str(current_level)+path_end
	if not FileAccess.file_exists(level_file_name):
		print("file not exist")
		get_tree().change_scene_to_file("res://1_player_menu.tscn")
	print("changing level")
	
	get_tree().change_scene_to_file(level_file_name)

extends Node


var levels_1_player_path = "res://levels/1 player"
var levels_2_player_path = "res://levels/2 player"


var levels_file_start = "Level"
var path_end = ".tscn"


var text_path = "res://Texts"
var text_language = "/ENG/"


var inventory = []


var stars = {}
var current_level = 0
var num_players = "1"


var robot_turn = 0


func get_info_text():
	var level_dir = num_players + " player" + "/Level" + str(current_level)
	var file_path = text_path + text_language + level_dir + ".txt"
	
	
	print("trying to get info from file: ", file_path)
	
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			return file.get_as_text()
		else: 
			print("Error opening file: ", file)


func get_question_text():
	var question_level_dir = num_players + " player" + "/Question" + "/Level" + str(current_level)
	var file_path = text_path + text_language + question_level_dir + ".txt"
	
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			return file.get_as_text()
		else: 
			print("Error opening file: ", file)


func save_stars(star_count: int) -> void:
	#if player already has completed level, 
	#and they got more stars last time, don't do anything
	if stars.has(current_level):
		if stars[current_level] > star_count:
			return
	
	
	stars[current_level] = star_count


func restart_level() -> void:
	print("resetting level!")
	if get_node("/root/Node2D").get("robots_finished"):
		get_node("/root/Node2D").robots_finished.clear()
	
	
	get_node("/root/Node2D/code").problem_warning()
	get_node("/root/Node2D/code").stop_running_code()
	
	
	get_node("/root/Node2D/star counter").restart_stars()
	for robot in get_node("/root/Node2D/robots").get_children():
		robot.respawn()
	
	
	if get_node("/root/Node2D").has_node("doors"):
		for door in get_node("/root/Node2D/doors").get_children():
			door.reset()
	
	
	if get_node("/root/Node2D").has_node("items"):
		get_node("/root/Node2D/Container").restart()
		get_node("/root/Node2D/items").reset_items()


func next_level_player_1() -> void:
	current_level = current_level+1
	
	
	var level_file_name = levels_1_player_path+"/"+levels_file_start+str(current_level)+path_end
	if not FileAccess.file_exists(level_file_name):
		print("file not exist")
		get_tree().change_scene_to_file("res://1_player_menu.tscn")
	print("changing level")
	
	get_tree().change_scene_to_file(level_file_name)


func next_level_player_2() -> void:
	current_level = current_level+1
	
	
	var level_file_name = levels_2_player_path+"/"+levels_file_start+str(current_level)+path_end
	if not FileAccess.file_exists(level_file_name):
		print("file not exist")
		get_tree().change_scene_to_file("res://2_player_level_selector.tscn")
	print("changing level")
	
	get_tree().change_scene_to_file(level_file_name)

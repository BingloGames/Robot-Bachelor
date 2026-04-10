extends Node


var levels_1_player_path = "res://levels/1 player"
var levels_2_player_path = "res://levels/2 player"


var levels_file_start = "Level"
var path_end = ".tscn"


var text_path = "res://Texts"
var text_language = "/ENG/"


var save_file_text = "user://stars.save"


var single_player_menu = "res://1_player_menu.tscn"
var multiplayer_level_selector = "res://2_player_level_selector.tscn"


var inventory = []


var stars = {}
var current_level = "0"
var num_players = "1"


var robot_turn = 0


func get_info_text() -> String:
	var level_dir = num_players + " player" + "/Level" + current_level
	var file_path = text_path + text_language + level_dir + ".txt"
	
	
	print("trying to get info from file: ", file_path)
	
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			return file.get_as_text()
		else: 
			print("Error opening file: ", file)
	return ""


func get_question_text() -> String:
	var question_level_dir = num_players + " player" + "/Question" + "/Level" + current_level
	var file_path = text_path + text_language + question_level_dir + ".txt"
	
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			return file.get_as_text()
		else: 
			print("Error opening file: ", file)
	return ""


func save_stars(star_count: int) -> void:
	#if player already has completed level, 
	#and they got more stars last time, don't do anything
	if not stars.has(num_players):
		stars[num_players] = {}
	
	
	if stars[num_players].has(current_level):
		if stars[num_players][current_level] > star_count:
			print("not more stars")
			return
	
	
	print("save new stars: ", star_count)
	stars[num_players][current_level] = star_count
	
	
	var save_game = FileAccess.open(save_file_text, FileAccess.WRITE)
	save_game.store_line(JSON.stringify(stars))
	save_game.close()


func load_stars() -> void:
	if not FileAccess.file_exists(save_file_text):
		return
	
	
	var save_file = FileAccess.open(save_file_text, FileAccess.READ)
	var stars_json = save_file.get_line()
	
	
	var json = JSON.new()
	
	
	var parsed_stars = json.parse(stars_json)
	if not parsed_stars == OK:
		print("something went wrong when loading save file")
		return
	
	
	stars = json.data
	for players in stars:
		for level in stars[players]:
			stars[players][level] = int(stars[players][level])
	print("loaded stars: ", stars)



func restart_level() -> void:
	print("resetting level!")
	if get_node("/root/Node2D").get("robots_finished"):
		get_node("/root/Node2D").robots_finished.clear()
	
	
	get_node("/root/Node2D/star counter").restart_stars()
	for robot in get_node("/root/Node2D/robots").get_children():
		robot.respawn()
	
	
	get_node("/root/Node2D/code").problem_warning()
	get_node("/root/Node2D/code").stop_running_code()
	
	
	if get_node("/root/Node2D").has_node("doors"):
		for door in get_node("/root/Node2D/doors").get_children():
			door.reset()
	
	
	if get_node("/root/Node2D").has_node("lasers"):
		for laser in get_node("/root/Node2D/lasers").get_children():
			laser.reset()
	
	
	if get_node("/root/Node2D").has_node("items"):
		get_node("/root/Node2D/Container").restart()
		get_node("/root/Node2D/items").reset_items()


func complete_level_player_1() -> void:
	get_node("/root/Node2D/star counter").save_stars()
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("/root/Node2D/black"),"modulate:a", 1, 0.5)
	tween.tween_callback(next_level_player_1).set_delay(0.2)


func next_level_player_1() -> void:
	current_level = str(int(current_level)+1)
	
	
	var level_file_name = levels_1_player_path+"/"+levels_file_start+current_level+path_end
	if not FileAccess.file_exists(level_file_name):
		get_tree().change_scene_to_file(single_player_menu)
	
	
	get_tree().change_scene_to_file(level_file_name)


func next_level_player_2() -> void:
	current_level = str(int(current_level)+1)
	
	
	var level_file_name = levels_2_player_path+"/"+levels_file_start+current_level+path_end
	if not FileAccess.file_exists(level_file_name):
		get_tree().change_scene_to_file(multiplayer_level_selector)
	
	
	get_tree().change_scene_to_file(level_file_name)

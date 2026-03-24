extends Node2D

var levels_path = "res://levels/1 player"
var levels_file_start = "Level"
var path_end = ".tscn"


var level_buttons = preload("res://level button.tscn")


func _ready() -> void:
	Global.num_players = "1"
	Global.load_stars()
	
	
	add_buttons_from_files()


func add_buttons_from_files():
	var levels = []
	
	
	var files = ResourceLoader.list_directory(levels_path)
	for filename in files:
		if not (filename.begins_with(levels_file_start) and filename.ends_with(path_end)):
			continue
		
		#only get the level number
		var level_num = filename.replace(levels_file_start, "").replace(path_end, "")
		if not level_num.is_valid_int():
			print("????????")
			continue
		
		
		#turns into an int for sorting
		levels.append(int(level_num))
	levels.sort()
	
	
	add_level_buttons(levels)


func add_level_buttons(levels: Array) -> void:
	for level in levels:
		var button = level_buttons.instantiate()
		button.level = level
		level = str(level)
		
		
		if Global.stars[Global.num_players].has(level):
			button.add_stars(Global.stars[Global.num_players][level])
		
		
		button.level_file_name = levels_path+"/"+levels_file_start+level+path_end
		button.get_child(0).text = level
		get_node("levels").add_child(button, true)


func change_level(level_file_name: String, level: int) -> void:
	var level_scene = load(level_file_name)
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate:a", 0, 0.5)
	tween.tween_callback(Callable(get_tree(), "change_scene_to_packed").bind(level_scene)).set_delay(0.2)
	
	
	Global.current_level = str(level)


func _on_back_pressed() -> void:
	back()


func back():
	get_tree().change_scene_to_file("res://start_menu.tscn")

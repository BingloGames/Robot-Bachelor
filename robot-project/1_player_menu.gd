extends Node2D

var levels_path = "res://levels/1 player"
var levels_file_start = "Level"
var path_end = ".tscn"


func _ready() -> void:
	Global.num_players = "1"
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
		level = str(level)
		
		
		var button = Button.new()
		button.connect("pressed", _on_level_pressed.bind(level))
		button.text = level
		
		
		get_node("levels").add_child(button)


func change_level(level: String) -> void:
	var level_file_name = levels_path+"/"+levels_file_start+level+path_end
	var level_scene = load(level_file_name)
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate:a", 0, 0.5)
	tween.tween_callback(Callable(get_tree(), "change_scene_to_packed").bind(level_scene)).set_delay(0.2)
	
	
	Global.current_level = int(level)


func _on_level_pressed(level: String) -> void:
	#multiplayer needs these two functions to be seperate
	change_level(level)

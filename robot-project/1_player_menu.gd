extends Node2D

var levels_path = "res://levels/1 player"
var levels_file_start = "Level"
var path_end = ".tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levels = []
	
	
	var dir = DirAccess.open(levels_path)
	if dir == null:
		print("?????")
		return
	
	
	dir.list_dir_begin()
	var filename = dir.get_next()
	
	
	while not filename.is_empty():
		if not (filename.begins_with(levels_file_start) and filename.ends_with(path_end)):
			filename = dir.get_next()
			continue
		
		#only get the level number
		var level_num = filename.replace(levels_file_start, "").replace(path_end, "")
		if not level_num.is_valid_int():
			filename = dir.get_next()
			print("????????")
			continue
		
		
		levels.append(level_num)
		filename = dir.get_next()
	
	
	for level in levels:
		var button = Button.new()
		button.connect("pressed", _on_level_pressed.bind(level))
		button.text = level
		
		get_node("levels").add_child(button)


func _on_level_pressed(level: String) -> void:
	var level_file_name = levels_path+"/"+levels_file_start+level+path_end
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate:a", 0, 0.5)
	tween.tween_callback(Callable(get_tree(), "change_scene_to_file").bind(level_file_name)).set_delay(0.2)

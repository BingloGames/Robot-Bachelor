extends Control
var path = ""
var language = ""
var no_players = ""
var current_level = ""
var item = ""
var file_path = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path = Global.text_path
	language = Global.text_language
	no_players = "1"
	current_level = str(Global.current_level)
	item = no_players + " player" + "/Level" + current_level
	file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("RichTextLabel").set_text(content)
		else: 
			print("Error opening file: ", file)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_Close_pressed() -> void:
	get_node("ColorRect").hide()
	get_node("RichTextLabel").hide()
	get_node("Close").hide()
	get_node("Open").show()
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	pass # Replace with function body.


func _on_Open_pressed() -> void:
	get_node("Open").hide()
	get_node("ColorRect").show()
	get_node("RichTextLabel").show()
	get_node("Close").show()
	set_mouse_filter(MOUSE_FILTER_STOP)
	pass # Replace with function body.

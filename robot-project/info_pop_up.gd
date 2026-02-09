extends Control
var path = ""
var language = ""
var no_players = ""
var current_level = ""
var item = ""
var file_path = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path = Global.text_path
	var language = Global.text_language
	var no_players = "1"
	var current_level = str(Global.current_level)
	var item = no_players + " player" + "/Level" + current_level
	var file_path = path + language + item + ".txt"
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
	get_node("RichTextLabel").hide()
	get_node("Close").hide()
	get_node("Open").show()
	pass # Replace with function body.


func _on_Open_pressed() -> void:
	get_node("Open").hide()
	get_node("RichTextLabel").show()
	get_node("Close").show()
	pass # Replace with function body.

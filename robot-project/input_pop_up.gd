extends Control
@onready var path = Global.text_path
@onready var language = Global.text_language
var no_players = "1"
@onready var current_level = Global.current_level
var item = no_players + " player" + "/Question" + "/Level" + current_level

@export var Answer = "Answer = "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
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


func _on_button_pressed() -> void:
	var line = get_node("TextEdit").get_line(0)
	if line == Answer:
		if get_node("/root/Node2D/doors").has_node("Node2D"):
			var open = "door" #Change for open door function
			get_node("Input pop up").hide()
		else: 
			get_node("/root/Node2D/Container").add_item(Answer)
			return
	else: 
		return
	pass # Replace with function body.

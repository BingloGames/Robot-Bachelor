extends Control
var path = ""
var language = ""
var no_players = ""
var current_level = ""
var item = ""
var file_path = ""

@export var Answer = "answer ="
var Counter = 0
var left_counter = 0
var right_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	path = Global.text_path
	language = Global.text_language
	no_players = "1"
	current_level = str(Global.current_level)
	item = no_players + " player" + "/Question" + "/Level" + current_level
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
func _show() -> void:
	get_node("Input pop up").show()
	set_mouse_filter(MOUSE_FILTER_STOP)

func _on_button_pressed() -> void:
	var line = get_node("TextEdit").get_line(0)
	var line_array = line.strip_edges().to_lower().split(" ")
	if line_array[0] == "answer": 
		if line == Answer:
			get_node("/root/Node2D/doors/door").open()
			get_node("/root/Node2D/code").running_code = false
			get_node("Input pop up").hide()
			set_mouse_filter(MOUSE_FILTER_IGNORE)

	if line_array[0] == "import":
		if line_array[1] == "left()":
			if left_counter == 1:
				return
			else:
				get_node("/root/Node2D/Container/ItemList").add_item("left()")
				Counter += 1
				left_counter += 1
				var button = "/root/Node2D/Container/Button" + str(Counter+2)
				get_node(button).show()
				if Counter == 2:
					get_node("/root/Node2D/Input pop up").hide()
					set_mouse_filter(MOUSE_FILTER_IGNORE)
				else: 
					return
		if line_array[1] == "right()":
			if right_counter == 1:
				return
			else:
				get_node("/root/Node2D/Container/ItemList").add_item("right()")
				Counter += 1
				right_counter += 1
				var button = "/root/Node2D/Container/Button" + str(Counter+2)
				get_node(button).show()
				if Counter == 2:
					get_node("/root/Node2D/Input pop up").hide()
					set_mouse_filter(MOUSE_FILTER_IGNORE)
				else: 
					return

	else:
		return
		# add code not valid error.

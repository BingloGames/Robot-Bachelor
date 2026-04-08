extends Control


var itemsList = ["forward()", "backward()", "left()", "right()", "for i in range(n):", "wait()"]
@export var items = 2


var path = Global.text_path
var language = Global.text_language


@onready var list_node = get_node("ItemList")
@onready var text_node = get_node("Text")
@onready var code_node = get_node("/root/Node2D/code")


var button = ""
var item = ""


func _ready() -> void:
	create_buttons()
	

func create_buttons() -> void:
	for i in range(items):
		list_node.add_item(itemsList[i])
		button = str(i)
		get_node(button).show()
	
	
	list_node.set_allow_rmb_select(true)
	list_node.set_allow_reselect(true)	
	
func restart() -> void:
	list_node.clear()
	for i in range(7):
		button = str(i)
		get_node(button).hide()
	create_buttons()


func _on_button_mouse_entered(source: Button) -> void:
	var item_num = int(source.name)
	item = list_node.get_item_text(item_num)
	item = item.replace(":","")
	
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			text_node.set_text(content)
		else: 
			print("Error opening file: ", file)
	text_node.show()


func _on_button_mouse_exited() -> void:
	text_node.hide()


#Function so when we click on a function from the item list, it gets pasted in to the coding window:
func _on_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var thing = list_node.get_item_text(index)
	var function = thing + "\n"
	var text_edit = code_node.get_node("TextEdit")
	var line_limit = code_node.line_limit-1
	var current_line = text_edit.get_caret_line()
	var last_line = text_edit.get_line_count()-1
	var line_text = text_edit.get_line(current_line)
	var check_empty = line_text.strip_edges()
	
	
	if check_empty == "":
		if current_line < last_line:
			text_edit.insert_text_at_caret(thing, 0)
			text_edit.grab_focus()
			
			
		elif current_line == last_line and last_line == line_limit:
			text_edit.insert_text_at_caret(thing, 0)
			text_edit.grab_focus()
			print("current line is last line and in last possible line")
			
			
		elif current_line == last_line and last_line < line_limit:
			text_edit.insert_text_at_caret(function, 0)
			text_edit.grab_focus()
			print("current line is last line and smaller than line limit")
			
			
		else: 
			print ("How did you get here?")
			
			
	else:
		function = "\n" + function
		text_edit.insert_text_at_caret(function, 0)
		text_edit.grab_focus()

extends Control
class_name InformationList
##List of functions and other items with descriptions for each of them.

##List of preloaded functions
var itemsList = ["forward()", "backward()", "wait()", "left()", "right()", "for i in range(n):"]
##How many of the preloaded functions we show in each level.
@export var items = 2

##Path to the text files for information of each function.
var path = Global.text_path
##Selected language for the text files.
var language = Global.text_language

#region Node references
##The ItemList child of this node.
@onready var list_node = get_node("ItemList")
##The label child of this node.
@onready var text_node = get_node("Text")
##Path to the Code edit node.
@onready var code_node = get_node("/root/Node2D/CodeWindow")
#endregion


var button = ""
var item = ""


func _ready() -> void:
	create_buttons()
	
##Creates a information button per line in Item list that has an item.
func create_buttons() -> void:
	for i in range(items):
		list_node.add_item(itemsList[i])
		button = str(i)
		get_node(button).show()
	
	list_node.set_allow_rmb_select(true)
	list_node.set_allow_reselect(true)

##Empties the whole Item List and reloads the 
func restart() -> void:
	list_node.clear()
	for i in range(9):
		button = str(i)
		get_node(button).hide()
	create_buttons()

func _on_button_mouse_entered(source: Button) -> void:
	var item_num = int(source.name)
	item = list_node.get_item_text(item_num)
	item = item.replace(":","")
	var item_split = item.split(" ")
	if item_split[0] == "X" or item_split[0] == "Y":
		item = "variable"
	
	elif item_split[0] == "list":
		item = "list"
	else:
		item = item
		
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			text_node.set_text(content)
		else: 
			print("Error opening file: ", file)
	else:
		print("file: ", file_path, " does not exist")
	
	text_node.show()


func _on_button_mouse_exited() -> void:
	text_node.hide()

#Function so when we click on a function from the item list, it gets pasted in to the coding window:
func _on_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var thing = list_node.get_item_text(index)
	var function = thing + "\n"
	var text_edit = code_node.get_node("CodeEdit")
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
		
		elif current_line == last_line and last_line < line_limit:
			text_edit.insert_text_at_caret(function, 0)
			text_edit.grab_focus()
		
		else: 
			print ("How did you get here?")
	
	else:
		function = "\n" + function
		text_edit.insert_text_at_caret(function, 0)
		text_edit.grab_focus()

extends Control


var itemsList = ["forward()", "backward()", "wait()", "left()", "right()", "for i in range(n):" ,"X = ", "Y = ", "List = []"]
@export var items = 2


@onready var path = Global.text_path
@onready var language = Global.text_language
var button = ""
var item = ""


func _ready() -> void:
	for i in range(items):
		get_node("ItemList").add_item(itemsList[i])
		button = str(i)
		get_node(button).show()
	
	
	get_node("ItemList").set_allow_rmb_select(true)
	get_node("ItemList").set_allow_reselect(true)


func restart():
	get_node("ItemList").clear()
	for i in range(7):
		button = str(i)
		get_node(button).hide()
	_ready()

func _on_button_mouse_entered(source: Button) -> void:
	var item_num = int(source.name)
	item = get_node("ItemList").get_item_text(item_num)
	item = item.replace(":","")
	
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()


func _on_button_mouse_exited() -> void:
	get_node("Text").hide()


#Function so when we click on a function from the item list, it gets pasted in to the coding window:
func _on_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var thing = get_node("ItemList").get_item_text(index)
	var function = thing + "\n"
	var text_edit = get_node("/root/Node2D/code/TextEdit")
	var line_limit = get_node("/root/Node2D/code").line_limit-1
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

extends Control
var itemsList = ["forward()", "backward()", "left()", "right()", "for i in range(n):" ,"X = ", "Y = ", "List = []"]
@export var items = 2
var function = ""

@onready var path = Global.text_path
@onready var language = Global.text_language
var button = ""
var item = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(items):
		get_node("ItemList").add_item(itemsList[i])
		button = str(i)
		get_node(button).show()
	
	
	get_node("ItemList").set_allow_rmb_select(true)
	get_node("ItemList").set_allow_reselect(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	get_node("ItemList").set_allow_rmb_select(true)
#	get_node("ItemList").set_allow_reselect(true)
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
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var thing = get_node("ItemList").get_item_text(index)
	var function = thing + "\n"
	var text_edit = get_node("/root/Node2D/code/TextEdit")
	var line_limit = get_node("/root/Node2D/code").line_limit-1
	var current_line = text_edit.get_caret_line()
	var last_line = text_edit.get_line_count()-1
	print (current_line)
	print(last_line)
	print(line_limit)
	
	if current_line == last_line:
		if last_line < line_limit:
			text_edit.insert_text_at_caret(function, 0)
			text_edit.grab_focus()
			print("current line is last line and smaller than line limit")
		elif last_line == line_limit:
			text_edit.insert_text_at_caret(thing, 0)
			text_edit.grab_focus()
			print("current line is last line and in last possible line")
		else: 
			print ("No more lines")
			#I should add an Error line here
		#Add check empty here
	
	elif current_line < last_line:
		var line_text = text_edit.get_line(current_line)
		var check_empty = line_text.strip_edges()
		var check_indent = text_edit.get_indent_level(current_line)
		if check_empty == "":
			if check_indent == 0:
				text_edit.insert_text_at_caret(thing, 0)
				text_edit.grab_focus()
				print("current line is in the middle of the text and empty")
			elif check_indent != 0:
				text_edit.insert_text_at_caret("\t"+thing, 0)
				text_edit.grab_focus()
				print("curret line is in the middle of the text and indented")
		elif check_empty != "":
			print("There is text there already!")
			#I should add an Error line here
			
	else:
		print("How did you get here??")

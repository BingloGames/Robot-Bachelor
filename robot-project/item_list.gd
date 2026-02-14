extends Control
var itemsList = ["forward()", "backward()", "left()", "right()", "for i in range(n):" ,"X = ", "Y = ", "List = []"]
@export var items = 2
var function = ""

@onready var path = Global.text_path
@onready var language = Global.text_language

var item = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(items):
		get_node("ItemList").add_item(itemsList[i])
		var button = "Button" + str(i+1)
		get_node(button).show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("ItemList").set_allow_rmb_select(true)
	get_node("ItemList").set_allow_reselect(true)


#Button 1:
func _on_button_1_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(0)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_1_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 2: 
func _on_button_2_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(1)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_2_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 3:
func _on_button_3_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(2)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_3_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 4:
func _on_button_4_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(3)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_4_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 5:
func _on_button_5_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(4)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_5_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 6:
func _on_button_6_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(5)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_6_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 7:
func _on_button_7_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(6)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_7_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 8:
func _on_button_8_mouse_entered() -> void:
	item = get_node("ItemList").get_item_text(7)
	var file_path = path + language + item + ".txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file: 
			var content = file.get_as_text()
			get_node("Text").set_text(content)
		else: 
			print("Error opening file: ", file)
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_8_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Function so when we click on a function from the item list, it gets pasted in to the coding window:
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var item = get_node("ItemList").get_item_text(index)
	function = item + "\n"
	var line_limit = get_node("/root/Node2D/code").line_limit
	var current_line = get_node("/root/Node2D/code/TextEdit").get_line_count()
	if current_line > line_limit:
		print("more code lines than line limit")
		return
		
	if current_line == line_limit:
		var line = get_node("/root/Node2D/code/TextEdit").get_line(current_line-1).strip_edges()
		if line == "":
			get_node("/root/Node2D/code/TextEdit").text += item
			
	else:
		var line = get_node("/root/Node2D/code/TextEdit").get_line(current_line-1).strip_edges()
		if line == "":
			get_node("/root/Node2D/code/TextEdit").text += function
		
	"""
	This fix allows us to paste in other lines other than the last line, but we need to select the line after every paste,
	which makes it clunky AF, there has to be a way to move the "caret" or the line that indicates where we currently are
	but i cant seem to make it work, i may come back to it eventually.
	
	maybe an if current_line != last_line? 
	
	
	var item = get_node("ItemList").get_item_text(index)
	function = item + "\n"
	var line_limit = get_node("/root/Node2D/code").line_limit
	var current_line = get_node("/root/Node2D/code/TextEdit").get_caret_line()
	var last_line = get_node("/root/Node2D/code/TextEdit").get_line_count()
	if last_line > line_limit:
		print("more code lines than line limit")
		return
		
	if last_line == line_limit:
		var line = get_node("/root/Node2D/code/TextEdit").get_line(current_line).strip_edges()
		if line == "":
			get_node("/root/Node2D/code/TextEdit").text += item
			
	else:
		var line = get_node("/root/Node2D/code/TextEdit").get_line(current_line).strip_edges()
		if line == "":
			get_node("/root/Node2D/code/TextEdit").set_line(current_line, item)
	"""
	

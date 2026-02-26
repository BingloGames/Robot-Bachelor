extends Control
var itemsList = ["forward()", "backward()", "left()", "right()", "for i in range(n)" ,"X = ", "Y = ", "List = []"]
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
	function = thing + "\n"
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
	

extends Control
@export var itemsList = ["forward()", "backward()", "left()", "right()", "for i in range(n):" ,"X = ", "Y = ", "List = []"]
var items = 8
var function = ""
var path = "res://Texts"
var language = "/ENG/"
var item = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(items):
		get_node("ItemList").add_item(itemsList[i])
		var button = "Button" + str(i+1)
		get_node(button).show()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("ItemList").set_allow_rmb_select(true)
	get_node("ItemList").set_allow_reselect(true)
	pass


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
	get_node("Text").set_text("Text for backward()")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_2_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 3:
func _on_button_3_mouse_entered() -> void:
	get_node("Text").set_text("Text for left()")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_3_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 4:
func _on_button_4_mouse_entered() -> void:
	get_node("Text").set_text("Text for right()")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_4_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 5:
func _on_button_5_mouse_entered() -> void:
	get_node("Text").set_text("Text for for i in range(n):")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_5_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 6:
func _on_button_6_mouse_entered() -> void:
	get_node("Text").set_text("Text for X = ")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_6_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 7:
func _on_button_7_mouse_entered() -> void:
	get_node("Text").set_text("Text for Y = ")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_7_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Button 8:
func _on_button_8_mouse_entered() -> void:
	get_node("Text").set_text("Text for List = []")
	get_node("Text").show()
	pass # Replace with function body.

func _on_button_8_mouse_exited() -> void:
	get_node("Text").hide()
	pass # Replace with function body.

#Function so when we click on a function from the item list, it gets pasted in to the coding window:
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	function = str(itemsList[index]) + "\n"
	var line_limit = get_node("/root/Node2D/code").line_limit
	var current_line = get_node("/root/Node2D/code/TextEdit").get_line_count()
	if current_line >= line_limit:
		print("more code lines than line limit")
		return
	else:
		get_node("/root/Node2D/code/TextEdit").text += function
	pass # Replace with function body.
	# Example usage, assuming TextEdit node is named "MyTextEdit"

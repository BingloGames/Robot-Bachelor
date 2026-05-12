extends Control
class_name InputPopUp
##Text window for questions and tasks for levels. It gets the text from a text file automatically, if it exists. Can be used to add questions for buttons.

#region Node references
##The Line Edit child node.
@onready var line_edit_node = get_node("LineEdit")
##Path to the Code window node.
@onready var code_node = get_node("/root/Node2D/CodeWindow")
##Path to the Item List node.
@onready var item_list_node = get_node("/root/Node2D/InformationList")
##Path to the items inside Item List node.
@onready var itemsInItemList = item_list_node.items
#endregion

##List of possible accepted answer to the question or task.
@export var answers: Array[String] = ["answer="]

##Counter for the Import task.
var Counter = 0
##Counter for Import left.
var left_counter = 0
##Counter for Import right.
var right_counter = 0

##List of doors that the question answered opens.
var doors = []
##Tile where the robot will end up after answering the question and un-pausing the game.
var robot_next_tile_temp = {}


func _ready() -> void:
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	
	var text = Global.get_question_text()
	if text == "":
		print("error in getting text")
		return 
	
	get_node("RichTextLabel").set_text(text)


##Opens the input pop up.
func show_input() -> void:
	get_tree().paused = true
	
	show()
	set_mouse_filter(MOUSE_FILTER_STOP)

func _on_button_pressed() -> void:
	var line = line_edit_node.text
	var line_array = line.strip_edges().to_lower().split(" ")
	
	if line_array[0] == "import":
		import_func(line_array)
		return
	
	line = line.remove_chars(" ")
	
	for answer in answers:
		if not line == answer:
			continue
		
		correct_answer()
		return
	
	wrong_answer()

##If the answer in Line edit is correct, open the corresponding doors.
func correct_answer() -> void:
	hide_input()
	
	for door in doors:
		door.open()

##If the answer in Line edit is wrong, 
func wrong_answer() -> void:
	code_node.running_code = true
	hide_input()

##Hides input pop up.
func hide_input():
	hide()
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	
	get_tree().paused = false

##Function for the import task. Checks if the answer is one of the possible Import left or right, 
## and keeps count so each function can only be imported once, once both functions are imported,
## closes the input pop up.
func import_func(line_array: Array) -> void:
	if line_array[1] == "left()":
		if left_counter == 1:
			return
		
		item_list_node.get_node("ItemList").add_item("left()")
		Counter += 1
		left_counter += 1
		var button = str(Counter+itemsInItemList-1)
		item_list_node.get_node(button).show()
		line_edit_node.clear()
		
		if not Counter == 2:
			return
		
		hide()
		set_mouse_filter(MOUSE_FILTER_IGNORE)
		
	elif line_array[1] == "right()":
		if right_counter == 1:
			return
		
		item_list_node.get_node("ItemList").add_item("right()")
		Counter += 1
		right_counter += 1
		var button = str(Counter+itemsInItemList-1)
		item_list_node.get_node(button).show()
		line_edit_node.clear()
		
		if not Counter == 2:
			return
		hide()
		set_mouse_filter(MOUSE_FILTER_IGNORE)

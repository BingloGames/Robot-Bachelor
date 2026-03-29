extends Control


@onready var itemsInItemList = get_node("/root/Node2D/Container").items


@onready var line_edit_node = get_node("LineEdit")
@onready var code_node = get_node("/root/Node2D/code")
@onready var item_list_node = get_node("/root/Node2D/Container")


@export var answers: Array[String] = ["answer ="]
var Counter = 0
var left_counter = 0
var right_counter = 0


var doors = []
var robot_next_tile_temp = {}


func _ready() -> void:
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	
	
	var text = Global.get_question_text()
	if text == "":
		print("error in getting text")
		return 
	
	
	get_node("RichTextLabel").set_text(text)


func show_input() -> void:
	get_tree().paused = true
	
	
	#code_node.running_code = false
	show()
	set_mouse_filter(MOUSE_FILTER_STOP)


func _on_button_pressed() -> void:
	var line = line_edit_node.text
	var line_array = line.strip_edges().to_lower().split(" ")
	
	
	if line_array[0] == "import":
		import_func(line_array)
		return
	
	
	line = line.to_lower().remove_chars(" ")
	
	
	print("correct 1") 
	for answer in answers:
		if not line == answer:
			continue
		
		
		print("correct 2")
		correct_answer()
		return
	wrong_answer()


func correct_answer() -> void:
	hide_input()
	
	
	for door in doors:
		door.open()


func wrong_answer() -> void:
	get_node("/root/Node2D/code").running_code = true
	hide_input()


func hide_input():
	hide()
	set_mouse_filter(MOUSE_FILTER_IGNORE)
	
	
	get_tree().paused = false


func import_func(line_array: Array) -> void:
	#this should be redone. It will be a hassle to expand
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
		

extends Control
class_name InfoPopUp
##Text window for explanations at the begining of each level. It gets the text from a text file automatically, if it exists.

#region Node references
##The ColorRect child of this node.
@onready var color_rect_node = get_node("ColorRect")
##The Label child of this node.
@onready var text_node = get_node("RichTextLabel")
##The Close button child of this node.
@onready var close_node = get_node("Close")
##The Open button child of this node.
@onready var open_node = get_node("Open")
#endregion

func _ready() -> void:
	var text = Global.get_info_text()
	if text == "":
		print("error in getting text")
		return
	
	get_node("RichTextLabel").set_text(text)

func _on_Close_pressed() -> void:
	color_rect_node.hide()
	text_node.hide()
	close_node.hide()
	open_node.show()
	set_mouse_filter(MOUSE_FILTER_IGNORE)

func _on_Open_pressed() -> void:
	color_rect_node.show()
	text_node.show()
	close_node.show()
	open_node.hide()
	set_mouse_filter(MOUSE_FILTER_STOP)

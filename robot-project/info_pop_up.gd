extends Control


func _ready() -> void:
	var text = Global.get_info_text()
	if text == null:
		print("error in getting text")
		return
	
	
	get_node("RichTextLabel").set_text(text)


func _on_Close_pressed() -> void:
	get_node("ColorRect").hide()
	get_node("RichTextLabel").hide()
	get_node("Close").hide()
	get_node("Open").show()
	set_mouse_filter(MOUSE_FILTER_IGNORE)


func _on_Open_pressed() -> void:
	get_node("ColorRect").show()
	get_node("RichTextLabel").show()
	get_node("Close").show()
	get_node("Open").hide()
	set_mouse_filter(MOUSE_FILTER_STOP)

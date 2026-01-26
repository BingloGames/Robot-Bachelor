extends ItemList
@export var itemsList = ["forward()", "backward()", "left()", "right()", "for i in range(n)" ,"X = ", "Y = ", "List = []"]
var items = 2
var function = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(items):
		add_item(itemsList[i])
		var button = "/root/Node2D/Container/Button" + str(i+1)
		get_node(button).show()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_allow_rmb_select(true)
	set_allow_reselect(true)
	pass


#Button 1:
func _on_button_1_mouse_entered() -> void:
	get_node("/root/Node2D/Container/Button1/Label1").show()
	pass # Replace with function body.

func _on_button_1_mouse_exited() -> void:
	get_node("/root/Node2D/Container/Button1/Label1").hide()
	pass # Replace with function body.

#Button 2: 
func _on_button_2_mouse_entered() -> void:
	get_node("/root/Node2D/Container/Button2/Label2").show()
	pass # Replace with function body.

func _on_button_2_mouse_exited() -> void:
	get_node("/root/Node2D/Container/Button2/Label2").hide()
	pass # Replace with function body.


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	function = str(itemsList[index]) + "\n"
	get_node("/root/Node2D/TextEdit").text += function
	pass # Replace with function body.

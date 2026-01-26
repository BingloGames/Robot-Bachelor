extends ItemList
@export var itemsList = ["forward()", "backward()"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(itemsList)):
		add_item(itemsList[i])
	
	get_node("/root/Container/Button/Label").hide()
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	get_node("/root/Container/Button/Label").show()
	pass # Replace with function body.


func _on_button_mouse_exited() -> void:
	get_node("/root/Container/Button/Label").hide()
	pass # Replace with function body.

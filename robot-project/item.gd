extends Node2D
@export var Item = "Item"
var itemCollected = false
@onready var itemsInItemList = get_node("/root/Node2D/Container").items
var itemsCounter = 0

func respawn() -> void:
	show()
	itemCollected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if itemCollected:
		return
	
	get_node("/root/Node2D/Container/ItemList").add_item(Item)
	itemsCounter += 1
	var button = "/root/Node2D/Container/" + str(itemsCounter+itemsInItemList)
	show()
	
	hide()
	
	itemCollected = true

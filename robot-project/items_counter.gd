extends Node2D


var item_count = 0
@onready var itemsInItemList = get_node("/root/Node2D/Container").items


var items_collected = []


func reset_items() -> void:
	item_count = 0
	for item in items_collected:
		item.respawn()
	
	
	items_collected.clear()


func new_item(item: Item) -> void:
	item_count += 1
	items_collected.append(item)
	
	
	get_node("/root/Node2D/Container/ItemList").add_item(item.item_name)
	var button = "/root/Node2D/Container/" + str(item_count+itemsInItemList)
	get_node(button).show()

extends Node2D


var item_count = 0
@onready var item_list_node = get_node("/root/Node2D/Container")
@onready var itemsInItemList = item_list_node.items#does this work?


var items_collected = []


func reset_items() -> void:
	item_count = 0
	for item in items_collected:
		get_node(item).respawn()
		
	items_collected.clear()


func new_item(item_path: NodePath) -> void:
	item_count += 1
	items_collected.append(item_path)
	
	
	item_list_node.get_node("ItemList").add_item(get_node(item_path).item_name)
	var button = str(item_count+itemsInItemList-1)
	item_list_node.get_node(button).show()

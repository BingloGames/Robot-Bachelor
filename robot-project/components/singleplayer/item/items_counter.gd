extends Node2D
class_name ItemsCounter
##Keeps track of which Items have been picked up.

##Number of picked up items.
var item_count = 0
##Path to the Item List node.
@onready var item_list_node = get_node("/root/Node2D/Container")

@onready var itemsInItemList = item_list_node.items#does this work?

##List of items collected
var items_collected = []

##Resets count and list of picked up items, makes the picked up items reapear.
func reset_items() -> void:
	item_count = 0
	for item in items_collected:
		get_node(item).respawn()
		
	items_collected.clear()

##Adds the picked up item to the count, list and Item List.
func new_item(item_path: NodePath) -> void:
	item_count += 1
	items_collected.append(item_path)
	
	item_list_node.get_node("ItemList").add_item(get_node(item_path).item_name)
	var button = str(item_count+itemsInItemList-1)
	item_list_node.get_node(button).show()

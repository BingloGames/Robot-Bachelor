extends ItemsCounter
class_name MultiplayerItemCounter
##Keeps track of which Items have been picked up in a multiplayer setting.

##Adds the item in the server/clients.
func new_item(item_path: NodePath) -> void:
	if not multiplayer.is_server():
		return
	new_item_multiplayer.rpc(item_path)

##RPC that adds the picked up item to the count, list and Item List.
@rpc("call_local")
func new_item_multiplayer(item_path: NodePath) -> void:
	super.new_item(item_path)

##Resets the items for server/clients.
func reset_items() -> void:
	if not multiplayer.is_server():
		return
	reset_items_multiplayer.rpc()

##RPC that resets the items.
@rpc("call_local")
func reset_items_multiplayer() -> void:
	super.reset_items()

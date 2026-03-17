extends "res://items_counter.gd"


func new_item(item_path: NodePath) -> void:
	if not multiplayer.is_server():
		return
	new_item_multiplayer.rpc(item_path)


@rpc("call_local")
func new_item_multiplayer(item_path: NodePath):
	super.new_item(item_path)


func reset_items() -> void:
	if not multiplayer.is_server():
		return
	reset_items_multiplayer.rpc()


@rpc("call_local")
func reset_items_multiplayer():
	super.reset_items()

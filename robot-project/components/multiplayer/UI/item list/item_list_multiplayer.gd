extends "res://components/singleplayer/UI/item list/item_list.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemsList = ["forward()", "backward()", "wait()", "left()", "right()", "for i in range(n):"]
	super._ready()
	
	pass 

func restart() -> void:
	restart_multiplayer.rpc()
	
	
@rpc("call_local")
func restart_multiplayer() -> void:
	super.restart()
	

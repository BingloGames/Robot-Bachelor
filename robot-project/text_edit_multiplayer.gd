extends "res://text_edit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		robot = get_node("/root/Node2D/robot1")
	else:
		robot = get_node("/root/Node2D/robot2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

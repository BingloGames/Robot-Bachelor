extends Node

var inventory = []

var stars = {"level1" : 2}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func restart_level():
	get_node("/root/Node2D/star counter").restart_stars()
	get_node("/root/Node2D/robot").respawn()
	get_node("/root/Node2D/TextEdit").stop_running_code()

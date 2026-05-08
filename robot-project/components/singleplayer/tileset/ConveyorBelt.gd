extends Node2D


var dir
var speed
var turn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tile_data(Vector):
	#var tile = get_node("TileMapLayer").local_to_map(Vector)
	var tile_data = get_node("/root/Node2D/ConveyorBelt").get_cell_tile_data(Vector)
	dir = tile_data.get_custom_data("dir")
	speed = tile_data.get_custom_data("Speed")
	turn = tile_data.get_custom_data("Turn")
	print(dir,speed)
	

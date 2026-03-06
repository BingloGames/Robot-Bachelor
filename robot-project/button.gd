extends Area2D


@export_enum("red", "blue") var color: String = "blue"
@export var door: NodePath
@export var needs_holding: bool = false
@export var question = false


func _ready():
	var sprite = "res://"+color+" button.png"
	get_node("Sprite2D").texture = load(sprite)


func _on_body_entered(body: Node2D) -> void:
	activate()


func activate():
	if get_node("/root/Node2D/").has_node("Input pop up"):
		get_node("/root/Node2D/Input pop up").showInput()
	else:
		get_node(door).open()
	
	
	get_node("/root/Node2D/code").running_code = false


func _on_body_exited(body: Node2D) -> void:
	deactivate()


func deactivate():
	if not needs_holding:
		return
	get_node(door).close()

extends Area2D


@export_enum("red", "blue") var color: String = "blue"
@export var doors: Array[NodePath]
@export var needs_holding: bool = false
@export var question = false


func _ready() -> void:
	var sprite = "res://"+color+" button.png"
	get_node("Sprite2D").texture = load(sprite)


func _on_body_entered(body: Node2D) -> void:
	if not body is Robot:
		return
	activate()


func activate() -> void:
	print("activate button singleplayer")
	if question:
		for door in doors:
			get_node("/root/Node2D/Input pop up").doors.append(get_node(door))
		get_node("/root/Node2D/Input pop up").show_input()
	else:
		for door in doors:
			get_node(door).open()


func _on_body_exited(body: Node2D) -> void:
	if not body is Robot:
		return
	deactivate()


func deactivate() -> void:
	if not needs_holding:
		return
	for door in doors:
		get_node(door).close()
